import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:auth_slmi/feature/doctor/Team/View/view.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// استيراد الشاشات الخاصة بك (تأكد من صحة المسارات)
import 'package:auth_slmi/feature/doctor/home/views/doctor_home_view.dart';
import 'package:auth_slmi/feature/doctor/RequestsView/Views/RequestsView.dart';
import 'package:auth_slmi/feature/doctor/profile/Views/ProfileDocView.dart';
import 'package:auth_slmi/feature/doctor/home/Manager/doctor_home_cubit.dart';

class DoctorMainLayout extends StatefulWidget {
  const DoctorMainLayout({super.key});

  @override
  State<DoctorMainLayout> createState() => _DoctorMainLayoutState();
}

class _DoctorMainLayoutState extends State<DoctorMainLayout> {
  int _currentIndex = 0;
  bool _isLoading = false;

  // 🔥 ميثود محاكاة الـ API لمدة 1.5 ثانية
  void _onTabTapped(int index) async {
    if (index == _currentIndex) return;

    setState(() {
      _isLoading = true;
    });

    // محاكاة الانتظار (1.5 ثانية)
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    setState(() {
      _currentIndex = index;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color accentIndigo = Color(0xFF6366F1);
    const Color navyDeep = Color(0xFF0F172A);

    return BlocProvider(
      // الكيوبيت متاح لكل الشاشات (Home, Teams, Requests)
      create: (context) => DoctorHomeCubit(),
      child: Scaffold(
        backgroundColor: navyDeep,
        body: Stack(
          children: [
            // 1. عرض الشاشات مع أنيميشن التلاشي
            Opacity(
              opacity: _isLoading ? 0.1 : 1.0,
              child: PageTransitionSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder:
                    (child, primary, secondary) => FadeThroughTransition(
                      animation: primary,
                      secondaryAnimation: secondary,
                      child: child,
                    ),
                child: _getScreen(_currentIndex),
              ),
            ),

            // 2. واجهة التحميل (Glassmorphism Loader)
            if (_isLoading)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  color: Colors.black26,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: accentIndigo,
                          strokeWidth: 4,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "جاري التحديث...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),

        // 3. شريط التنقل السفلي (المعدل)
        bottomNavigationBar: CurvedNavigationBar(
          index: _currentIndex,
          height: 65.h,
          items: <Widget>[
            _buildNavIcon(Icons.home_rounded, 0),
            _buildNavIcon(Icons.all_inbox_rounded, 1),
            _buildNavIcon(Icons.groups_rounded, 2),
            _buildNavIcon(Icons.person_rounded, 3),
          ],
          color: const Color(0xFF1E293B),
          buttonBackgroundColor: accentIndigo,
          backgroundColor: Colors.transparent,
          animationDuration: const Duration(milliseconds: 400),
          onTap: _isLoading ? null : _onTabTapped, // تعطيل الضغط وقت التحميل
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    return Icon(
      icon,
      size: 28.sp,
      color: _currentIndex == index ? Colors.white : Colors.blueGrey.shade400,
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const DoctorHomeView();
      case 1:
        return const RequestsView();
      case 2:
        return const TeamsViewdoc();
      case 3:
        return const ProfileDocView();
      default:
        return const DoctorHomeView();
    }
  }
}
