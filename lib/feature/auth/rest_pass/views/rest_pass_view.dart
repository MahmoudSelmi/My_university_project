import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:auth_slmi/core/helper/app_nav.dart';
import 'package:auth_slmi/core/helper/app_validator.dart';
import 'package:auth_slmi/core/widgts/app_snkparr.dart';
import 'package:auth_slmi/core/widgts/custom_buttom.dart';
import 'package:auth_slmi/core/widgts/custom_textformfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../Login/views/login_view.dart';
import '../manager/reset_cubit.dart';
import '../manager/reset_state.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView>
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
    return BlocProvider(
      create: (context) => ResetCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFF010208), // Deep Space Black
        body: Stack(
          children: [
            // --- 1. تأثير السديم المتحرك (Nebula) ---
            _buildAnimatedNebula(),

            // زر العودة بستايل نيون
            Positioned(
              top: 50.h,
              left: 20.w,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            BlocConsumer<ResetCubit, ResetPasswordState>(
              listener: (context, state) {
                final cubit = ResetCubit.get(context);
                if (state is ResetPasswordSuccess) {
                  MyNavigator.goTo(
                    context,
                    const LoginView(),
                    type: NavigatorType.pushAndRemoveUntil,
                  );
                  AppToast.success(context, "Password Reset Successfully!");
                  cubit.emailController.clear();
                  cubit.codeController.clear();
                  cubit.newPasswordController.clear();
                  cubit.confirmPasswordController.clear();
                } else if (state is ResetPasswordError) {
                  AppToast.error(context, state.error);
                }
              },
              builder: (context, state) {
                final cubit = ResetCubit.get(context);
                return SafeArea(
                  child: Center(
                    child: AnimationLimiter(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 20.h,
                        ),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 1000),
                            childAnimationBuilder:
                                (widget) => SlideAnimation(
                                  verticalOffset: 40.0,
                                  child: FadeInAnimation(child: widget),
                                ),
                            children: [
                              // --- 2. الهيدر بنظام الـ 4D ---
                              _build4DHeader(),

                              SizedBox(height: 10.h),
                              Center(
                                child: Text(
                                  "Reset your security credentials",
                                  style: TextStyle(
                                    color: const Color(0xFF8B949E),
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: 40.h),

                              // --- 3. الكارت الزجاجي الـ 4D ---
                              _build4DResetCard(cubit, state),

                              SizedBox(height: 40.h),
                            ],
                          ),
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

  Widget _build4DResetCard(ResetCubit cubit, ResetPasswordState state) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform:
              Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateX(_animationController.value * 0.04)
                ..rotateY(_animationController.value * 0.02),
          child: child,
        );
      },
      child: BlurryContainer(
        blur: 20,
        color: Colors.white.withValues(alpha: 0.04),
        padding: EdgeInsets.all(25.w),
        borderRadius: BorderRadius.circular(40.r),
        child: Form(
          key: cubit.formkay,
          child: Column(
            children: [
              CustomTextformfaild(
                prefixIcon: Icon(
                  Icons.alternate_email_rounded,
                  color: const Color(0xFF6366F1),
                  size: 20.sp,
                ),
                obscureText: false,
                controller: cubit.emailController,
                hintText: "Registered Email",
                keyboardType: TextInputType.emailAddress,
                validator: AppValidator.emailValidator,
              ),
              SizedBox(height: 16.h),
              CustomTextformfaild(
                prefixIcon: Icon(
                  Icons.pin_rounded,
                  color: const Color(0xFF6366F1),
                  size: 20.sp,
                ),
                obscureText: false,
                controller: cubit.codeController,
                hintText: "Verification Code",
                keyboardType: TextInputType.number,
                validator: AppValidator.requiredValidator,
              ),
              SizedBox(height: 16.h),
              CustomTextformfaild(
                controller: cubit.newPasswordController,
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  color: const Color(0xFF6366F1),
                  size: 20.sp,
                ),
                validator: AppValidator.passwordValidator,
                hintText: "New Password",
                obscureText: cubit.isPassword,
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: IconButton(
                  onPressed: () => cubit.changePasswordVisibility(),
                  icon: Icon(
                    cubit.isPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white30,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              CustomTextformfaild(
                prefixIcon: Icon(
                  Icons.lock_reset_rounded,
                  color: const Color(0xFF6366F1),
                  size: 20.sp,
                ),
                suffixIcon: IconButton(
                  onPressed: () => cubit.changeConfirmPasswordVisibility(),
                  icon: Icon(
                    cubit.isConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white30,
                    size: 20.sp,
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                controller: cubit.confirmPasswordController,
                hintText: "Confirm New Password",
                obscureText: cubit.isConfirmPassword,
                validator:
                    (value) => AppValidator.confirmPasswordValidator(
                      value,
                      cubit.newPasswordController.text,
                    ),
              ),
              SizedBox(height: 35.h),
              state is ResetPasswordLoading
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
                      text: "Update Password",
                      onPressed: cubit.resetPassword,
                    ),
                  ),
            ],
          ),
        ),
      ),
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
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 55.sp,
                ),
              ),
              SizedBox(height: 15.h),
              ShaderMask(
                shaderCallback: (bounds) => brandGradient.createShader(bounds),
                child: Text(
                  'Khotwa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 45.sp,
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

  Widget _buildAnimatedNebula() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: -100.h + (_animationController.value * 30),
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
