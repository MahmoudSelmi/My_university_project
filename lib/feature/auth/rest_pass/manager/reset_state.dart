abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final String message;

  ResetPasswordSuccess({required this.message});
}

class ResetPasswordError extends ResetPasswordState {
  final String error;

  ResetPasswordError({required this.error});
}

class ResetPasswordChangeVisibility extends ResetPasswordState {}

class ResetPasswordChangeConfirmVisibility extends ResetPasswordState {}
