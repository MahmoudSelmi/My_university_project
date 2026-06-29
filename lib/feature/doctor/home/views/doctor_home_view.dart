import 'dart:convert';
import 'package:auth_slmi/feature/doctor/home/views/ProjectDetailsView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorHomeView extends StatefulWidget {
  const DoctorHomeView({super.key});

  @override
  State<DoctorHomeView> createState() => _DoctorHomeViewState();
}

class _DoctorHomeViewState extends State<DoctorHomeView> {
  static const String _acceptedKey = 'doctor_accepted_projects';
  static const String _pendingKey = 'doctor_pending_requests';

  List<Map<String, dynamic>> _projects = [];
  int _pendingCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadAcceptedProjects();
    await _loadPendingCount();
    setState(() => _isLoading = false);
  }

  Future<void> _loadAcceptedProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedJson = prefs.getString(_acceptedKey);

    if (savedJson != null && jsonDecode(savedJson).isNotEmpty) {
      final List decoded = jsonDecode(savedJson);
      _projects =
          decoded
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
    } else {
      _projects = [];
    }
  }

  Future<void> _loadPendingCount() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedJson = prefs.getString(_pendingKey);
    if (savedJson != null && jsonDecode(savedJson).isNotEmpty) {
      final List decoded = jsonDecode(savedJson);
      _pendingCount = decoded.length;
    } else {
      _pendingCount = 0;
    }
  }

  Future<void> _deleteProject(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedJson = prefs.getString(_acceptedKey);

    if (savedJson != null && jsonDecode(savedJson).isNotEmpty) {
      final List decoded = jsonDecode(savedJson);
      List<Map<String, dynamic>> acceptedProjects =
          decoded
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();

      final deletedProject = acceptedProjects.removeAt(index);
      await prefs.setString(_acceptedKey, jsonEncode(acceptedProjects));
      await _returnToPending(deletedProject);
      await _loadData();
      _showSnackBar("🗑️ تم حذف المشروع وعودته للطلبات", false);
    }
  }

  Future<void> _returnToPending(Map<String, dynamic> project) async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedJson = prefs.getString(_pendingKey);
    List<Map<String, dynamic>> pendingRequests = [];

    if (savedJson != null && jsonDecode(savedJson).isNotEmpty) {
      final List decoded = jsonDecode(savedJson);
      pendingRequests =
          decoded
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
    }

    pendingRequests.removeWhere((p) => p['title'] == project['title']);
    pendingRequests.add(project);
    await prefs.setString(_pendingKey, jsonEncode(pendingRequests));
  }

  void _showSnackBar(String msg, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20.r),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHeader(),
                  SliverToBoxAdapter(
                    child: _buildSectionTitle(
                      "المشاريع القائمة (${_projects.length})",
                    ),
                  ),
                  _projects.isEmpty
                      ? SliverToBoxAdapter(child: _buildEmptyState())
                      : SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _buildProjectCard(
                              context,
                              _projects[index],
                              index,
                            ),
                            childCount: _projects.length,
                          ),
                        ),
                      ),
                  SliverToBoxAdapter(child: SizedBox(height: 120.h)),
                ],
              ),
    );
  }

  // 🎯 Empty State فاخر
  Widget _buildEmptyState() {
    return Container(
      height: 250.h,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E293B),
            const Color(0xFF1E293B).withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.05),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6366F1).withValues(alpha: 0.1),
                    const Color(0xFF8B5CF6).withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.inbox_rounded,
                color: const Color(0xFF6366F1).withValues(alpha: 0.5),
                size: 50.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "لا توجد مشاريع مقبولة حالياً",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "قم بقبول الطلبات من صفحة الطلبات 📋",
              style: TextStyle(
                color: Colors.grey.withValues(alpha: 0.6),
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🏠 Header فاخر
  Widget _buildHeader() => SliverToBoxAdapter(
    child: Container(
      padding: EdgeInsets.fromLTRB(24.w, 70.h, 24.w, 20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0F172A),
            const Color(0xFF1E293B).withValues(alpha: 0.3),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6366F1).withValues(alpha: 0.15),
                      const Color(0xFF8B5CF6).withValues(alpha: 0.05),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.medical_services_rounded,
                  color: const Color(0xFF6366F1),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "أهلاً دكتور 👋",
                    style: TextStyle(
                      color: Colors.grey.withValues(alpha: 0.7),
                      fontSize: 13.sp,
                    ),
                  ),
                  Text(
                    "لوحة التحكم",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 25.h),
          Row(
            children: [
              _statBox("إجمالي المشاريع", "${_projects.length}"),
              SizedBox(width: 12.w),
              _statBox("قيد المراجعة", "$_pendingCount"),
            ],
          ),
        ],
      ),
    ),
  );

  // 📊 Stat Box فاخر
  Widget _statBox(String label, String val) => Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E293B),
            const Color(0xFF1E293B).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.03),
            blurRadius: 30,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            val,
            style: TextStyle(
              color: const Color(0xFF6366F1),
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.withValues(alpha: 0.6),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );

  // 🎴 Project Card فاخر 4D
  Widget _buildProjectCard(
    BuildContext context,
    Map<String, dynamic> project,
    int index,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E293B),
            const Color(0xFF1E293B).withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.03),
            blurRadius: 50,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 💎 4D Glow Effect
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6366F1).withValues(alpha: 0.03),
                    Colors.transparent,
                  ],
                  radius: 1.0,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8B5CF6).withValues(alpha: 0.02),
                    Colors.transparent,
                  ],
                  radius: 1.0,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // المحتوى
          Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(28.r),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              DoctorProjectDetailsView(project: project),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                // 🎨 Number Badge فاخر
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(
                                          0xFF6366F1,
                                        ).withValues(alpha: 0.15),
                                        const Color(
                                          0xFF8B5CF6,
                                        ).withValues(alpha: 0.05),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF6366F1,
                                      ).withValues(alpha: 0.15),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    "#${index + 1}",
                                    style: TextStyle(
                                      color: const Color(
                                        0xFF6366F1,
                                      ).withValues(alpha: 0.7),
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    project['title'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // زر حذف فاخر
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      backgroundColor: const Color(0xFF1E293B),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          24.r,
                                        ),
                                        side: BorderSide(
                                          color: Colors.white.withValues(
                                            alpha: 0.05,
                                          ),
                                          width: 1,
                                        ),
                                      ),
                                      title: Row(
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            color: Colors.redAccent,
                                            size: 24.sp,
                                          ),
                                          SizedBox(width: 10.w),
                                          const Text(
                                            "حذف المشروع",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: const Text(
                                        "هل أنت متأكد من حذف هذا المشروع؟\nسيعود للطلبات المعلقة.",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20.w,
                                              vertical: 8.h,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              border: Border.all(
                                                color: Colors.grey.withValues(
                                                  alpha: 0.2,
                                                ),
                                              ),
                                            ),
                                            child: const Text(
                                              "إلغاء",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _deleteProject(index);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20.w,
                                              vertical: 8.h,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.redAccent.withValues(
                                                    alpha: 0.2,
                                                  ),
                                                  Colors.redAccent.withValues(
                                                    alpha: 0.1,
                                                  ),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              border: Border.all(
                                                color: Colors.redAccent
                                                    .withValues(alpha: 0.2),
                                              ),
                                            ),
                                            child: const Text(
                                              "حذف",
                                              style: TextStyle(
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.redAccent.withValues(alpha: 0.08),
                                    Colors.redAccent.withValues(alpha: 0.02),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.redAccent.withValues(
                                    alpha: 0.1,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.redAccent.withValues(alpha: 0.6),
                                size: 18.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.person_pin_rounded,
                            color: const Color(0xFF6366F1),
                            size: 14.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "قائد الفريق: ${project['leader']}",
                            style: TextStyle(
                              color: const Color(0xFF6366F1),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        project['desc'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.blueGrey.shade200,
                          fontSize: 13.sp,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildAvatarStack(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(
                                    0xFF6366F1,
                                  ).withValues(alpha: 0.1),
                                  const Color(
                                    0xFF8B5CF6,
                                  ).withValues(alpha: 0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color(
                                  0xFF6366F1,
                                ).withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "تفاصيل",
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF6366F1,
                                    ).withValues(alpha: 0.7),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: const Color(
                                    0xFF6366F1,
                                  ).withValues(alpha: 0.5),
                                  size: 10.sp,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
    child: Row(
      children: [
        Container(
          width: 3.w,
          height: 18.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );

  Widget _buildAvatarStack() => SizedBox(
    width: 70.w,
    height: 28.h,
    child: Stack(
      children: List.generate(
        3,
        (i) => Positioned(
          left: i * 16.0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF0F172A), width: 2),
            ),
            child: CircleAvatar(
              radius: 12.r,
              backgroundColor: Colors.blueAccent.withValues(alpha: 0.15),
              child: Icon(
                Icons.person_rounded,
                size: 14.sp,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
