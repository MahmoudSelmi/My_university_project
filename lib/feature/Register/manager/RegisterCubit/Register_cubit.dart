import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/register_repo.dart';
import 'Register_states.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();

  bool isPassword = true;
  bool isConfirmPassword = true;

  final nameController = TextEditingController();
  final universityCodeController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? selectedUniversityName;
  String? selectedUniversityId;

  String? selectedDepartmentName;
  String? selectedDepartmentId;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    emit(RegisterChangePasswordVisibility());
  }

  void changeConfirmPasswordVisibility() {
    isConfirmPassword = !isConfirmPassword;
    emit(RegisterChangeConfirmPasswordVisibility());
  }

  void onRegisterPressed() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedUniversityId == null) {
      emit(RegisterError(error: "Please select university"));
      return;
    }

    if (selectedDepartmentId == null) {
      emit(RegisterError(error: "Please select department"));
      return;
    }

    emit(RegisterLoading());

    final repo = RegisterRepo();
    final result = await repo.register(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      universityCode: universityCodeController.text,
      universityId: selectedUniversityId!,
      departmentId: selectedDepartmentId!,
    );

    result.fold(
      (error) => emit(RegisterError(error: error)),
      (response) => emit(RegisterSuccess(response: response)),
    );
  }

  void clearControllers() {
    nameController.clear();
    universityCodeController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    selectedUniversityName = null;
    selectedUniversityId = null;
    selectedDepartmentName = null;
    selectedDepartmentId = null;

    emit(RegisterInitial());
  }
}
