import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:auth_slmi/core/helper/app_nav.dart';
import 'package:auth_slmi/core/helper/app_validator.dart';
import 'package:auth_slmi/core/widgts/app_snkparr.dart';
import 'package:auth_slmi/core/widgts/custom_buttom.dart';
import 'package:auth_slmi/core/widgts/custom_textformfiled.dart';
import 'package:auth_slmi/feature/auth/rest_pass/views/rest_pass_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../manager/forget_cubit.dart';
import '../manager/forget_states.dart';

class ForgetPassView extends StatefulWidget {
  const ForgetPassView({super.key});

  @override
  State<ForgetPassView> createState() => _ForgetPassViewState();
}

class _ForgetPassViewState extends State<ForgetPassView>
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
    // أنيميشن المنظور المستمر
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
      create: (context) => ForgetCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFF010208), // Deep Space Black
        body: Stack(
          children: [
            // --- 1. تأثير السديم النبضي (Nebula) ---
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

            BlocConsumer<ForgetCubit, ForgetPasswordState>(
              listener: (context, state) {
                final cubit = ForgetCubit.get(context);
                if (state is ForgetPasswordSuccess) {
                  AppToast.success(context, state.message);
                  MyNavigator.goTo(
                    context,
                    const ResetPasswordView(),
                    type: NavigatorType.push,
                  );
                  cubit.emailController.clear();
                } else if (state is ForgetPasswordError) {
                  AppToast.error(context, state.error);
                }
              },
              builder: (context, state) {
                final cubit = ForgetCubit.get(context);
                return SafeArea(
                  child: Center(
                    child: AnimationLimiter(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 1000),
                            childAnimationBuilder:
                                (widget) => SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(child: widget),
                                ),
                            children: [
                              // --- 2. الهيدر بنظام الـ 4D ---
                              _build4DHeader(),

                              SizedBox(height: 40.h),

                              // --- 3. الكارت الزجاجي الـ 4D ---
                              _build4DForgetCard(cubit, state),

                              SizedBox(height: 30.h),

                              // زرار العودة الهادئ
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Return to Authentication",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
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

  Widget _build4DForgetCard(ForgetCubit cubit, ForgetPasswordState state) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform:
              Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective Entry
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "RECOVER ACCESS",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Enter your registered email to receive the authentication nexus code.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF8B949E),
                  fontSize: 12.sp,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 35.h),
              CustomTextformfaild(
                controller: cubit.emailController,
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                prefixIcon: Icon(
                  Icons.alternate_email_rounded,
                  color: const Color(0xFF6366F1),
                  size: 22.sp,
                ),
                validator: AppValidator.emailValidator,
              ),
              SizedBox(height: 32.h),
              state is ForgetPasswordLoading
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
                      text: "Send Reset Code",
                      onPressed: cubit.forgetPassword,
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
              top: -100.h + (_animationController.value * 20),
              right: -50.w,
              child: _glowOrb(
                const Color(0xFF6366F1).withValues(alpha: 0.2),
                350.w,
              ),
            ),
            Positioned(
              bottom: -50.h,
              left: -100.w - (_animationController.value * 20),
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
        boxShadow: [BoxShadow(color: color, blurRadius: 80)],
      ),
    );
  }
}
