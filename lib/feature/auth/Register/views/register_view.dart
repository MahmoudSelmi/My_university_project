import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:auth_slmi/core/helper/app_nav.dart';
import 'package:auth_slmi/core/widgts/app_snkparr.dart';
import 'package:auth_slmi/core/widgts/custom_buttom.dart';
import 'package:auth_slmi/core/widgts/custom_dropdown.dart';
import 'package:auth_slmi/core/widgts/custom_textformfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../Login/views/login_view.dart';
import '../../verfiy/views/verfiy_view.dart';
import '../manager/DepartmentCubit/department_cubit.dart';
import '../manager/DepartmentCubit/department_states.dart';
import '../manager/RegisterCubit/Register_cubit.dart';
import '../manager/RegisterCubit/Register_states.dart';
import '../manager/Universitiecubit/universities_cubit.dart';
import '../manager/Universitiecubit/universities_states.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final LinearGradient brandGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UniversitiesCubit()..getUniversities()),
        BlocProvider(create: (_) => DepartmentCubit()..getDepartments()),
        BlocProvider(create: (_) => RegisterCubit()),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF010208),
        body: Stack(
          children: [
            _buildAnimatedNebula(),
            BlocConsumer<RegisterCubit, RegisterState>(
              listener: (context, state) {
                final cubit = RegisterCubit.get(context);
                if (state is RegisterSuccess) {
                  AppToast.success(context, state.response.message);
                  MyNavigator.goTo(
                    context,
                    VerifyView(email: cubit.emailController.text),
                    type: NavigatorType.push,
                  );
                } else if (state is RegisterError) {
                  AppToast.error(context, state.error);
                }
              },
              builder: (context, state) {
                final cubit = RegisterCubit.get(context);
                return SafeArea(
                  child: Center(
                    child: AnimationLimiter(
                      child: ListView(
                        shrinkWrap: true, // يخلي القائمة تلم نفسها في السنتر
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 15.h,
                        ),
                        physics: const BouncingScrollPhysics(),
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 1000),
                          childAnimationBuilder:
                              (widget) => SlideAnimation(
                                verticalOffset: 40.0,
                                child: FadeInAnimation(child: widget),
                              ),
                          children: [
                            // هيدر محترم زيه زي الـ Login
                            _build4DHeader(),

                            SizedBox(height: 30.h),

                            // كارت التسجيل الـ 4D المتوازن
                            _build4DRegisterCard(cubit, state),

                            SizedBox(height: 25.h),

                            _buildFooter(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _build4DRegisterCard(RegisterCubit cubit, RegisterState state) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform:
              Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_animationController.value * 0.04)
                ..rotateY(_animationController.value * 0.02),
          child: child,
        );
      },
      child: BlurryContainer(
        blur: 20,
        color: Colors.white.withValues(alpha: 0.04),
        padding: EdgeInsets.all(22.w),
        borderRadius: BorderRadius.circular(35.r),
        child: Form(
          key: cubit.formKey,
          child: Column(
            children: [
              _buildField(
                cubit.nameController,
                "Full Name",
                Icons.person_outline_rounded,
              ),
              _buildField(
                cubit.universityCodeController,
                "Student Code",
                Icons.badge_outlined,
                isNumber: true,
              ),
              _buildField(
                cubit.emailController,
                "Email Address",
                Icons.alternate_email_rounded,
              ),
              _buildField(
                cubit.passwordController,
                "Password",
                Icons.lock_outline_rounded,
                isPass: true,
                cubit: cubit,
                isConfirm: false,
              ),
              _buildField(
                cubit.confirmPasswordController,
                "Confirm Password",
                Icons.lock_reset_rounded,
                isPass: true,
                cubit: cubit,
                isConfirm: true,
              ),

              SizedBox(height: 10.h),
              _buildDropdownSection(cubit),
              SizedBox(height: 30.h),

              state is RegisterLoading
                  ? const CircularProgressIndicator(color: Color(0xFF6366F1))
                  : Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CustomButton(
                      text: "Create Account",
                      onPressed: cubit.onRegisterPressed,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isPass = false,
    bool isNumber = false,
    dynamic cubit,
    bool isConfirm = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: CustomTextformfaild(
        controller: controller,
        obscureText:
            isPass
                ? (isConfirm ? cubit.isConfirmPassword : cubit.isPassword)
                : false,
        keyboardType:
            isNumber
                ? TextInputType.number
                : (isPass ? TextInputType.visiblePassword : TextInputType.name),
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF6366F1), size: 20.sp),
        suffixIcon:
            isPass
                ? IconButton(
                  onPressed:
                      isConfirm
                          ? cubit.changeConfirmPasswordVisibility
                          : cubit.changePasswordVisibility,
                  icon: Icon(
                    (isConfirm ? cubit.isConfirmPassword : cubit.isPassword)
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white30,
                    size: 20.sp,
                  ),
                )
                : null,
      ),
    );
  }

  Widget _buildDropdownSection(RegisterCubit cubit) {
    return Row(
      children: [
        Expanded(
          child: BlocBuilder<UniversitiesCubit, UniversitiesStates>(
            builder: (context, state) {
              final List<dynamic> list =
                  (state is UniversitiesSuccess) ? (state.data.data ?? []) : [];
              return CustomDropdownField(
                hintText: "University",
                value: cubit.selectedUniversityName,
                items:
                    list
                        .map((e) => e.universityName?.toString() ?? "")
                        .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  final uni = list.firstWhere(
                    (e) => e.universityName == value,
                    orElse: () => null,
                  );
                  if (uni != null) {
                    cubit.selectedUniversityName = value;
                    cubit.selectedUniversityId = uni.sId;
                  }
                },
              );
            },
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: BlocBuilder<DepartmentCubit, DepartmentState>(
            builder: (context, state) {
              final List<dynamic> list =
                  (state is DepartmentSuccess)
                      ? (state.departments.data ?? [])
                      : [];
              return CustomDropdownField(
                hintText: "Department",
                value: cubit.selectedDepartmentName,
                items:
                    list
                        .map((e) => e.departmentName?.toString() ?? "")
                        .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  final dep = list.firstWhere(
                    (e) => e.departmentName == value,
                    orElse: () => null,
                  );
                  if (dep != null) {
                    cubit.selectedDepartmentName = value;
                    cubit.selectedDepartmentId = dep.sId;
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _build4DHeader() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform:
              Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(_animationController.value * -0.1),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  border: Border.all(
                    color: const Color(0xFF6366F1),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                      blurRadius: 25,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 50.sp,
                ),
              ),
              SizedBox(height: 15.h),
              ShaderMask(
                shaderCallback: (bounds) => brandGradient.createShader(bounds),
                child: Text(
                  'Khotwa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(color: Colors.white54, fontSize: 14.sp),
        ),
        GestureDetector(
          onTap:
              () => MyNavigator.goTo(
                context,
                const LoginView(),
                type: NavigatorType.push,
              ),
          child: Text(
            "Login",
            style: TextStyle(
              color: const Color(0xFFEC4899),
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedNebula() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: -100.h + (_animationController.value * 20),
              right: -50.w,
              child: _glowOrb(
                const Color(0xFF6366F1).withValues(alpha: 0.2),
                350.w,
              ),
            ),
            Positioned(
              bottom: -50.h,
              left: -100.w,
              child: _glowOrb(
                const Color(0xFFEC4899).withValues(alpha: 0.15),
                300.w,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _glowOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }
}
