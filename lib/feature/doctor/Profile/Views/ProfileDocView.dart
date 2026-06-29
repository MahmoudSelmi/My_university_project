import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:auth_slmi/core/helper/app_nav.dart';
import 'package:auth_slmi/feature/auth/Login/views/login_view.dart';
import 'package:auth_slmi/feature/doctor/home/views/doctor_home_view.dart';
import 'package:auth_slmi/feature/doctor/RequestsView/Views/RequestsView.dart';
import 'package:auth_slmi/feature/students/profile/Views/customer_service_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDocView extends StatefulWidget {
  const ProfileDocView({super.key});

  @override
  State<ProfileDocView> createState() => _ProfileDocViewState();
}

class _ProfileDocViewState extends State<ProfileDocView> {
  File? _profileImage;
  int _pendingCount = 0;
  int _projectsCount = 0;

  static const String _pendingKey = 'doctor_pending_requests';
  static const String _acceptedKey = 'doctor_accepted_projects';

  final TextEditingController _nameController = TextEditingController(
    text: "دكتور",
  );
  final TextEditingController _specController = TextEditingController(
    text: "نظم ومعلومات",
  );
  final TextEditingController _collegeController = TextEditingController(
    text: "",
  );
  final TextEditingController _typeController = TextEditingController(
    text: "دكتور",
  );

  @override
  void initState() {
    super.initState();
    _loadCounts();
    _loadSavedData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCounts();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specController.dispose();
    _collegeController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('doctor_name');
    final savedSpec = prefs.getString('doctor_spec');
    final savedCollege = prefs.getString('doctor_college');
    final savedType = prefs.getString('doctor_type');

    setState(() {
      if (savedName != null) _nameController.text = savedName;
      if (savedSpec != null) _specController.text = savedSpec;
      if (savedCollege != null) _collegeController.text = savedCollege;
      if (savedType != null) _typeController.text = savedType;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('doctor_name', _nameController.text);
    await prefs.setString('doctor_spec', _specController.text);
    await prefs.setString('doctor_college', _collegeController.text);
    await prefs.setString('doctor_type', _typeController.text);
  }

  Future<void> _loadCounts() async {
    final prefs = await SharedPreferences.getInstance();

    // جلب الطلبات المعلقة
    final String? pendingJson = prefs.getString(_pendingKey);
    int pending = 0;
    if (pendingJson != null && jsonDecode(pendingJson).isNotEmpty) {
      final List decoded = jsonDecode(pendingJson);
      pending = decoded.length;
    }

    // جلب المشاريع المقبولة
    final String? acceptedJson = prefs.getString(_acceptedKey);
    int projects = 0;
    if (acceptedJson != null && jsonDecode(acceptedJson).isNotEmpty) {
      final List decoded = jsonDecode(acceptedJson);
      projects = decoded.length;
    }

    if (mounted) {
      setState(() {
        _pendingCount = pending;
        _projectsCount = projects;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _profileImage = File(image.path));
  }

  void _showEditDialog() {
    final nameTmp = TextEditingController(text: _nameController.text);
    final specTmp = TextEditingController(text: _specController.text);
    final collegeTmp = TextEditingController(text: _collegeController.text);
    final typeTmp = TextEditingController(text: _typeController.text);

    showDialog(
      context: context,
      builder:
          (_) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: AlertDialog(
              backgroundColor: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.r),
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6366F1).withValues(alpha: 0.15),
                          const Color(0xFF8B5CF6).withValues(alpha: 0.05),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      color: const Color(0xFF6366F1),
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "تعديل البيانات",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogField(nameTmp, "الاسم", Icons.person_rounded),
                  SizedBox(height: 12.h),
                  _dialogField(specTmp, "التخصص", Icons.school_rounded),
                  SizedBox(height: 12.h),
                  _dialogField(
                    collegeTmp,
                    "الكلية",
                    Icons.location_city_rounded,
                  ),
                  SizedBox(height: 12.h),
                  _dialogField(
                    typeTmp,
                    "النوع (دكتور/طالب)",
                    Icons.badge_rounded,
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "إلغاء",
                    style: TextStyle(color: Colors.white38, fontSize: 13.sp),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 12.h,
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      _nameController.text = nameTmp.text;
                      _specController.text = specTmp.text;
                      _collegeController.text = collegeTmp.text;
                      _typeController.text = typeTmp.text;
                    });
                    await _saveData();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "حفظ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _dialogField(TextEditingController ctrl, String hint, IconData icon) {
    return TextField(
      controller: ctrl,
      textAlign: TextAlign.right,
      style: TextStyle(color: Colors.white, fontSize: 13.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white38, fontSize: 13.sp),
        prefixIcon: Icon(icon, color: const Color(0xFF6366F1), size: 18.sp),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  void _showNotificationsSheet() {
    final List<Map<String, dynamic>> notifications = [
      {
        "title": "طلب إشراف جديد",
        "body": "أحمد حسن يطلب إشرافك على مشروع Smart City IoT",
        "time": "منذ 10 دقائق",
        "icon": Icons.inbox_rounded,
        "color": const Color(0xFF6366F1),
        "read": false,
      },
      {
        "title": "تم قبول المشروع",
        "body": "تم قبول مشروع Tele-Medicine App بنجاح",
        "time": "منذ ساعة",
        "icon": Icons.check_circle_rounded,
        "color": const Color(0xFF10B981),
        "read": false,
      },
      {
        "title": "اجتماع الفريق",
        "body": "تذكير: اجتماع مع فريق Blockchain Voting غداً الساعة 10 صباحاً",
        "time": "منذ 3 ساعات",
        "icon": Icons.event_rounded,
        "color": const Color(0xFFF59E0B),
        "read": true,
      },
      {
        "title": "تقرير الأسبوع",
        "body": "التقرير الأسبوعي للمشاريع النشطة متاح الآن",
        "time": "منذ يوم",
        "icon": Icons.bar_chart_rounded,
        "color": const Color(0xFF3B82F6),
        "read": true,
      },
      {
        "title": "عضو جديد",
        "body": "تمت إضافة عضو جديد لفريق AR Museum Guide",
        "time": "منذ يومين",
        "icon": Icons.person_add_rounded,
        "color": const Color(0xFFC026D3),
        "read": true,
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (_) => Container(
            height: 520.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0F172A),
                  const Color(0xFF0F172A).withValues(alpha: 0.95),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Column(
              children: [
                SizedBox(height: 12.h),
                Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 3.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "الإشعارات",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF6366F1).withValues(alpha: 0.15),
                              const Color(0xFF8B5CF6).withValues(alpha: 0.05),
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
                          "2 جديد",
                          style: TextStyle(
                            color: const Color(0xFF6366F1),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: notifications.length,
                    itemBuilder: (_, i) {
                      final n = notifications[i];
                      return Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              n['read']
                                  ? Colors.white.withValues(alpha: 0.02)
                                  : (n['color'] as Color).withValues(
                                    alpha: 0.06,
                                  ),
                              Colors.transparent,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(
                            color:
                                n['read']
                                    ? Colors.white.withValues(alpha: 0.04)
                                    : (n['color'] as Color).withValues(
                                      alpha: 0.2,
                                    ),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    (n['color'] as Color).withValues(
                                      alpha: 0.12,
                                    ),
                                    (n['color'] as Color).withValues(
                                      alpha: 0.05,
                                    ),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                n['icon'] as IconData,
                                color: n['color'] as Color,
                                size: 16.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        n['title'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (!n['read'])
                                        Container(
                                          width: 6.r,
                                          height: 6.r,
                                          decoration: BoxDecoration(
                                            color: n['color'] as Color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    n['body'],
                                    style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: 10.sp,
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    n['time'],
                                    style: TextStyle(
                                      color: Colors.white24,
                                      fontSize: 9.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    HapticFeedback.mediumImpact();
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: AlertDialog(
              backgroundColor: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.r),
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.power_settings_new_rounded,
                      color: Colors.redAccent,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "تسجيل الخروج",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              content: Text(
                "هل أنت متأكد من تسجيل الخروج؟",
                style: TextStyle(color: Colors.white54, fontSize: 13.sp),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    "إلغاء",
                    style: TextStyle(color: Colors.white54, fontSize: 14.sp),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 12.h,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    "خروج",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
    if (confirm != true) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    if (!context.mounted) return;
    MyNavigator.goTo(
      context,
      const LoginView(),
      type: NavigatorType.pushAndRemoveUntil,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // 💎 4D Glow Orbs
          Positioned(
            top: -80.h,
            right: -60.w,
            child: _buildGlowOrb(
              const Color(0xFF6366F1).withValues(alpha: 0.08),
            ),
          ),
          Positioned(
            bottom: 150.h,
            left: -60.w,
            child: _buildGlowOrb(
              const Color(0xFF8B5CF6).withValues(alpha: 0.05),
            ),
          ),
          Positioned(
            top: 300.h,
            right: -40.w,
            child: _buildGlowOrb(
              const Color(0xFF10B981).withValues(alpha: 0.03),
            ),
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildProfileCard()),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                sliver: SliverToBoxAdapter(child: _buildStatsRow(context)),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 0),
                sliver: SliverToBoxAdapter(child: _buildAcademicSection()),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
                sliver: SliverToBoxAdapter(
                  child: _buildSettingsSection(context),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
                sliver: SliverToBoxAdapter(child: _buildLogoutBtn(context)),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 130.h)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 260.h,
      child: Stack(
        children: [
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF6366F1).withValues(alpha: 0.2),
                  const Color(0xFF8B5CF6).withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.4),
                            blurRadius: 30,
                            spreadRadius: 2,
                          ),
                          BoxShadow(
                            color: const Color(
                              0xFF8B5CF6,
                            ).withValues(alpha: 0.2),
                            blurRadius: 50,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 52.r,
                        backgroundColor: const Color(0xFF0F172A),
                        backgroundImage:
                            _profileImage != null
                                ? FileImage(_profileImage!)
                                : null,
                        child:
                            _profileImage == null
                                ? Icon(
                                  Icons.person_outline_rounded,
                                  size: 42.sp,
                                  color: Colors.white24,
                                )
                                : null,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(7.r),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF0F172A),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.3),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _nameController.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: _showEditDialog,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF6366F1).withValues(alpha: 0.1),
                        const Color(0xFF8B5CF6).withValues(alpha: 0.05),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    color: Colors.white24,
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            alignment: WrapAlignment.center,
            children: [
              _buildChip(
                _specController.text,
                const Color(0xFF6366F1),
                Icons.school_rounded,
              ),
              _buildChip(
                _typeController.text,
                const Color(0xFF10B981),
                Icons.badge_rounded,
              ),
              if (_collegeController.text.isNotEmpty)
                _buildChip(
                  _collegeController.text,
                  const Color(0xFFF59E0B),
                  Icons.location_city_rounded,
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            "zeyadnull@gmail.com",
            style: TextStyle(color: Colors.white38, fontSize: 11.sp),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildChip(String text, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color.withValues(alpha: 0.7), size: 12.sp),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyle(
              color: color.withValues(alpha: 0.8),
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              MyNavigator.goTo(
                context,
                const RequestsView(),
              ).then((_) => _loadCounts());
            },
            child: _statCard(
              "طلبات الإشراف",
              "$_pendingCount",
              Icons.inbox_rounded,
              const Color(0xFF6366F1),
              subtitle: "في الانتظار",
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              MyNavigator.goTo(
                context,
                const DoctorHomeView(),
              ).then((_) => _loadCounts());
            },
            child: _statCard(
              "المشاريع المقبولة",
              "$_projectsCount",
              Icons.folder_copy_rounded,
              const Color(0xFF10B981),
              subtitle: "مشروع مقبول",
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _statCard(
            "سنوات الخبرة",
            "12",
            Icons.workspace_premium_rounded,
            const Color(0xFFF59E0B),
            subtitle: "خبرة أكاديمية",
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    String title,
    String val,
    IconData icon,
    Color color, {
    String subtitle = "",
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E293B),
            const Color(0xFF1E293B).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.12),
                  color.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
            ),
            child: Icon(icon, color: color, size: 18.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            val,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(color: color.withValues(alpha: 0.2), blurRadius: 10),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            style: TextStyle(color: Colors.white38, fontSize: 8.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel("المعلومات الأكاديمية"),
        SizedBox(height: 12.h),
        _infoTile(
          Icons.alternate_email_rounded,
          "البريد الجامعي",
          "zeyadnull@gmail.com",
          const Color(0xFF6366F1),
        ),
        _infoTile(
          Icons.school_rounded,
          "التخصص",
          _specController.text,
          const Color(0xFF3B82F6),
        ),
        _infoTile(
          Icons.badge_rounded,
          "النوع",
          _typeController.text.isEmpty ? "دكتور" : _typeController.text,
          const Color(0xFF10B981),
        ),
        if (_collegeController.text.isNotEmpty)
          _infoTile(
            Icons.location_city_rounded,
            "الكلية",
            _collegeController.text,
            const Color(0xFFF59E0B),
          ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel("الإعدادات والدعم"),
        SizedBox(height: 12.h),
        _actionTile(
          Icons.support_agent_rounded,
          "مركز خدمة العملاء",
          "تواصل مع الدعم الفني",
          const Color(0xFFF43F5E),
          onTap: () => MyNavigator.goTo(context, const CustomerServiceView()),
        ),
        _actionTile(
          Icons.notifications_rounded,
          "الإشعارات",
          "عرض آخر التنبيهات",
          const Color(0xFF6366F1),
          onTap: _showNotificationsSheet,
          badge: 2,
        ),
      ],
    );
  }

  Widget _infoTile(IconData icon, String title, String sub, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E293B),
            const Color(0xFF1E293B).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.1),
                  color.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 16.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.white38, fontSize: 10.sp),
                ),
                SizedBox(height: 2.h),
                Text(
                  sub,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionTile(
    IconData icon,
    String title,
    String sub,
    Color color, {
    required VoidCallback onTap,
    int badge = 0,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E293B),
            const Color(0xFF1E293B).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
        leading: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: color, size: 16.sp),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          sub,
          style: TextStyle(color: Colors.white38, fontSize: 10.sp),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge > 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.15),
                      color.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: color.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                child: Text(
                  "$badge",
                  style: TextStyle(
                    color: color,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(width: 6.w),
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white24,
                size: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => _logout(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.redAccent.withValues(alpha: 0.06),
              Colors.redAccent.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: Colors.redAccent.withValues(alpha: 0.15),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.power_settings_new_rounded,
              color: Colors.redAccent.withValues(alpha: 0.7),
              size: 20.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              "تسجيل الخروج",
              style: TextStyle(
                color: Colors.redAccent.withValues(alpha: 0.8),
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String title) => Row(
    children: [
      Container(
        width: 3.w,
        height: 14.h,
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
          color: Colors.white54,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    ],
  );

  Widget _buildGlowOrb(Color color) => Container(
    width: 250.r,
    height: 250.r,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
    ),
  );
}
