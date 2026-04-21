import 'package:flutter/foundation.dart';

@immutable
abstract class DoctorHomeStates {}

class DoctorHomeInitial extends DoctorHomeStates {}

class DoctorHomeLoading extends DoctorHomeStates {}

class DoctorHomeSuccess extends DoctorHomeStates {
  final List<Map<String, dynamic>> projects;
  final List<Map<String, dynamic>> pendingRequests;
  final Map<String, dynamic> stats;

  DoctorHomeSuccess(this.projects, this.stats, {required this.pendingRequests});
}
