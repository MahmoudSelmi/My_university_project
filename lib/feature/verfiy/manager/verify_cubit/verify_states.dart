abstract class VerifyState {}

class VerifyInitial extends VerifyState {}

class VerifyLoading extends VerifyState {}

class VerifySuccess extends VerifyState {
  final String message;

  VerifySuccess({required this.message});
}

class VerifyError extends VerifyState {
  final String error;

  VerifyError({required this.error});
}
