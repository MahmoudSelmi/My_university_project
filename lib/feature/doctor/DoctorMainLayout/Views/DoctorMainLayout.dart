import 'package:animations/animations.dart';
import 'package:auth_slmi/feature/doctor/Teams/Teams.dart';
import 'package:auth_slmi/feature/doctor/home/views/doctor_home_view.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../RequestsView/Views/RequestsView.dart';
import '../../All Projects/Views/All Projects.dart';
import '../../Profile/Views/Profile.dart';

class DoctorMainLayout extends StatefulWidget {
  const DoctorMainLayout({super.key});

  @override
  State<DoctorMainLayout> createState() => _DoctorMainLayoutState();
}

class _DoctorMainLayoutState extends State<DoctorMainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DoctorHomeView(),
    const RequestsView(),
    const AllProjectsView(),
    const TeamsView(),
    const ProfileDocView(),
  ];

  final Color navyDeep = const Color(0xFF0F172A);
  final Color accentIndigo = const Color(0xFF6366F1);
  final Color glassEffect = const Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      backgroundColor: isDark ? navyDeep : const Color(0xFFF8FAFC),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: accentIndigo.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: CurvedNavigationBar(
          index: _currentIndex,
          // --- التعديل الجوهري هنا ---
          // استخدمنا قيمة ثابتة 65 بدلاً من 65.h لتجنب تخطي حد الـ 75 في الشاشات الكبيرة
          height: 60,
          items: <Widget>[
            _buildCreativeIcon(Icons.home_outlined, Icons.home_rounded, 0),
            _buildCreativeIcon(
              Icons.all_inbox_outlined,
              Icons.all_inbox_rounded,
              1,
            ),
            _buildCreativeIcon(
              Icons.folder_open_outlined,
              Icons.folder_rounded,
              2,
            ),
            _buildCreativeIcon(Icons.groups_outlined, Icons.groups_rounded, 3),
            _buildCreativeIcon(
              Icons.person_outline_rounded,
              Icons.person_rounded,
              4,
            ),
          ],
          color: isDark ? glassEffect : Colors.white,
          buttonBackgroundColor: accentIndigo,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOutQuart,
          animationDuration: const Duration(milliseconds: 400),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildCreativeIcon(
    IconData outlineIcon,
    IconData filledIcon,
    int index,
  ) {
    bool isSelected = _currentIndex == index;
    return Icon(
      isSelected ? filledIcon : outlineIcon,
      size: isSelected ? 28.sp : 24.sp,
      color: isSelected ? Colors.white : Colors.blueGrey.shade300,
    );
  }
}
