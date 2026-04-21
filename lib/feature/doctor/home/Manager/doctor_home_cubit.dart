import 'package:flutter_bloc/flutter_bloc.dart';
import 'doctor_home_states.dart';

class DoctorHomeCubit extends Cubit<DoctorHomeStates> {
  DoctorHomeCubit() : super(DoctorHomeInitial());
  static DoctorHomeCubit get(context) => BlocProvider.of(context);

  // لستة المشاريع اللي بتظهر في الـ Home (داتا فيك ثابتة في البداية)
  List<Map<String, dynamic>> activeProjects = [
    {
      "title": "E-Commerce Platform",
      "leader": "محمود سلمي",
      "desc":
          "نظام متكامل للتجارة الإلكترونية يهدف لتسهيل عمليات البيع والشراء عبر الإنترنت مع نظام دفع آمن وإدارة متطورة للمخزون.",
      "members": [
        "محمود سلمي",
        "عبادي",
        "عبد الله أنور",
        "أحمد علي",
        "سارة محمد",
        "ياسين حسن",
        "ليلى إبراهيم",
        "مريم يوسف",
        "خالد منصور",
        "عمر فاروق",
      ],
    },
  ];

  Object? get pendingRequests => null;

  void getHomeData() async {
    emit(DoctorHomeLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    _refreshUI();
  }

  // ميثود قبول الفريق وإضافته للـ Home
  void acceptProject(Map<String, dynamic> newProject) {
    activeProjects.add(newProject);
    _refreshUI();
  }

  void _refreshUI() {
    emit(
      DoctorHomeSuccess(
        List.from(activeProjects), // نبعت نسخة جديدة عشان الـ UI يحس بالتغيير
        {"totalProjects": activeProjects.length, "pendingActions": 4},
        pendingRequests: [],
      ),
    );
  }

  void rejectRequest(int index) {}

  void acceptRequest(int index) {}

  void removeRequest(int index) {}

  void deleteTeam(int index) {}

  void updateTeam(int index, String text, team) {}

  void removeMember(int teamIndex, int i) {}
}
