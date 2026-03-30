import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/login_repo.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  static LoginCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formkay = GlobalKey<FormState>();
  final LoginRepo loginRepo = LoginRepo();
  void changePasswordVisibility() {
    isPassword = !isPassword;
    emit(ChangePasswordVisibilityState());
  }

  void onLoginPressed() async {
    if (!formkay.currentState!.validate()) {
      return;
    }
    emit(LoginLoading());
    var response = await loginRepo.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    response.fold(
      (String error) => emit(LoginError(error: error)),
      (response) => emit(LoginSuccess(message: response)),
    );
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
  }
}
