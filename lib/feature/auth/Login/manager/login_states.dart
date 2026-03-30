import 'package:auth_slmi/feature/auth/Login/data/model/login_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginModel message;

  LoginSuccess({required this.message});
}

class LoginError extends LoginState {
  final String error;

  LoginError({required this.error});
}

class ChangePasswordVisibilityState extends LoginState {}
