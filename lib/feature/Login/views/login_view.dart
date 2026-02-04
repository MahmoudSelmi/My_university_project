import 'package:auth_slmi/core/helper/app_nav.dart';
import 'package:auth_slmi/feature/forget_pass/views/forget_pass_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/helper/app_validator.dart';
import '../../../core/utiles/app_colors.dart';
import '../../../core/utiles/app_icons.dart';
import '../../../core/widgts/app_snkparr.dart';
import '../../../core/widgts/custom_buttom.dart';
import '../../../core/widgts/custom_svg.dart';
import '../../../core/widgts/custom_textformfiled.dart';
import '../../Register/views/register_view.dart';
import '../../home/views/home_view.dart';
import '../manager/login_cubit.dart';
import '../manager/login_states.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            final cubit = LoginCubit.get(context);
            if (state is LoginSuccess) {
              MyNavigator.goTo(
                context,
                HomeView(),
                type: NavigatorType.pushAndRemoveUntil,
              );
              AppToast.success(context, "Login Successfully");
              cubit.clearControllers();
            }
            if (state is LoginError) {
              cubit.clearControllers();
              AppToast.error(context, state.error);
            }
          },
          builder: (context, state) {
            final cubit = LoginCubit.get(context);
            return Form(
              key: cubit.formkay,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomSvg(
                        path: AppIcons.logo,
                        width: 400.w,
                        height: 250.h,
                      ),

                      SizedBox(height: 16.h),

                      CustomTextformfaild(
                        controller: cubit.emailController,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Email",
                        validator: AppValidator.emailValidator,
                        prefixIcon: Icon(Icons.email, color: AppColors.primary),
                      ),
                      SizedBox(height: 16.h),
                      CustomTextformfaild(
                        controller: cubit.passwordController,
                        obscureText: cubit.isPassword,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: "Password",
                        validator: AppValidator.passwordValidator,
                        prefixIcon: Icon(Icons.lock, color: AppColors.primary),
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
                      GestureDetector(
                        onTap: () {
                          MyNavigator.goTo(
                            context,
                            ForgetPassView(),
                            type: NavigatorType.push,
                          );
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot password ?",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      state is LoginLoading
                          ? const CircularProgressIndicator()
                          : CustomButton(
                            text: "Login",
                            onPressed: () {
                              cubit.onLoginPressed();
                            },
                          ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account? ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              MyNavigator.goTo(
                                context,
                                RegisterView(),
                                type: NavigatorType.push,
                              );
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                        ],
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
