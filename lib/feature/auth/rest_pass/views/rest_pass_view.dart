import 'package:auth_slmi/core/helper/app_nav.dart';
import 'package:auth_slmi/core/helper/app_validator.dart';
import 'package:auth_slmi/core/utiles/app_colors.dart';
import 'package:auth_slmi/core/utiles/app_icons.dart';
import 'package:auth_slmi/core/widgts/app_snkparr.dart';
import 'package:auth_slmi/core/widgts/custom_buttom.dart';
import 'package:auth_slmi/core/widgts/custom_svg.dart';
import 'package:auth_slmi/core/widgts/custom_textformfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Login/views/login_view.dart';
import '../manager/reset_cubit.dart';
import '../manager/reset_state.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetCubit(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: const Text("Reset Password"),
          centerTitle: true,
        ),
        body: BlocConsumer<ResetCubit, ResetPasswordState>(
          listener: (context, state) {
            final cubit = ResetCubit.get(context);
            if (state is ResetPasswordSuccess) {
              MyNavigator.goTo(
                context,
                LoginView(),
                type: NavigatorType.pushAndRemoveUntil,
              );
              AppToast.success(context, state.message);
              cubit.emailController.clear();
              cubit.codeController.clear();
              cubit.newPasswordController.clear();
              cubit.confirmPasswordController.clear();
            } else if (state is ResetPasswordError) {
              AppToast.error(context, state.error);
              cubit.emailController.clear();
              cubit.codeController.clear();
              cubit.newPasswordController.clear();
              cubit.confirmPasswordController.clear();
            }
          },
          builder: (context, state) {
            final cubit = ResetCubit.get(context);
            return Padding(
              padding: EdgeInsets.all(24.w),
              child: Form(
                key: cubit.formkay,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomSvg(
                        path: AppIcons.logo,
                        width: 200.w,
                        height: 200.h,
                      ),
                      SizedBox(height: 24.h),

                      CustomTextformfaild(
                        prefixIcon: Icon(Icons.email, color: AppColors.primary),
                        obscureText: false,
                        controller: cubit.emailController,
                        hintText: "Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidator.emailValidator,
                      ),

                      SizedBox(height: 16.h),

                      CustomTextformfaild(
                        prefixIcon: Icon(
                          Icons.numbers,
                          color: AppColors.primary,
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
                        prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                        validator: AppValidator.passwordValidator,
                        hintText: "New Password",
                        obscureText: cubit.isPassword,
                        keyboardType: TextInputType.visiblePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            cubit.changePasswordVisibility();
                          },
                          icon: Icon(
                            cubit.isPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      CustomTextformfaild(
                        prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                        suffixIcon: IconButton(
                          onPressed: () {
                            cubit.changeConfirmPasswordVisibility();
                          },
                          icon: Icon(
                            cubit.isConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
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

                      SizedBox(height: 32.h),

                      state is ResetPasswordLoading
                          ? const CircularProgressIndicator()
                          : CustomButton(
                            text: "Reset Password",
                            color: AppColors.primary,
                            onPressed: cubit.resetPassword,
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
