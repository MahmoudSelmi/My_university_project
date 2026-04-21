abstract class DoctorHomeStates {}

class DoctorHomeInitial extends DoctorHomeStates {}

class DoctorHomeLoading extends DoctorHomeStates {}

class DoctorHomeSuccess extends DoctorHomeStates {
  final List<Map<String, dynamic>> pendingRequests;

  DoctorHomeSuccess({required this.pendingRequests});
}

class DoctorHomeError extends DoctorHomeStates {
  final String message;

  DoctorHomeError({required this.message});
}
