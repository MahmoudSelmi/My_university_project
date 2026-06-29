import 'package:auth_slmi/core/helper/CacheHelper.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:auth_slmi/feature/auth/Login/data/model/login_model.dart';

import '../data/repo/login_repo.dart';

import 'login_states.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;

  bool isDoctorRole = false; // لاختيار النوع من الواجهة

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formkay = GlobalKey<FormState>();

  final LoginRepo loginRepo = LoginRepo();

  void selectRole(bool isDoctor) {
    isDoctorRole = isDoctor;

    emit(ChangeRoleState());
  }

  void changePasswordVisibility() {
    isPassword = !isPassword;

    emit(ChangePasswordVisibilityState());
  }

  void onLoginPressed() async {
    if (!formkay.currentState!.validate()) return;

    String email = emailController.text.trim();

    String password = passwordController.text.trim();

    // --- شرط دكتور زياد (الكاش الأصلي بتاعك) ---

    if (isDoctorRole &&
        email == "zeyadnull@gmail.com" &&
        password == "123456789") {
      emit(LoginLoading());

      // الكاش بتاعك زي ما هو بالظبط

      await CacheHelper.saveData(key: 'isLoggedIn', value: true);

      await CacheHelper.saveData(key: 'userRole', value: 'doctor');

      await CacheHelper.saveData(key: 'userName', value: 'Dr. Zeyad');

      await Future.delayed(const Duration(milliseconds: 500));

      emit(
        LoginSuccess(
          message: LoginModel(status: true, message: "Welcome Dr. Zeyad"),
        ),
      );

      return;
    }

    // --- تسجيل دخول الطلاب عبر الـ API ---

    emit(LoginLoading());

    var response = await loginRepo.login(email: email, password: password);

    response.fold((String error) => emit(LoginError(error: error)), (
      responseModel,
    ) async {
      // الكاش بتاعك للطلاب

      await CacheHelper.saveData(key: 'isLoggedIn', value: true);

      await CacheHelper.saveData(key: 'userRole', value: 'student');

      emit(LoginSuccess(message: responseModel));
    });
  }

  void clearControllers() {
    emailController.clear();

    passwordController.clear();
  }

  void logout() async {
    await CacheHelper.removeData(key: 'isLoggedIn');

    await CacheHelper.removeData(key: 'userRole');

    await CacheHelper.removeData(key: 'userName');
  }
}
