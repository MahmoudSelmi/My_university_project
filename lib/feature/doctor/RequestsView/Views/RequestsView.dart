import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:auth_slmi/feature/doctor/home/Manager/doctor_home_cubit.dart';

class RequestsView extends StatefulWidget {
  const RequestsView({super.key});

  @override
  State<RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends State<RequestsView> {
  // 🔥 لستة الـ 10 طلبات ببيانات مختلفة تماماً
  final List<Map<String, dynamic>> _requests = [
    {
      "title": "Smart City IoT",
      "leader": "أحمد حسن",
      "desc":
          "نظام ذكي لإدارة أعمدة الإنارة وحاويات النفايات باستخدام مستشعرات IoT.",
    },
    {
      "title": "Tele-Medicine App",
      "leader": "إبراهيم عادل",
      "desc":
          "تطبيق لربط المرضى بالأطباء في المناطق النائية عبر استشارات الفيديو.",
    },
    {
      "title": "Blockchain Voting",
      "leader": "ياسين حسن",
      "desc": "نظام تصويت إلكتروني آمن يعتمد على تقنية البلوكشين لمنع التزوير.",
    },
    {
      "title": "AR Museum Guide",
      "leader": "ليلى إبراهيم",
      "desc": "دليل سياحي للمتاحف يستخدم الواقع المعزز لشرح القطع الأثرية.",
    },
    {
      "title": "Cyber Security Suite",
      "leader": "مريم يوسف",
      "desc":
          "أداة متكاملة لاكتشاف الثغرات في الشبكات المحلية وتنبيه المسؤولين.",
    },
    {
      "title": "Green Energy Tracker",
      "leader": "خالد منصور",
      "desc": "لوحة تحكم لمراقبة إنتاج الطاقة الشمسية في المباني الإدارية.",
    },
    {
      "title": "Food Waste Reducer",
      "leader": "سارة أحمد",
      "desc": "منصة لربط المطاعم بالجمعيات الخيرية لتوزيع الطعام الفائض.",
    },
    {
      "title": "Auto Attendance System",
      "leader": "عمر فاروق",
      "desc": "نظام تسجيل حضور الطلاب عبر تقنية التعرف على الوجوه.",
    },
    {
      "title": "Stock Market Predictor",
      "leader": "نور الشريف",
      "desc": "استخدام الـ Machine Learning للتنبؤ بأسعار الأسهم اليومية.",
    },
    {
      "title": "Blind Assistant App",
      "leader": "هاني رمزي",
      "desc":
          "تطبيق يساعد المكفوفين على التعرف على الأشياء المحيطة بهم عبر الكاميرا.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 10.h),
              child: Text(
                "طلبات الإشراف (${_requests.length})",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child:
                  _requests.isEmpty
                      ? const Center(
                        child: Text(
                          "لا توجد طلبات حالياً",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                      : AnimationLimiter(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
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

  Widget _buildRequestCard(int index) {
    final data = _requests[index];
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  data['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.more_horiz, color: Colors.white24),
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            "الليدر: ${data['leader']}",
            style: TextStyle(
              color: const Color(0xFF6366F1),
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            data['desc'],
            maxLines: 2,
            style: TextStyle(
              color: Colors.blueGrey.shade200,
              fontSize: 13.sp,
              height: 1.4,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAvatarStack(), // صور الأشخاص زي الـ Home
              Row(
                children: [
                  _actionIconButton(
                    Icons.close,
                    Colors.redAccent,
                    () => _handleAction(index, "تم رفض الطلب", isAccept: false),
                  ),
                  SizedBox(width: 15.w),
                  _actionIconButton(Icons.check, const Color(0xFF10B981), () {
                    // إضافة للـ Home
                    DoctorHomeCubit.get(context).acceptProject({
                      "title": data['title'],
                      "leader": data['leader'],
                      "desc": data['desc'],
                      "members": [
                        data['leader'],
                        "أحمد",
                        "ياسين",
                        "سارة",
                        "ليلى",
                        "خالد",
                        "عمر",
                        "مريم",
                        "زياد",
                        "عبدالله",
                      ],
                    });
                    _handleAction(
                      index,
                      "تم قبول فريق ${data['leader']}",
                      isAccept: true,
                    );
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleAction(int index, String msg, {required bool isAccept}) {
    setState(() {
      _requests.removeAt(index); // يختفي فوراً من الصفحة
    });
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

  Widget _actionIconButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.2)),
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
            child: CircleAvatar(
              radius: 12.r,
              backgroundColor: const Color(0xFF0F172A),
              child: CircleAvatar(
                radius: 10.r,
                backgroundColor: Colors.blueGrey.withOpacity(0.2),
                child: Icon(Icons.person, size: 12.sp, color: Colors.white54),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
