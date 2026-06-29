import 'package:auth_slmi/core/BottomNavState/BottomNavCubit.dart';
import 'package:auth_slmi/feature/students/Home/manager/home_cubit.dart';
import 'package:auth_slmi/feature/students/projects/Manager/MyProjectCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';

class StudentMainLayout extends StatelessWidget {
  const StudentMainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavCubit()),
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => MyProjectCubit()),
      ],
      child: BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          var cubit = BottomNavCubit.get(context);

          return Scaffold(
            extendBody: true,
            backgroundColor: const Color(0xFFF0F2F5),
            body: AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 300,
              ), // سرعة انتقال الصفحات
              child: cubit.screens[cubit.currentIndex],
            ),
            bottomNavigationBar: _buildModernMeshNav(context, cubit),
          );
        },
      ),
    );
  }

  Widget _buildModernMeshNav(BuildContext context, BottomNavCubit cubit) {
    return Container(
      height: 75, // قللنا الارتفاع شوية عشان يكون متناسق
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF6366F1).withValues(alpha: 0.85),
                  const Color(0xFFA855F7).withValues(alpha: 0.85),
                  const Color(0xFFEC4899).withValues(alpha: 0.85),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home_max_rounded, 0, cubit),
                _navItem(Icons.grid_view_rounded, 1, cubit),
                _navItem(Icons.bubble_chart_rounded, 2, cubit),
                _navItem(Icons.auto_awesome_motion_rounded, 3, cubit),
                _navItem(Icons.face_retouching_natural_rounded, 4, cubit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index, BottomNavCubit cubit) {
    bool isSelected = cubit.currentIndex == index;

    return GestureDetector(
      onTap: () => cubit.changeIndex(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutQuart, // حركة أنعم بكتير من الـ Elastic
            padding: EdgeInsets.all(isSelected ? 12 : 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]
                      : [],
            ),
            child: Icon(
              icon,
              color:
                  isSelected
                      ? const Color(0xFF6366F1)
                      : Colors.white.withValues(alpha: 0.6),
              size: isSelected ? 24 : 22, // صغرنا الحجم شوية عشان الـ Exception
            ),
          ),
          const SizedBox(height: 2),
          // الـ Indicator السفلي بقى أرفع وأنعم
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 2.5,
            width: isSelected ? 8 : 0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
