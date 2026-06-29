import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auth_slmi/feature/doctor/home/Manager/doctor_home_cubit.dart';
import 'package:auth_slmi/feature/doctor/home/Manager/doctor_home_states.dart';

class AllProjectsView extends StatelessWidget {
  const AllProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorHomeCubit, DoctorHomeStates>(
      builder: (context, state) {
        if (state is DoctorHomeSuccess) {
          final projects = state.projects;

          return Scaffold(
            backgroundColor: const Color(0xFF0F172A),
            body: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHeader(projects.length),
                  _buildStatsRow(projects.length),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 20.h,
                    ),
                    sliver:
                        projects.isEmpty
                            ? const SliverToBoxAdapter(
                              child: Center(
                                child: Text(
                                  "لا توجد مشاريع نشطة",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                            : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => _buildProjectCard(
                                  projects[index] as Map<String, dynamic>,
                                ),
                                childCount: projects.length,
                              ),
                            ),
                  ),
                ],
              ),
            ),
          );
        }
        // لو الحالة Loading (وده مش هياخد ثانية) هيظهر لودينج خفيف
        return const Scaffold(
          backgroundColor: Color(0xFF0F172A),
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFF6366F1)),
          ),
        );
      },
    );
  }

  Widget _buildHeader(int count) => SliverToBoxAdapter(
    child: Padding(
      padding: EdgeInsets.fromLTRB(24.w, 30.h, 24.w, 10.h),
      child: Text(
        "لوحة التحكم",
        style: TextStyle(
          color: Colors.white,
          fontSize: 26.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    ),
  );

  Widget _buildStatsRow(int count) => SliverToBoxAdapter(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFF6366F1).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Text(
          "لديك $count مشاريع تحت إشرافك حالياً",
          style: const TextStyle(
            color: Color(0xFF6366F1),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );

  Widget _buildProjectCard(Map<String, dynamic> project) => Container(
    margin: EdgeInsets.only(bottom: 15.h),
    padding: EdgeInsets.all(20.r),
    decoration: BoxDecoration(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          project['title'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          "الليدر: ${project['leader']}",
          style: const TextStyle(color: Color(0xFF6366F1), fontSize: 12),
        ),
        SizedBox(height: 15.h),
        const LinearProgressIndicator(
          value: 0.6,
          backgroundColor: Colors.white10,
          color: Color(0xFF6366F1),
        ),
      ],
    ),
  );
}
