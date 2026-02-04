import 'package:auth_slmi/feature/Register/data/repos/universities_repo.dart';
import 'package:auth_slmi/feature/Register/manager/Universitiecubit/universities_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UniversitiesCubit extends Cubit<UniversitiesStates> {
  UniversitiesCubit() : super(UniversitiesInitial());
  static UniversitiesCubit get(context) => BlocProvider.of(context);
  getUniversities() async {
    UniversitieRepo universitieRepo = UniversitieRepo();
    emit(UniversitiesLoading());
    var response = await universitieRepo.getUniversities();
    response.fold(
      (error) {
        emit(UniversitiesError(error: error));
      },
      (data) {
        emit(UniversitiesSuccess(data: data));
      },
    );
  }
}
