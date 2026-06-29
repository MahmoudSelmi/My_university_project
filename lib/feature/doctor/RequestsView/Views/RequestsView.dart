import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestsView extends StatefulWidget {
  const RequestsView({super.key});

  @override
  State<RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends State<RequestsView> {
  static const String _pendingKey = 'doctor_pending_requests';
  static const String _acceptedKey = 'doctor_accepted_projects';

  final List<Map<String, dynamic>> _defaultRequests = [
    {
      "title": "Smart City IoT System",
      "leader": "أحمد حسن",
      "desc":
          "نظام ذكي لإدارة أعمدة الإنارة وحاويات النفايات باستخدام مستشعرات IoT متطورة.",
      "members": ["أحمد حسن", "محمد علي", "سارة خالد", "ياسين عمر", "ليلى حسن"],
    },
    {
      "title": "Tele-Medicine Platform",
      "leader": "إبراهيم عادل",
      "desc":
          "منصة طبية لربط المرضى بالأطباء في المناطق النائية عبر استشارات الفيديو.",
      "members": [
        "إبراهيم عادل",
        "نور أحمد",
        "خالد منصور",
        "مريم يوسف",
        "عمر فاروق",
      ],
    },
    {
      "title": "Blockchain Voting System",
      "leader": "ياسين حسن",
      "desc":
          "نظام تصويت إلكتروني آمن يعتمد على تقنية البلوكشين لمنع التزوير وضمان الشفافية.",
      "members": [
        "ياسين حسن",
        "هاني رمزي",
        "سلمى عبدالله",
        "كريم محمود",
        "دينا وليد",
      ],
    },
    {
      "title": "AR Museum Guide",
      "leader": "ليلى إبراهيم",
      "desc":
          "دليل سياحي تفاعلي للمتاحف يستخدم الواقع المعزز لشرح القطع الأثرية.",
      "members": [
        "ليلى إبراهيم",
        "أحمد سامي",
        "رنا حسين",
        "تامر صالح",
        "نادية عمر",
      ],
    },
    {
      "title": "AI Learning Assistant",
      "leader": "محمود خالد",
      "desc":
          "مساعد تعليمي ذكي يستخدم الذكاء الاصطناعي لتخصيص المحتوى الدراسي للطلاب.",
      "members": [
        "محمود خالد",
        "منى زكي",
        "كريم عبدالعزيز",
        "شيرين رضا",
        "أحمد مجدي",
      ],
    },
    {
      "title": "Smart Agriculture System",
      "leader": "نورا سعيد",
      "desc": "نظام ذكي للزراعة يستخدم الحساسات لمراقبة التربة والري الآلي.",
      "members": [
        "نورا سعيد",
        "حسن يوسف",
        "فاطمة الزهراء",
        "عمر الشافعي",
        "ليلى كريم",
      ],
    },
    {
      "title": "E-Learning Platform",
      "leader": "طارق حسين",
      "desc": "منصة تعليمية متكاملة تقدم محتوى تفاعلي مع نظام تقييم ذكي.",
      "members": [
        "طارق حسين",
        "سلمى رشدي",
        "أحمد عصام",
        "منة الله",
        "يوسف هاني",
      ],
    },
    {
      "title": "Health Tracker App",
      "leader": "دينا محمود",
      "desc":
          "تطبيق لمتابعة الصحة اليومية مع تحليل البيانات وتقديم نصائح مخصصة.",
      "members": [
        "دينا محمود",
        "محمد فتحي",
        "نورهان علي",
        "أحمد سمير",
        "سارة رجب",
      ],
    },
    {
      "title": "Smart Parking System",
      "leader": "هشام عبدالله",
      "desc":
          "نظام ذكي لإدارة مواقف السيارات باستخدام IoT وتطبيق جوال للمستخدمين.",
      "members": [
        "هشام عبدالله",
        "إيمان شريف",
        "خالد محمد",
        "روان أحمد",
        "محمد صلاح",
      ],
    },
    {
      "title": "Cybersecurity Suite",
      "leader": "مروان فكري",
      "desc": "مجموعة أدوات متكاملة للأمن السيبراني لحماية الشبكات والبيانات.",
      "members": [
        "مروان فكري",
        "أسماء كمال",
        "عمر أشرف",
        "نادين سمير",
        "أحمد رأفت",
      ],
    },
  ];

  List<Map<String, dynamic>> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedJson = prefs.getString(_pendingKey);

    final String? acceptedJson = prefs.getString(_acceptedKey);
    List<String> acceptedTitles = [];
    if (acceptedJson != null && jsonDecode(acceptedJson).isNotEmpty) {
      final List decoded = jsonDecode(acceptedJson);
      acceptedTitles =
          decoded.whereType<Map>().map((e) => e['title'].toString()).toList();
    }

    setState(() {
      if (savedJson != null && jsonDecode(savedJson).isNotEmpty) {
        final List decoded = jsonDecode(savedJson);
        _requests =
            decoded
                .whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e))
                .toList();
      } else {
        _requests = List<Map<String, dynamic>>.from(
          _defaultRequests
              .where((e) => !acceptedTitles.contains(e['title']))
              .toList(),
        );
        _saveRequests();
      }
      _isLoading = false;
    });
  }

  Future<void> _saveRequests() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pendingKey, jsonEncode(_requests));
  }

  Future<void> _saveAcceptedProject(Map<String, dynamic> project) async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedJson = prefs.getString(_acceptedKey);
    List<Map<String, dynamic>> acceptedProjects = [];

    if (savedJson != null && jsonDecode(savedJson).isNotEmpty) {
      final List decoded = jsonDecode(savedJson);
      acceptedProjects =
          decoded
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
    }

    acceptedProjects.removeWhere((p) => p['title'] == project['title']);
    acceptedProjects.add(project);
    await prefs.setString(_acceptedKey, jsonEncode(acceptedProjects));
  }

  void _handleReject(int index) {
    setState(() => _requests.removeAt(index));
    _saveRequests();
    _showSnackBar("❌ تم رفض الطلب", false);
  }

  void _handleAccept(int index) async {
    final data = _requests[index];
    await _saveAcceptedProject(data);
    setState(() => _requests.removeAt(index));
    _saveRequests();
    _showSnackBar("✅ تم قبول فريق ${data['leader']} 🎉", true);
  }

  void _showSnackBar(String msg, bool isAccept) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isAccept ? const Color(0xFF10B981) : Colors.redAccent,
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎯 Header فاخر
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 3.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "طلبات الإشراف (${_requests.length})",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6366F1).withValues(alpha: 0.1),
                          const Color(0xFF8B5CF6).withValues(alpha: 0.05),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                        width: 1.2,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () => _loadRequests(),
                      icon: Icon(
                        Icons.refresh_rounded,
                        color: const Color(0xFF6366F1).withValues(alpha: 0.7),
                        size: 22.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _requests.isEmpty
                      ? _buildEmptyState()
                      : AnimationLimiter(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          itemCount: _requests.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: _buildRequestCard(index),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  // 🎯 Empty State فاخر
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF10B981).withValues(alpha: 0.1),
                  const Color(0xFF10B981).withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: const Color(0xFF10B981).withValues(alpha: 0.7),
              size: 50.sp,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "تم قبول جميع الطلبات 🎉",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "لا توجد طلبات معلقة حالياً",
            style: TextStyle(
              color: Colors.grey.withValues(alpha: 0.6),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  // 🎴 Request Card فاخر 4D
  Widget _buildRequestCard(int index) {
    final data = _requests[index];
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
          // 💎 4D Glow Effects
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
          Padding(
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
                              data['title'],
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
                    Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.more_horiz_rounded,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 18.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                // 👤 Leader مع أيقونة
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.r),
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
                        Icons.person_pin_rounded,
                        color: const Color(0xFF6366F1),
                        size: 16.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "الليدر: ${data['leader']}",
                      style: TextStyle(
                        color: const Color(0xFF6366F1),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // 📝 Description
                Text(
                  data['desc'],
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.blueGrey.shade200,
                    fontSize: 13.sp,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 20.h),
                // 🎯 Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAvatarStack(),
                    Row(
                      children: [
                        _actionIconButton(
                          Icons.close_rounded,
                          Colors.redAccent,
                          () => _handleReject(index),
                        ),
                        SizedBox(width: 12.w),
                        _actionIconButton(
                          Icons.check_rounded,
                          const Color(0xFF10B981),
                          () => _handleAccept(index),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionIconButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.15), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 20.sp),
      ),
    );
  }

  Widget _buildAvatarStack() {
    return SizedBox(
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
                backgroundColor: Colors.blueGrey.withValues(alpha: 0.15),
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
}
