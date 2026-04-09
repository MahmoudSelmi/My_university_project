import 'package:auth_slmi/core/helper/app_nav.dart';
import 'package:auth_slmi/core/helper/app_validator.dart';
import 'package:auth_slmi/core/utiles/app_colors.dart';
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

class ForgetPassView extends StatelessWidget {
  const ForgetPassView({super.key});

  final LinearGradient brandGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetCubit(),
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
        body: BlocConsumer<ForgetCubit, ForgetPasswordState>(
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
                      SizedBox(height: 40.h),

                      // الهوية البصرية (Khotwa)
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

                      SizedBox(height: 40.h),

                      Text(
                        "Forgot Password? 🔑",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Text(
                        "No worries! Enter your email and we'll send you a verification code to reset your password.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: 40.h),

                      // حقل البريد الإلكتروني المودرن
                      CustomTextformfaild(
                        controller: cubit.emailController,
                        hintText: "Enter your email",
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        prefixIcon: Icon(
                          Icons.alternate_email_rounded,
                          color: AppColors.primary,
                          size: 22.sp,
                        ),
                        validator: AppValidator.emailValidator,
                      ),

                      SizedBox(height: 32.h),

                      // زرار الإرسال بستايل البراند
                      state is ForgetPasswordLoading
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
                              text: "Send Reset Code",
                              onPressed: cubit.forgetPassword,
                            ),
                          ),

                      SizedBox(height: 20.h),

                      // زرار العودة للـ Login بشكل بسيط
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Back to Login",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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
