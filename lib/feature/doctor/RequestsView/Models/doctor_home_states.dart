abstract class DoctorHomeStates {}

class DoctorHomeInitial extends DoctorHomeStates {}

class DoctorHomeLoading extends DoctorHomeStates {}

class DoctorHomeSuccess extends DoctorHomeStates {
  final List<Map<String, dynamic>> projects;
  final List<Map<String, dynamic>> pendingRequests;
  final Map<String, dynamic> stats;

  DoctorHomeSuccess({
    required this.projects,
    required this.pendingRequests,
    required this.stats,
  });
}

class DoctorHomeError extends DoctorHomeStates {
  final String message;
  DoctorHomeError({required this.message});
}
