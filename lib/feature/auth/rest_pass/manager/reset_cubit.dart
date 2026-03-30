import 'package:auth_slmi/feature/auth/rest_pass/data/repo/reset_pass.dart';
import 'package:auth_slmi/feature/auth/rest_pass/manager/reset_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetCubit extends Cubit<ResetPasswordState> {
  ResetCubit() : super(ResetPasswordInitial());
  static ResetCubit get(context) => BlocProvider.of(context);
  var emailController = TextEditingController();
  var codeController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  bool isPassword = true;
  bool isConfirmPassword = true;
  var formkay = GlobalKey<FormState>();

  Future<void> resetPassword() async {
    if (!formkay.currentState!.validate()) {
      return;
    }
    emit(ResetPasswordLoading());
    final ResetRepo resetRepo = ResetRepo();
    var response = await resetRepo.reset(
      email: emailController.text.trim(),
      code: codeController.text.trim(),
      newPassword: newPasswordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );
    response.fold(
      (String error) => emit(ResetPasswordError(error: error)),
      (response) => emit(ResetPasswordSuccess(message: response.message)),
    );
  }

  void changePasswordVisibility() {
    isPassword = !isPassword;
    emit(ResetPasswordChangeVisibility());
  }

  void changeConfirmPasswordVisibility() {
    isConfirmPassword = !isConfirmPassword;
    emit(ResetPasswordChangeConfirmVisibility());
  }
}
