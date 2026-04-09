import 'dart:async';
import 'package:auth_slmi/core/helper/app_nav.dart';
import 'package:auth_slmi/core/utiles/app_colors.dart';
import 'package:auth_slmi/core/widgts/app_snkparr.dart';
import 'package:auth_slmi/core/widgts/custom_buttom.dart';
import 'package:auth_slmi/feature/auth/Login/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../manager/verify_cubit/verify_cubit.dart';
import '../manager/verify_cubit/verify_states.dart';

class VerifyView extends StatefulWidget {
  const VerifyView({super.key, required this.email});
  final String email;

  @override
  State<VerifyView> createState() => _VerifyViewState();
}

class _VerifyViewState extends State<VerifyView> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _remainingSeconds = 600;

  final LinearGradient brandGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _remainingSeconds = 600;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
        if (mounted) setState(() {});
      } else {
        if (mounted)
          setState(() {
            _remainingSeconds--;
          });
      }
    });
  }

  String get timerText {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void onChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
    setState(() {}); // لتحديث لون الحواف فوراً عند الكتابة
  }

  String getCode() => controllers.map((e) => e.text).join();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerifyCubit(),
      child: BlocConsumer<VerifyCubit, VerifyState>(
        listener: (context, state) {
          if (state is VerifySuccess) {
            AppToast.success(context, state.message);
            MyNavigator.goTo(
              context,
              const LoginView(),
              type: NavigatorType.pushAndRemoveUntil,
            );
          } else if (state is VerifyError) {
            AppToast.error(context, state.error);
          }
        },
        builder: (context, state) {
          return Scaffold(
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
            body: AnimationLimiter(
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
                    const Center(
                      child: Text(
                        "Verification Code 📩",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Center(
                      child: Text(
                        "We've sent a 6-digit code to\n${widget.email}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14.sp,
                          height: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          timerText,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                _remainingSeconds == 0
                                    ? Colors.red
                                    : AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // حقول الـ OTP باللون الأسود الصريح والواضح
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) => Container(
                          width: 45.w,
                          height: 55.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  controllers[index].text.isNotEmpty
                                      ? Colors.black
                                      : Colors.grey.shade300,
                              width: 2.0, // سمك الحواف
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: TextField(
                              controller: controllers[index],
                              focusNode: focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              obscureText: false, // لضمان ظهور الرقم وليس نقاط
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w900, // أتقل وزن للخط
                                color: Colors.black, // أسود صريح
                              ),
                              decoration: const InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (value) => onChanged(value, index),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),
                    state is VerifyLoading
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
                            text: "Verify Account",
                            onPressed: () {
                              if (_remainingSeconds == 0) {
                                AppToast.error(
                                  context,
                                  "Code expired, resend again",
                                );
                                return;
                              }
                              final code = getCode();
                              if (code.length < 6) {
                                AppToast.error(
                                  context,
                                  "Please enter 6 digits",
                                );
                                return;
                              }
                              VerifyCubit.get(
                                context,
                              ).verify(email: widget.email, code: code);
                            },
                          ),
                        ),
                    if (_remainingSeconds == 0)
                      Center(
                        child: TextButton(
                          onPressed: () {
                            _startTimer();
                            AppToast.success(
                              context,
                              "Verification code resent",
                            );
                          },
                          child: const Text(
                            "Resend New Code",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
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
    );
  }
}
