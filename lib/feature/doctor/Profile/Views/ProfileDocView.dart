import 'dart:io';
import 'dart:ui';
import 'package:auth_slmi/core/helper/app_nav.dart';
import 'package:auth_slmi/feature/auth/Login/views/login_view.dart';
import 'package:auth_slmi/feature/auth/forget_pass/views/forget_pass_view.dart';
import 'package:auth_slmi/feature/doctor/Team/View/view.dart';
import 'package:auth_slmi/feature/doctor/home/views/doctor_home_view.dart';
import 'package:auth_slmi/feature/doctor/RequestsView/Views/RequestsView.dart';
import 'package:auth_slmi/feature/students/profile/Views/customer_service_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart'; // تأكد من إضافة المكتبة في pubspec.yaml
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDocView extends StatefulWidget {
  const ProfileDocView({super.key});

  @override
  State<ProfileDocView> createState() => _ProfileDocViewState();
}

class _ProfileDocViewState extends State<ProfileDocView> {
  File? _profileImage;

  // ميثود اختيار الصورة من المعرض
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
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
      backgroundColor: const Color(0xFF020617),
      body: Stack(
        children: [
          // تأثيرات الخلفية الزجاجية
          Positioned(
            top: -50.h,
            right: -50.w,
            child: _buildGlowOrb(const Color(0xFF6366F1).withOpacity(0.12)),
          ),
          Positioned(
            bottom: 100.h,
            left: -50.w,
            child: _buildGlowOrb(const Color(0xFFC026D3).withOpacity(0.08)),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // رأس البروفايل (الصورة واللقب فقط)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 70.h, bottom: 30.h),
                  child: _buildHeroProfile(),
                ),
              ),

              // الإحصائيات التفاعلية
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                sliver: SliverToBoxAdapter(
                  child: _buildInteractiveStats(context),
                ),
              ),

              // القوائم
              SliverPadding(
                padding: EdgeInsets.all(24.r),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionHeader("المعلومات الأكاديمية"),
                    _buildInfoGlassTile(
                      Icons.alternate_email_rounded,
                      "بريد دكتور",
                      "dr.manager@university.edu.eg",
                    ),
                    _buildInfoGlassTile(
                      Icons.star_border_rounded,
                      "التخصص الأكاديمي",
                      "",
                    ),

                    SizedBox(height: 25.h),
                    _buildSectionHeader("الإعدادات والدعم"),

                    _buildActionGlassTile(
                      Icons.support_agent_rounded,
                      "مركز خدمة العملاء",
                      "تواصل مع الدعم الفني",
                      const Color(0xFFF43F5E),
                      onTap:
                          () => MyNavigator.goTo(
                            context,
                            const CustomerServiceView(),
                          ),
                    ),

                    _buildActionGlassTile(
                      Icons.lock_open_rounded,
                      "استعادة كلمة المرور",
                      "تحديث بيانات الأمان",
                      const Color(0xFF10B981),
                      onTap:
                          () =>
                              MyNavigator.goTo(context, const ForgetPassView()),
                    ),

                    SizedBox(height: 40.h),
                    _buildBlurLogoutBtn(context),
                    SizedBox(height: 120.h),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroProfile() {
    return Column(
      children: [
        // قسم الصورة مع زر الإضافة
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                  ),
                ),
                child: CircleAvatar(
                  radius: 55.r,
                  backgroundColor: const Color(0xFF1E293B),
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  child:
                      _profileImage == null
                          ? Icon(
                            Icons.person_outline_rounded,
                            size: 45.sp,
                            color: Colors.white24,
                          )
                          : null,
                ),
              ),
              // زر الكاميرا الصغير
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: Color(0xFF6366F1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          "دكتور",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        // البايو تم حذفه بناءً على طلبك ليبقى المكان نظيفاً
      ],
    );
  }

  Widget _buildInteractiveStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => MyNavigator.goTo(context, const RequestsView()),
          child: _statGlassCard(
            "إدارة الطلبات",
            "12",
            Icons.all_inbox_rounded,
            const Color(0xFF6366F1),
            isClickable: true,
          ),
        ),
        GestureDetector(
          onTap: () => MyNavigator.goTo(context, const TeamsViewdoc()),
          child: _statGlassCard(
            "طالب",
            "45",
            Icons.school_rounded,
            const Color(0xFF10B981),
            isClickable: true,
          ),
        ),
        GestureDetector(
          onTap: () => MyNavigator.goTo(context, const DoctorHomeView()),
          child: _statGlassCard(
            "مشاريع",
            "03",
            Icons.folder_copy_rounded,
            const Color(0xFF3B82F6),
            isClickable: true,
          ),
        ),
      ],
    );
  }

  Widget _statGlassCard(
    String title,
    String val,
    IconData icon,
    Color color, {
    bool isClickable = false,
  }) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.5),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color:
              isClickable
                  ? color.withOpacity(0.4)
                  : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18.sp),
          SizedBox(height: 12.h),
          Text(
            val,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 9.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGlassTile(IconData icon, String title, String sub) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6366F1), size: 18.sp),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white38, fontSize: 10.sp),
              ),
              Text(
                sub,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionGlassTile(
    IconData icon,
    String title,
    String sub,
    Color color, {
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color, size: 20.sp),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          sub,
          style: TextStyle(color: Colors.white38, fontSize: 10.sp),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white24,
          size: 12,
        ),
      ),
    );
  }

  Widget _buildBlurLogoutBtn(BuildContext context) {
    return InkWell(
      onTap: () => _logout(context),
      borderRadius: BorderRadius.circular(22.r),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 18.h),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.04),
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(color: Colors.redAccent.withOpacity(0.15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.power_settings_new_rounded,
                  color: Colors.redAccent,
                ),
                SizedBox(width: 12.w),
                Text(
                  "إنهاء الجلسة الآمنة",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) => Padding(
    padding: EdgeInsets.only(bottom: 15.h, right: 6.w),
    child: Text(
      title,
      style: TextStyle(
        color: const Color(0xFF6366F1),
        fontSize: 12.sp,
        fontWeight: FontWeight.w900,
      ),
    ),
  );

  Widget _buildGlowOrb(Color color) => Container(
    width: 230.r,
    height: 230.r,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(color: color, blurRadius: 90, spreadRadius: 40)],
    ),
  );
}
