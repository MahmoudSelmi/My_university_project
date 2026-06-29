import 'package:auth_slmi/feature/auth/Login/data/model/login_model.dart';

abstract class LoginState {}

// الحالة الابتدائية

class LoginInitial extends LoginState {}

// حالة التحميل أثناء الضغط على زر تسجيل الدخول

class LoginLoading extends LoginState {}

// حالة النجاح مع استقبال موديل البيانات

class LoginSuccess extends LoginState {
  final LoginModel message;

  LoginSuccess({required this.message});
}

// حالة الخطأ مع استقبال رسالة الخطأ من السيرفر

class LoginError extends LoginState {
  final String error;

  LoginError({required this.error});
}

// حالة تغيير رؤية كلمة المرور (إظهار/إخفاء)

class ChangePasswordVisibilityState extends LoginState {}

class ChangeRoleState extends LoginState {}
