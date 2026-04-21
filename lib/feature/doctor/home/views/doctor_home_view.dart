import 'package:auth_slmi/feature/doctor/home/views/ProjectDetailsView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorHomeView extends StatelessWidget {
  const DoctorHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // الداتا متخزنة هنا مباشرة عشان نلغي الـ Model
    final List<Map<String, dynamic>> projects = [
      {
        "title": "E-Commerce Platform",
        "leader": "محمود سلمي",
        "desc":
            "نظام متكامل للتجارة الإلكترونية يدعم تعدد التجار مع نظام دفع آمن وإدارة مخزون متطورة.",
        "members": [
          "محمود سلمي",
          "عبادي",
          "عبد الله أنور",
          "أحمد علي",
          "سارة محمد",
          "ياسين حسن",
          "ليلى إبراهيم",
          "مريم يوسف",
          "خالد منصور",
          "عمر فاروق",
        ],
      },
      {
        "title": "Smart Learning System",
        "leader": "عبادي",
        "desc":
            "منصة تعليمية تعتمد على الذكاء الاصطناعي لتخصيص المحتوى الدراسي بناءً على مستوى استيعاب الطلاب.",
        "members": [
          "عبادي",
          "عمر خالد",
          "زياد رأفت",
          "إبراهيم عادل",
          "نور الشريف",
          "هاني رمزي",
          "مي عز الدين",
          "كريم عبد العزيز",
          "منى زكي",
          "أحمد حلمي",
        ],
      },
      {
        "title": "Graduation Project Hub",
        "leader": "عبد الله انور",
        "desc":
            "منصة لإدارة مشاريع التخرج تسهل التواصل بين الطلاب والمشرفين وتتبع حالات القبول والرفض.",
        "members": [
          "عبد الله انور",
          "حسن يوسف",
          "فادي عضلات",
          "كمال أجسام",
          "بيبو مصطفى",
          "شيكابالا",
          "محمد صلاح",
          "تريزيجيه",
          "زيزو",
          "أفشة",
        ],
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeader(),
          SliverToBoxAdapter(child: _buildSectionTitle("المشاريع القائمة")),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildProjectCard(context, projects[index]),
              childCount: projects.length,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 120.h)),
        ],
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, Map<String, dynamic> project) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorProjectDetailsView(project: project),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project['title'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                "قائد الفريق: ${project['leader']}",
                style: TextStyle(
                  color: const Color(0xFF6366F1),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                project['desc'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.blueGrey.shade200,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAvatarStack(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white24,
                    size: 14.sp,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // الـ Widgets المساعدة (Header, Title, Stats)
  Widget _buildSectionTitle(String title) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
    child: Text(
      title,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
          child: CircleAvatar(
            radius: 12.r,
            backgroundColor: Colors.blueAccent.withOpacity(0.5),
            child: Icon(Icons.person, size: 14.sp, color: Colors.white70),
          ),
        ),
      ),
    ),
  );
  Widget _buildHeader() => SliverToBoxAdapter(
    child: Container(
      padding: EdgeInsets.fromLTRB(24.w, 70.h, 24.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("أهلاً دكتور  ", style: TextStyle(color: Colors.grey)),
          const Text(
            "لوحة التحكم",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 25.h),
          Row(
            children: [
              _statBox("إجمالي المشاريع", "3"),
              SizedBox(width: 15.w),
              _statBox("قيد المراجعة", "2"),
            ],
          ),
        ],
      ),
    ),
  );
  Widget _statBox(String label, String val) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: const TextStyle(
              color: Color(0xFF6366F1),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    ),
  );
}
