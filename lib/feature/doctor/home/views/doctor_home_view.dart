import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auth_slmi/core/Models/project_model.dart';
import '../Manager/doctor_home_cubit.dart';
import '../Manager/doctor_home_states.dart';

class DoctorHomeView extends StatelessWidget {
  const DoctorHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorCubit()..getDoctorDashboard(),
      child: Scaffold(
        backgroundColor: const Color(0xFF020617),
        body: BlocBuilder<DoctorCubit, DoctorStates>(
          builder: (context, state) {
            if (state is DoctorLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF6366F1)),
              );
            }

            if (state is DoctorSuccess) {
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.h),
                children: [
                  _buildHeader(),
                  SizedBox(height: 30.h),
                  _buildStatsRow(state.stats),
                  SizedBox(height: 40.h),
                  const Text(
                    "Active Projects",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Column(
                    children:
                        state.projects
                            .map(
                              (ProjectModel project) =>
                                  _buildProjectCard(project),
                            )
                            .toList(),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "أهلاً دكتور زياد 👋",
          style: TextStyle(color: const Color(0xFF6366F1), fontSize: 16.sp),
        ),
        Text(
          "لوحة التحكم",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(Map<String, dynamic>? stats) {
    return Row(
      children: [
        _statBox(
          "المشاريع",
          stats?['totalProjects']?.toString() ?? "2",
          const Color(0xFF6366F1),
        ),
        SizedBox(width: 15.w),
        _statBox(
          "الطلبات",
          stats?['pendingActions']?.toString() ?? "0",
          Colors.orange,
        ),
      ],
    );
  }

  Widget _statBox(String label, String val, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Text(
              val,
              style: TextStyle(
                color: color,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(ProjectModel project) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          margin: EdgeInsets.only(bottom: 15.h),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.projectTitle ?? "No Title",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                project.projectDescription ?? "No Description",
                maxLines: 2,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
