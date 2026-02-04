import 'package:auth_slmi/core/helper/app_validator.dart';
import 'package:auth_slmi/feature/rest_pass/views/rest_pass_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/helper/app_nav.dart';
import '../../../core/utiles/app_colors.dart';
import '../../../core/widgts/app_snkparr.dart';
import '../../../core/widgts/custom_buttom.dart';
import '../../../core/widgts/custom_textformfiled.dart';
import '../manager/forget_cubit.dart';
import '../manager/forget_states.dart';

class ForgetPassView extends StatelessWidget {
  const ForgetPassView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetCubit(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: Text(
            "Forgot Password",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<ForgetCubit, ForgetPasswordState>(
          listener: (context, state) {
            final cubit = ForgetCubit.get(context);
            if (state is ForgetPasswordSuccess) {
              AppToast.success(context, state.message);
              MyNavigator.goTo(
                context,
                ResetPasswordView(),
                type: NavigatorType.push,
              );
              cubit.emailController.clear();
            } else if (state is ForgetPasswordError) {
              AppToast.error(context, state.error);
              cubit.emailController.clear();
            }
          },
          builder: (context, state) {
            ForgetCubit forgetCubit = ForgetCubit.get(context);
            return Form(
              key: forgetCubit.formkay,
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgot your password?",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    Text(
                      "Enter your email and we’ll send you a reset code",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),

                    SizedBox(height: 32.h),

                    CustomTextformfaild(
                      controller: forgetCubit.emailController,
                      hintText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      prefixIcon: Icon(Icons.email, color: AppColors.primary),
                      validator: AppValidator.emailValidator,
                    ),

                    SizedBox(height: 24.h),

                    state is ForgetPasswordLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                          text: "Send Code",
                          color: AppColors.primary,
                          onPressed: forgetCubit.forgetPassword,
                        ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
