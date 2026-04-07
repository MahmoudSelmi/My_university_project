import 'package:auth_slmi/feature/Home/data/DioHelper.dart';
import 'package:auth_slmi/feature/team/model/TeamModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart'; // افترضنا إن عندك ملف DioHelper اللي عدلناه سوا

class TeamsCubit extends Cubit<TeamsState> {
  TeamsCubit() : super(TeamsInitial());

  static TeamsCubit get(context) => BlocProvider.of(context);

  TeamModel? teamModel;
  final String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5ZDI2ZGUwODYyMjlhMjhkNDcxYzNmYSIsInJvbGUiOiJzdHVkZW50IiwiaWF0IjoxNzc1NTYzODY2LCJleHAiOjE3ODQyMDM4NjZ9.dHj_MJxAvCd6D7OYqL3_ZBs2xWH0Sd1BdM3IniqIQs8";

  void getMyTeam() async {
    emit(TeamsLoading());
    try {
      final response = await DioHelper.getData(
        url: 'teams/my-team',
        token: token,
        data: {},
      );
      if (response.statusCode == 200) {
        teamModel = TeamModel.fromJson(response.data['data']);
        emit(TeamsSuccess());
      }
    } on DioException catch (e) {
      emit(TeamsError(e.response?.data['message'] ?? "خطأ في تحميل الفريق"));
    }
  }
}

abstract class TeamsState {}

class TeamsInitial extends TeamsState {}

class TeamsLoading extends TeamsState {}

class TeamsSuccess extends TeamsState {}

class TeamsError extends TeamsState {
  final String error;
  TeamsError(this.error);
}
