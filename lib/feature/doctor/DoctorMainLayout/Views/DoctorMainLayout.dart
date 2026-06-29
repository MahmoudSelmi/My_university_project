import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:auth_slmi/feature/doctor/home/views/doctor_home_view.dart';
import 'package:auth_slmi/feature/doctor/RequestsView/Views/RequestsView.dart';
import 'package:auth_slmi/feature/doctor/profile/Views/ProfileDocView.dart';
import 'package:auth_slmi/feature/doctor/home/Manager/doctor_home_cubit.dart';

class DoctorMainLayout extends StatefulWidget {
  const DoctorMainLayout({super.key});

  @override
  State<DoctorMainLayout> createState() => _DoctorMainLayoutState();
}

class _DoctorMainLayoutState extends State<DoctorMainLayout>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _previousIndex = 0;

  late AnimationController _controller;
  late Animation<Offset> _slideIn;
  late Animation<Offset> _slideOut;
  late Animation<double> _fadeIn;
  late Animation<double> _fadeOut;

  final List<Widget> _screens = const [
    DoctorHomeView(),
    RequestsView(),
    ProfileDocView(),
  ];

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.all_inbox_rounded,
    Icons.person_rounded,
  ];

  final List<String> _labels = ['الرئيسية', 'الطلبات', 'الملف'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550), // 🎯 الوقت المثالي
    );
    _setupAnimations(0, 0);
    _controller.value = 1.0;
  }

  void _setupAnimations(int from, int to) {
    final bool goingRight = to > from;

    // 🚀 انزلاق ناعم مع ارتداد خفيف
    _slideIn = Tween<Offset>(
      begin: Offset(goingRight ? 0.6 : -0.6, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic, // 🎯 منحنى ناعم بدون ارتداد مفاجئ
      ),
    );

    _slideOut = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(goingRight ? -0.15 : 0.15, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));

    // ✨ تلاشي ناعم
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    HapticFeedback.mediumImpact();
    _setupAnimations(_currentIndex, index);
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
    });
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorHomeCubit(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: const Color(0xFF0F172A),
          extendBody: true,
          body: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  if (_controller.value < 1.0)
                    SlideTransition(
                      position: _slideOut,
                      child: FadeTransition(
                        opacity: _fadeOut,
                        child: _screens[_previousIndex],
                      ),
                    ),
                  SlideTransition(
                    position: _slideIn,
                    child: FadeTransition(
                      opacity: _fadeIn,
                      child: _screens[_currentIndex],
                    ),
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: _buildBalancedNavBar(),
        ),
      ),
    );
  }

  Widget _buildBalancedNavBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            height: 70.h,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(32.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.05),
                  blurRadius: 40,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(3, (index) {
                return _buildBalancedNavItem(index);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalancedNavItem(int index) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF6366F1).withValues(alpha: 0.12)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border:
              isSelected
                  ? Border.all(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                    width: 1.0,
                  )
                  : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _icons[index],
              size: 24.sp,
              color:
                  isSelected
                      ? const Color(0xFF6366F1)
                      : Colors.blueGrey.shade400,
            ),
            if (isSelected)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                margin: EdgeInsets.only(top: 3.h),
                height: 2.5.h,
                width: 16.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              )
            else
              SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }
}
