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
        setState(() {});
      } else {
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
  }

  String getCode() {
    return controllers.map((e) => e.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerifyCubit(),
      child: BlocConsumer<VerifyCubit, VerifyState>(
        listener: (context, state) {
          if (state is VerifySuccess) {
            AppToast.success(context, state.message);
            MyNavigator.goTo(context, const LoginView());
          } else if (state is VerifyError) {
            AppToast.error(context, state.error);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              title: const Text("Verify Code"),
              centerTitle: true,
            ),
            body: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Enter Verification Code",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 12.h),

                  Text(
                    "We sent a 6-digit code to\n${widget.email}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  SizedBox(height: 16.h),

                  Text(
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

                  SizedBox(height: 32.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => SizedBox(
                        width: 50.w,
                        child: TextField(
                          controller: controllers[index],
                          focusNode: focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],

                          decoration: const InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => onChanged(value, index),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  state is VerifyLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                        text: "Verify",
                        width: double.infinity,
                        height: 50,
                        color: AppColors.primary,
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
                            AppToast.error(context, "Please enter 6 digits");
                            return;
                          }

                          VerifyCubit.get(
                            context,
                          ).verify(email: widget.email, code: code);
                        },
                      ),

                  if (_remainingSeconds == 0)
                    TextButton(
                      onPressed: () {
                        _startTimer();
                        AppToast.success(context, "Verification code resent");
                      },
                      child: const Text("Resend Code"),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
