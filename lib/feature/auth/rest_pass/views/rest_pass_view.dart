import 'package:auth_slmi/core/helper/app_nav.dart';
import 'package:auth_slmi/core/helper/app_validator.dart';
import 'package:auth_slmi/core/utiles/app_colors.dart';
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

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  final LinearGradient brandGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<ResetCubit, ResetPasswordState>(
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
                          verticalOffset: 30.0,
                          child: FadeInAnimation(child: widget),
                        ),
                    children: [
                      SizedBox(height: 20.h),

                      // الكلمة الاحترافية بدلاً من اللوجو التقليدي
                      Center(
                        child: ShaderMask(
                          shaderCallback:
                              (bounds) => brandGradient.createShader(bounds),
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
                      ),

                      SizedBox(height: 12.h),
                      Center(
                        child: Text(
                          "Reset your security credentials",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(height: 40.h),

                      // حقل البريد الإلكتروني
                      CustomTextformfaild(
                        prefixIcon: Icon(
                          Icons.alternate_email_rounded,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                        obscureText: false,
                        controller: cubit.emailController,
                        hintText: "Registered Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidator.emailValidator,
                      ),

                      SizedBox(height: 16.h),

                      // حقل كود التحقق
                      CustomTextformfaild(
                        prefixIcon: Icon(
                          Icons.pin_rounded,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                        obscureText: false,
                        controller: cubit.codeController,
                        hintText: "Verification Code",
                        keyboardType: TextInputType.number,
                        validator: AppValidator.requiredValidator,
                      ),

                      SizedBox(height: 16.h),

                      // حقل كلمة السر الجديدة
                      CustomTextformfaild(
                        controller: cubit.newPasswordController,
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.primary,
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
                            size: 20.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // حقل تأكيد كلمة السر
                      CustomTextformfaild(
                        prefixIcon: Icon(
                          Icons.lock_reset_rounded,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                        suffixIcon: IconButton(
                          onPressed:
                              () => cubit.changeConfirmPasswordVisibility(),
                          icon: Icon(
                            cubit.isConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
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

                      // زرار الحفظ بتأثير الظل الملون
                      state is ResetPasswordLoading
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
                              text: "Update Password",
                              onPressed: cubit.resetPassword,
                            ),
                          ),
                      SizedBox(height: 40.h),
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
