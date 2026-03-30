import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/verify_repo.dart';
import 'verify_states.dart';

class VerifyCubit extends Cubit<VerifyState> {
  VerifyCubit() : super(VerifyInitial());

  static VerifyCubit get(context) => BlocProvider.of(context);

  final VerifyRepo repo = VerifyRepo();

  Future<void> verify({required String email, required String code}) async {
    emit(VerifyLoading());

    final result = await repo.verifyEmail(email: email, code: code);

    result.fold(
      (error) => emit(VerifyError(error: error)),
      (message) => emit(VerifySuccess(message: message.message)),
    );
  }
}
