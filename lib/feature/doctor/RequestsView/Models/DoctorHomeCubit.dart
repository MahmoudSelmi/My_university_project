import 'package:flutter_bloc/flutter_bloc.dart';
import 'doctor_home_states.dart';

class DoctorHomeCubit extends Cubit<DoctorHomeStates> {
  DoctorHomeCubit() : super(DoctorHomeInitial());

  static DoctorHomeCubit get(context) => BlocProvider.of(context);

  List<Map<String, dynamic>> _requests = [];

  void loadRequests() async {
    emit(DoctorHomeLoading());

    await Future.delayed(const Duration(seconds: 1));

    _requests = [
      {
        "title": "AI Medical App",
        "leader": "Mahmoud",
        "desc": "تطبيق بيستخدم AI لمساعدة الأطباء في التشخيص",
      },
      {
        "title": "Smart Clinic System",
        "leader": "Ahmed",
        "desc": "سيستم لإدارة العيادات بشكل ذكي وسهل",
      },
    ];

    emit(DoctorHomeSuccess(pendingRequests: _requests));
  }

  void acceptRequest(int index) {
    if (index < 0 || index >= _requests.length) return;

    _requests.removeAt(index);

    emit(DoctorHomeSuccess(pendingRequests: List.from(_requests)));
  }

  void rejectRequest(int index) {
    if (index < 0 || index >= _requests.length) return;

    _requests.removeAt(index);

    emit(DoctorHomeSuccess(pendingRequests: List.from(_requests)));
  }
}
