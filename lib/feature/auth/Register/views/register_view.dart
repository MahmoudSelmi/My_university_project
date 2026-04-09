import 'package:auth_slmi/core/helper/app_nav.dart';
import 'package:auth_slmi/core/helper/app_validator.dart';
import 'package:auth_slmi/core/utiles/app_colors.dart';
import 'package:auth_slmi/core/widgts/app_snkparr.dart';
import 'package:auth_slmi/core/widgts/custom_buttom.dart';
import 'package:auth_slmi/core/widgts/custom_dropdown.dart';
import 'package:auth_slmi/core/widgts/custom_textformfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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

  final LinearGradient brandGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UniversitiesCubit()..getUniversities()),
        BlocProvider(create: (_) => DepartmentCubit()..getDepartments()),
        BlocProvider(create: (_) => RegisterCubit()),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
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
            }
          },
          builder: (context, state) {
            final cubit = RegisterCubit.get(context);
            return Form(
              key: cubit.formKey,
              child: AnimationLimiter(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  physics: const BouncingScrollPhysics(),
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 500),
                    childAnimationBuilder:
                        (widget) => SlideAnimation(
                          verticalOffset: 30.0,
                          child: FadeInAnimation(child: widget),
                        ),
                    children: [
                      SizedBox(height: 80.h),

                      // كلمة Khotwa الاحترافية
                      Center(
                        child: ShaderMask(
                          shaderCallback:
                              (bounds) => brandGradient.createShader(bounds),
                          child: Text(
                            'Khotwa',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1.0,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 8.h),
                      Center(
                        child: Text(
                          "Create a new student account",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 40.h),

                      // حقل الاسم بالكامل
                      CustomTextformfaild(
                        controller: cubit.nameController,
                        obscureText: false,
                        keyboardType: TextInputType.name,
                        hintText: "Full Name",
                        validator: AppValidator.requiredValidator,
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // حقل كود الطالب
                      CustomTextformfaild(
                        controller: cubit.universityCodeController,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        hintText: "Student Code",
                        validator: AppValidator.studentCodeValidator,
                        prefixIcon: Icon(
                          Icons.badge_outlined,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // حقل البريد الإلكتروني
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

                      SizedBox(height: 16.h),

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
                          onPressed: cubit.changePasswordVisibility,
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
                        controller: cubit.confirmPasswordController,
                        obscureText: cubit.isConfirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: "Confirm Password",
                        validator:
                            (value) => AppValidator.confirmPasswordValidator(
                              value,
                              cubit.passwordController.text,
                            ),
                        prefixIcon: Icon(
                          Icons.lock_reset_rounded,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                        suffixIcon: IconButton(
                          onPressed: cubit.changeConfirmPasswordVisibility,
                          icon: Icon(
                            cubit.isConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // اختيار الجامعة والقسم بشكل منسق
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
                                    onChanged: (value) {
                                      if (value == null) return;
                                      final uni = list.firstWhere(
                                        (e) => e.universityName == value,
                                      );
                                      cubit.selectedUniversityName = value;
                                      cubit.selectedUniversityId = uni.sId;
                                    },
                                  );
                                }
                                return CustomDropdownField(
                                  hintText: "University",
                                  items: const [],
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child:
                                BlocBuilder<DepartmentCubit, DepartmentState>(
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
                                        onChanged: (value) {
                                          if (value == null) return;
                                          final dep = list.firstWhere(
                                            (e) => e.departmentName == value,
                                          );
                                          cubit.selectedDepartmentName = value;
                                          cubit.selectedDepartmentId = dep.sId;
                                        },
                                      );
                                    }
                                    return CustomDropdownField(
                                      hintText: "Department",
                                      items: const [],
                                    );
                                  },
                                ),
                          ),
                        ],
                      ),

                      SizedBox(height: 35.h),

                      // زرار إنشاء الحساب
                      state is RegisterLoading
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
                              text: "Create Account",
                              onPressed: cubit.onRegisterPressed,
                            ),
                          ),

                      SizedBox(height: 25.h),

                      // الرجوع لتسجيل الدخول
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap:
                                () => MyNavigator.goTo(
                                  context,
                                  const LoginView(),
                                  type: NavigatorType.push,
                                ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50.h),
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
