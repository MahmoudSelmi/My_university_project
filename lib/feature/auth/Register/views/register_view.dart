import 'package:auth_slmi/core/helper/app_nav.dart';
import 'package:auth_slmi/core/helper/app_validator.dart';
import 'package:auth_slmi/core/utiles/app_colors.dart';
import 'package:auth_slmi/core/utiles/app_icons.dart';
import 'package:auth_slmi/core/widgts/app_snkparr.dart';
import 'package:auth_slmi/core/widgts/custom_buttom.dart';
import 'package:auth_slmi/core/widgts/custom_dropdown.dart';
import 'package:auth_slmi/core/widgts/custom_svg.dart';
import 'package:auth_slmi/core/widgts/custom_textformfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Login/views/login_view.dart';
import '../../verfiy/views/verfiy_view.dart';
import '../manager/DepartmentCubit/department_cubit.dart';
import '../manager/DepartmentCubit/department_states.dart';
import '../manager/RegisterCubit/Register_cubit.dart';
import '../manager/RegisterCubit/Register_states.dart';
import '../manager/Universitiecubit/universities_cubit.dart';
import '../manager/Universitiecubit/universities_states.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UniversitiesCubit()..getUniversities()),
        BlocProvider(create: (_) => DepartmentCubit()..getDepartments()),
        BlocProvider(create: (_) => RegisterCubit()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            final cubit = RegisterCubit.get(context);

            if (state is RegisterSuccess) {
              final email = cubit.emailController.text;
              AppToast.success(context, state.response.message);
              cubit.clearControllers();
              MyNavigator.goTo(
                context,
                VerifyView(email: email),
                type: NavigatorType.push,
              );
            } else if (state is RegisterError) {
              AppToast.error(context, state.error);
              cubit.clearControllers();
            }
          },
          builder: (context, state) {
            final cubit = RegisterCubit.get(context);
            return Form(
              key: cubit.formKey,
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

                      CustomTextformfaild(
                        controller: cubit.nameController,
                        obscureText: false,
                        keyboardType: TextInputType.name,
                        hintText: "Full Name",
                        validator: AppValidator.requiredValidator,
                        prefixIcon: Icon(
                          Icons.person,
                          color: AppColors.primary,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      CustomTextformfaild(
                        prefixIcon: Icon(
                          Icons.person,
                          color: AppColors.primary,
                        ),
                        controller: cubit.universityCodeController,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        hintText: "Student Code",
                        validator: AppValidator.studentCodeValidator,
                      ),

                      SizedBox(height: 16.h),

                      CustomTextformfaild(
                        prefixIcon: Icon(Icons.email, color: AppColors.primary),

                        controller: cubit.emailController,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Email",
                        validator: AppValidator.emailValidator,
                      ),

                      SizedBox(height: 16.h),

                      CustomTextformfaild(
                        prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                        controller: cubit.passwordController,
                        obscureText: cubit.isPassword,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: "Password",
                        validator: AppValidator.passwordValidator,
                        suffixIcon: IconButton(
                          onPressed: cubit.changePasswordVisibility,
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
                        controller: cubit.confirmPasswordController,
                        obscureText: cubit.isConfirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: "Confirm Password",
                        validator:
                            (value) => AppValidator.confirmPasswordValidator(
                              value,
                              cubit.passwordController.text,
                            ),
                        suffixIcon: IconButton(
                          onPressed: cubit.changeConfirmPasswordVisibility,
                          icon: Icon(
                            cubit.isConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      Row(
                        children: [
                          Expanded(
                            child: BlocBuilder<
                              UniversitiesCubit,
                              UniversitiesStates
                            >(
                              builder: (context, state) {
                                if (state is UniversitiesSuccess) {
                                  final list = state.data.data!;
                                  return CustomDropdownField(
                                    hintText: "University",
                                    value: cubit.selectedUniversityName,
                                    items:
                                        list
                                            .map((e) => e.universityName!)
                                            .toList(),
                                    validator: AppValidator.requiredValidator,
                                    onChanged: (value) {
                                      if (value == null) return;

                                      final uni = list.firstWhere(
                                        (e) => e.universityName == value,
                                      );

                                      cubit.selectedUniversityName = value;
                                      cubit.selectedUniversityId = uni.sId;
                                    },
                                  );
                                } else if (state is UniversitiesLoading) {
                                  return Center(
                                    child: const CircularProgressIndicator(),
                                  );
                                } else if (state is UniversitiesError) {
                                  return Text(state.error);
                                } else {
                                  return CustomDropdownField(
                                    hintText: "University",
                                    items: const [],
                                  );
                                }
                              },
                            ),
                          ),

                          SizedBox(width: 12.w),

                          Expanded(
                            child: BlocBuilder<
                              DepartmentCubit,
                              DepartmentState
                            >(
                              builder: (context, state) {
                                if (state is DepartmentSuccess) {
                                  final list = state.departments.data!;
                                  return CustomDropdownField(
                                    hintText: "Department",
                                    value: cubit.selectedDepartmentName,
                                    items:
                                        list
                                            .map((e) => e.departmentName!)
                                            .toList(),
                                    validator: AppValidator.requiredValidator,
                                    onChanged: (value) {
                                      if (value == null) return;

                                      final dep = list.firstWhere(
                                        (e) => e.departmentName == value,
                                      );

                                      cubit.selectedDepartmentName = value;
                                      cubit.selectedDepartmentId = dep.sId;
                                    },
                                  );
                                } else if (state is DepartmentLoading) {
                                  return Center(
                                    child: const CircularProgressIndicator(),
                                  );
                                } else if (state is DepartmentError) {
                                  return Text(state.message);
                                } else {
                                  return CustomDropdownField(
                                    hintText: "Department",
                                    items: const [],
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      state is RegisterLoading
                          ? const CircularProgressIndicator()
                          : CustomButton(
                            text: "Create Account",
                            onPressed: cubit.onRegisterPressed,
                          ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
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
                                LoginView(),
                                type: NavigatorType.push,
                              );
                            },
                            child: Text(
                              "Login",
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
