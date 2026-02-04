import 'package:auth_slmi/feature/forget_pass/manager/forget_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/forget_repo.dart';

class ForgetCubit extends Cubit<ForgetPasswordState> {
  ForgetCubit() : super(ForgetPasswordInitial());
  static ForgetCubit get(context) => BlocProvider.of(context);
  var emailController = TextEditingController();
  var formkay = GlobalKey<FormState>();

  Future<void> forgetPassword() async {
    if (!formkay.currentState!.validate()) {
      return;
    }
    emit(ForgetPasswordLoading());
    final ForgetRepo forgetRepo = ForgetRepo();
    var response = await forgetRepo.forget(email: emailController.text.trim());
    response.fold(
      (String error) => emit(ForgetPasswordError(error: error)),
      (response) => emit(ForgetPasswordSuccess(message: response.message)),
    );
  }
}
