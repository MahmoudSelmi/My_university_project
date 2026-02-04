import '../../data/models/universities_model.dart';

abstract class UniversitiesStates {}

class UniversitiesInitial extends UniversitiesStates {}

class UniversitiesLoading extends UniversitiesStates {}

class UniversitiesError extends UniversitiesStates {
  final String error;
  UniversitiesError({required this.error});
}

class UniversitiesSuccess extends UniversitiesStates {
  final UniversitiesModel data;
  UniversitiesSuccess({required this.data});
}
