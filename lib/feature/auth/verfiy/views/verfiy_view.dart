import 'dart:async';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:auth_slmi/core/helper/app_nav.dart';
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

class _VerifyViewState extends State<VerifyView>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  late AnimationController _animationController;
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
    // أنيميشن المنظور الـ 4D
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
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
        if (mounted) setState(() => _remainingSeconds--);
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
    _animationController.dispose();
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
    setState(() {});
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
            backgroundColor: const Color(0xFF010208),
            body: Stack(
              children: [
                // --- 1. الـ Nebula المتحركة ---
                _buildAnimatedNebula(),

                // زر العودة
                Positioned(
                  top: 50.h,
                  left: 20.w,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                SafeArea(
                  child: Center(
                    child: AnimationLimiter(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 1000),
                            childAnimationBuilder:
                                (widget) => SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(child: widget),
                                ),
                            children: [
                              // --- 2. الهيدر بنظام الـ 4D ---
                              _build4DHeader(),

                              SizedBox(height: 40.h),

                              // --- 3. كارت الـ OTP بنظام الـ 4D ---
                              _build4DVerifyCard(context, state),

                              SizedBox(height: 20.h),

                              if (_remainingSeconds == 0)
                                TextButton(
                                  onPressed: () {
                                    _startTimer();
                                    AppToast.success(context, "Code resent");
                                  },
                                  child: const Text(
                                    "Resend New Code",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFEC4899),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _build4DVerifyCard(BuildContext context, VerifyState state) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform:
              Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_animationController.value * 0.04)
                ..rotateY(_animationController.value * 0.02),
          child: child,
        );
      },
      child: BlurryContainer(
        blur: 20,
        color: Colors.white.withValues(alpha: 0.04),
        padding: EdgeInsets.all(25.w),
        borderRadius: BorderRadius.circular(40.r),
        child: Column(
          children: [
            const Text(
              "Verification Code 📩",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "We've sent a 6-digit code to\n${widget.email}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF8B949E),
                fontSize: 13.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),

            // التايمر النيون
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                timerText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      _remainingSeconds == 0
                          ? Colors.redAccent
                          : const Color(0xFF22D3EE),
                ),
              ),
            ),

            SizedBox(height: 40.h),

            // حقول الـ OTP بتصميم مجسم
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) => _buildOtpBox(index)),
            ),

            SizedBox(height: 40.h),

            state is VerifyLoading
                ? const CircularProgressIndicator(color: Color(0xFF6366F1))
                : Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: CustomButton(
                    text: "Verify Account",
                    onPressed: () {
                      if (_remainingSeconds == 0) {
                        AppToast.error(context, "Code expired");
                        return;
                      }
                      final code = getCode();
                      if (code.length < 6) {
                        AppToast.error(context, "Enter 6 digits");
                        return;
                      }
                      VerifyCubit.get(
                        context,
                      ).verify(email: widget.email, code: code);
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    bool hasText = controllers[index].text.isNotEmpty;
    return Container(
      width: 42.w,
      height: 55.h,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasText ? const Color(0xFF6366F1) : Colors.white10,
          width: 2.0,
        ),
        boxShadow:
            hasText
                ? [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                    blurRadius: 10,
                  ),
                ]
                : null,
      ),
      child: Center(
        child: TextField(
          controller: controllers[index],
          focusNode: focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
          ),
          onChanged: (value) => onChanged(value, index),
        ),
      ),
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
                      blurRadius: 25,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 50.sp,
                ),
              ),
              SizedBox(height: 15.h),
              ShaderMask(
                shaderCallback: (bounds) => brandGradient.createShader(bounds),
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedNebula() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: -100.h + (_animationController.value * 20),
              right: -50.w,
              child: _glowOrb(
                const Color(0xFF6366F1).withValues(alpha: 0.2),
                350.w,
              ),
            ),
            Positioned(
              bottom: -50.h,
              left: -100.w - (_animationController.value * 20),
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

  Widget _glowOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 80)],
      ),
    );
  }
}
