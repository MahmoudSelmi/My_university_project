import 'package:blurrycontainer/blurrycontainer.dart';

import 'package:auth_slmi/core/BottomNavState/StudentMainLayout.dart';

import 'package:auth_slmi/core/helper/app_nav.dart';

import 'package:auth_slmi/core/helper/app_validator.dart';

import 'package:auth_slmi/core/widgts/app_snkparr.dart';

import 'package:auth_slmi/core/widgts/custom_buttom.dart';

import 'package:auth_slmi/core/widgts/custom_textformfiled.dart';

import 'package:auth_slmi/feature/auth/forget_pass/views/forget_pass_view.dart';

import 'package:auth_slmi/feature/doctor/DoctorMainLayout/Views/DoctorMainLayout.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../Register/views/register_view.dart';

import '../manager/login_cubit.dart';

import '../manager/login_states.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
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

    // أنيميشن للحركة المنظورية المستمرة

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
      create: (context) => LoginCubit(),

      child: Scaffold(
        backgroundColor: const Color(0xFF010208), // Deep Space Black

        body: Stack(
          children: [
            // --- 1. تأثير السديم المتحرك في الخلفية ---
            _buildAnimatedNebula(),

            BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                final cubit = LoginCubit.get(context);

                if (state is LoginSuccess) {
                  if (cubit.isDoctorRole &&
                      cubit.emailController.text.trim() ==
                          "zeyadnull@gmail.com") {
                    MyNavigator.goTo(
                      context,

                      const DoctorMainLayout(),

                      type: NavigatorType.pushAndRemoveUntil,
                    );

                    AppToast.success(context, "Welcome Dr. Zeyad!");
                  } else {
                    MyNavigator.goTo(
                      context,

                      const StudentMainLayout(),

                      type: NavigatorType.pushAndRemoveUntil,
                    );

                    AppToast.success(context, "Welcome Back!");
                  }

                  cubit.clearControllers();
                }

                if (state is LoginError) AppToast.error(context, state.error);
              },

              builder: (context, state) {
                final cubit = LoginCubit.get(context);

                return SafeArea(
                  child: AnimationLimiter(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),

                      physics: const BouncingScrollPhysics(),

                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 1000),

                        childAnimationBuilder:
                            (widget) => SlideAnimation(
                              verticalOffset: 50.0,

                              child: FadeInAnimation(child: widget),
                            ),

                        children: [
                          SizedBox(height: 40.h),

                          // --- 2. الهيدر بنظام الـ 4D Perspective ---
                          _build4DHeader(),

                          SizedBox(height: 40.h),

                          // اختيار الرتبة
                          _buildRoleSelector(cubit),

                          SizedBox(height: 25.h),

                          // --- 3. الكارت الزجاجي المائل (4D Card) ---
                          AnimatedBuilder(
                            animation: _animationController,

                            builder: (context, child) {
                              return Transform(
                                alignment: Alignment.center,

                                transform:
                                    Matrix4.identity()
                                      ..setEntry(
                                        3,

                                        2,

                                        0.001,
                                      ) // Perspective Depth
                                      ..rotateX(
                                        _animationController.value * 0.05,
                                      )
                                      ..rotateY(
                                        _animationController.value * 0.03,
                                      ),

                                child: child,
                              );
                            },

                            child: BlurryContainer(
                              blur: 20,

                              elevation: 0,

                              color: Colors.white.withValues(alpha: 0.04),

                              borderRadius: BorderRadius.circular(40.r),

                              child: Container(
                                padding: EdgeInsets.all(25.w),

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.r),

                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.08),
                                  ),
                                ),

                                child: Form(
                                  key: cubit.formkay,

                                  child: Column(
                                    children: [
                                      CustomTextformfaild(
                                        controller: cubit.emailController,

                                        obscureText: false,

                                        keyboardType:
                                            TextInputType.emailAddress,

                                        hintText: "Email Address",

                                        validator:
                                            (value) =>
                                                value == null || value.isEmpty
                                                    ? 'Please enter your email'
                                                    : null,

                                        prefixIcon: Icon(
                                          Icons.alternate_email_rounded,

                                          color: const Color(0xFF6366F1),

                                          size: 20.sp,
                                        ),
                                      ),

                                      SizedBox(height: 18.h),

                                      CustomTextformfaild(
                                        controller: cubit.passwordController,

                                        obscureText: cubit.isPassword,

                                        keyboardType:
                                            TextInputType.visiblePassword,

                                        hintText: "Password",

                                        validator:
                                            AppValidator.passwordValidator,

                                        prefixIcon: Icon(
                                          Icons.lock_outline_rounded,

                                          color: const Color(0xFF6366F1),

                                          size: 20.sp,
                                        ),

                                        suffixIcon: IconButton(
                                          onPressed:
                                              () =>
                                                  cubit
                                                      .changePasswordVisibility(),

                                          icon: Icon(
                                            cubit.isPassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,

                                            color: Colors.white30,

                                            size: 20.sp,
                                          ),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerRight,

                                        child: TextButton(
                                          onPressed:
                                              () => MyNavigator.goTo(
                                                context,

                                                const ForgetPassView(),

                                                type: NavigatorType.push,
                                              ),

                                          child: Text(
                                            "Forgot Password?",

                                            style: TextStyle(
                                              color: const Color(0xFF6366F1),

                                              fontSize: 13.sp,

                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 30.h),

                                      state is LoginLoading
                                          ? const Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF6366F1),
                                            ),
                                          )
                                          : Container(
                                            width: double.infinity,

                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xFF6366F1,
                                                  ).withValues(alpha: 0.3),

                                                  blurRadius: 20,

                                                  offset: const Offset(0, 10),
                                                ),
                                              ],
                                            ),

                                            child: CustomButton(
                                              text: "Sign In",

                                              onPressed:
                                                  () => cubit.onLoginPressed(),
                                            ),
                                          ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 40.h),

                          // إنشاء حساب
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text(
                                "New here? ",

                                style: TextStyle(
                                  color: Colors.white54,

                                  fontSize: 14.sp,
                                ),
                              ),

                              GestureDetector(
                                onTap:
                                    () => MyNavigator.goTo(
                                      context,

                                      const RegisterView(),

                                      type: NavigatorType.push,
                                    ),

                                child: Text(
                                  "Create Account",

                                  style: TextStyle(
                                    color: const Color(0xFFEC4899),

                                    fontWeight: FontWeight.bold,

                                    fontSize: 14.sp,

                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 30.h),
                        ],
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

  // --- ميثودات الـ 4D المتطورة ---

  Widget _buildAnimatedNebula() {
    return AnimatedBuilder(
      animation: _animationController,

      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: -100.h + (_animationController.value * 30),

              right: -50.w + (_animationController.value * 20),

              child: _glowOrb(
                const Color(0xFF6366F1).withValues(alpha: 0.2),
                350.w,
              ),
            ),

            Positioned(
              bottom: -50.h - (_animationController.value * 20),

              left: -100.w - (_animationController.value * 30),

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

  Widget _buildRoleSelector(LoginCubit cubit) {
    return Container(
      padding: EdgeInsets.all(4.w),

      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),

        borderRadius: BorderRadius.circular(20.r),

        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),

      child: Row(
        children: [
          _buildRoleBtn(cubit, "STUDENT", false),

          _buildRoleBtn(cubit, "DOCTOR", true),
        ],
      ),
    );
  }

  Widget _buildRoleBtn(LoginCubit cubit, String title, bool isDr) {
    bool active = cubit.isDoctorRole == isDr;

    return Expanded(
      child: GestureDetector(
        onTap: () => cubit.selectRole(isDr),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),

          padding: EdgeInsets.symmetric(vertical: 12.h),

          decoration: BoxDecoration(
            gradient: active ? brandGradient : null,

            borderRadius: BorderRadius.circular(16.r),
          ),

          child: Center(
            child: Text(
              title,

              style: TextStyle(
                color: active ? Colors.white : const Color(0xFF8B949E),

                fontWeight: FontWeight.bold,

                fontSize: 12.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _glowOrb(Color color, double size) {
    return Container(
      width: size,

      height: size,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        color: color,

        boxShadow: [BoxShadow(color: color, blurRadius: 50, spreadRadius: 20)],
      ),
    );
  }
}
