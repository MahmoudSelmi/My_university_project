import 'package:auth_slmi/core/BottomNavState/StudentMainLayout.dart';
import 'package:auth_slmi/core/helper/app_nav.dart';
import 'package:auth_slmi/core/helper/app_validator.dart';
import 'package:auth_slmi/core/utiles/app_colors.dart';
import 'package:auth_slmi/core/widgts/app_snkparr.dart';
import 'package:auth_slmi/core/widgts/custom_buttom.dart';
import 'package:auth_slmi/core/widgts/custom_textformfiled.dart';
import 'package:auth_slmi/feature/auth/forget_pass/views/forget_pass_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../Register/views/register_view.dart';
import '../manager/login_cubit.dart';
import '../manager/login_states.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  final LinearGradient brandGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC), // خلفية هادية ومريحة
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            final cubit = LoginCubit.get(context);
            if (state is LoginSuccess) {
              MyNavigator.goTo(
                context,
                const StudentMainLayout(),
                type: NavigatorType.pushAndRemoveUntil,
              );
              AppToast.success(context, "Welcome Back!");
              cubit.clearControllers();
            }
            if (state is LoginError) {
              AppToast.error(context, state.error);
            }
          },
          builder: (context, state) {
            final cubit = LoginCubit.get(context);
            return Form(
              key: cubit.formkay,
              child: AnimationLimiter(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  physics: const BouncingScrollPhysics(),
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 600),
                    childAnimationBuilder:
                        (widget) => SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(child: widget),
                        ),
                    children: [
                      SizedBox(height: 100.h),

                      // كلمة "Khotwa" الاحترافية بدلاً من اللوجو
                      Center(
                        child: ShaderMask(
                          shaderCallback:
                              (bounds) => brandGradient.createShader(bounds),
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
                      ),

                      SizedBox(height: 8.h),
                      Center(
                        child: Text(
                          "Login to your account",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(height: 50.h),

                      // حقل البريد الإلكتروني بتصميم أنضف
                      CustomTextformfaild(
                        controller: cubit.emailController,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Email Address",
                        validator: AppValidator.emailValidator,
                        prefixIcon: Icon(
                          Icons.alternate_email_rounded,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                      ),

                      SizedBox(height: 18.h),

                      // حقل كلمة السر
                      CustomTextformfaild(
                        controller: cubit.passwordController,
                        obscureText: cubit.isPassword,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: "Password",
                        validator: AppValidator.passwordValidator,
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => cubit.changePasswordVisibility(),
                          icon: Icon(
                            cubit.isPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // نسيت كلمة السر
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
                              color: AppColors.primary,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30.h),

                      // زرار الدخول بتأثير التحميل
                      state is LoginLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: CustomButton(
                              text: "Sign In",
                              onPressed: () => cubit.onLoginPressed(),
                            ),
                          ),

                      SizedBox(height: 40.h),

                      // خيار التسجيل الجديد
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "New here? ",
                            style: TextStyle(
                              color: Colors.grey.shade600,
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
                                color: AppColors.primary,
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
      ),
    );
  }
}
