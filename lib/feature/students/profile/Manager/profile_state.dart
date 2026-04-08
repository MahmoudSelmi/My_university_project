import 'package:auth_slmi/feature/students/profile/Models/profile_model.dart';
import 'package:auth_slmi/feature/students/profile/data/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final ProfileModel model;

  ProfileSuccess(this.model);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repo;

  ProfileCubit(this.repo) : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);

  Future<void> getProfile() async {
    emit(ProfileLoading());

    try {
      final data = await repo.getProfile();
      final model = ProfileModel.fromJson(data);

      emit(ProfileSuccess(model));
    } catch (e) {
      emit(ProfileError("فشل تحميل البروفايل"));
    }
  }
}
