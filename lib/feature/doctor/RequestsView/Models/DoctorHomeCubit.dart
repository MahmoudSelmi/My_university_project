import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_slmi/core/helper/CacheHelper.dart';
import 'doctor_home_states.dart';

class DoctorHomeCubit extends Cubit<DoctorHomeStates> {
  DoctorHomeCubit() : super(DoctorHomeInitial());
  static DoctorHomeCubit get(context) => BlocProvider.of(context);

  static const String _projectsKey = 'doctor_active_projects';
  static const String _pendingKey = 'doctor_pending_requests';

  List<Map<String, dynamic>> activeProjects = <Map<String, dynamic>>[];

  List<Map<String, dynamic>> pendingRequests = <Map<String, dynamic>>[
    {
      "title": "Smart City IoT",
      "leader": "أحمد حسن",
      "desc":
          "نظام ذكي لإدارة أعمدة الإنارة وحاويات النفايات باستخدام مستشعرات IoT.",
      "members": ["أحمد حسن", "محمد علي", "سارة خالد", "ياسين عمر", "ليلى حسن"],
    },
    {
      "title": "Tele-Medicine App",
      "leader": "إبراهيم عادل",
      "desc":
          "تطبيق لربط المرضى بالأطباء في المناطق النائية عبر استشارات الفيديو.",
      "members": [
        "إبراهيم عادل",
        "نور أحمد",
        "خالد منصور",
        "مريم يوسف",
        "عمر فاروق",
      ],
    },
    {
      "title": "Blockchain Voting",
      "leader": "ياسين حسن",
      "desc": "نظام تصويت إلكتروني آمن يعتمد على تقنية البلوكشين لمنع التزوير.",
      "members": [
        "ياسين حسن",
        "هاني رمزي",
        "سلمى عبدالله",
        "كريم محمود",
        "دينا وليد",
      ],
    },
    {
      "title": "AR Museum Guide",
      "leader": "ليلى إبراهيم",
      "desc": "دليل سياحي للمتاحف يستخدم الواقع المعزز لشرح القطع الأثرية.",
      "members": [
        "ليلى إبراهيم",
        "أحمد سامي",
        "رنا حسين",
        "تامر صالح",
        "نادية عمر",
      ],
    },
  ];

  void getHomeData() async {
    emit(DoctorHomeLoading());
    await Future.delayed(const Duration(milliseconds: 300));

    final String? pendingJson = CacheHelper.getData(key: _pendingKey);
    if (pendingJson != null) {
      final List decoded = jsonDecode(pendingJson);
      pendingRequests =
          decoded
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
    }

    final String? projectsJson = CacheHelper.getData(key: _projectsKey);
    if (projectsJson != null) {
      final List decoded = jsonDecode(projectsJson);
      activeProjects =
          decoded
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
    }

    _refreshUI();
  }

  void _saveProjects() => CacheHelper.saveData(
    key: _projectsKey,
    value: jsonEncode(activeProjects),
  );

  void _savePending() => CacheHelper.saveData(
    key: _pendingKey,
    value: jsonEncode(pendingRequests),
  );

  void acceptProject(Map<String, dynamic> project) {
    activeProjects.add(Map<String, dynamic>.from(project));
    final idx = pendingRequests.indexWhere(
      (r) => r['title'] == project['title'],
    );
    if (idx != -1) pendingRequests.removeAt(idx);
    _saveProjects();
    _savePending();
    _refreshUI();
  }

  void rejectRequest(int index) {
    if (index < 0 || index >= pendingRequests.length) return;
    pendingRequests.removeAt(index);
    _savePending();
    _refreshUI();
  }

  void deleteTeam(int index) {
    if (index < 0 || index >= activeProjects.length) return;
    activeProjects.removeAt(index);
    _saveProjects();
    _refreshUI();
  }

  void removeMember(int teamIndex, int memberIndex) {
    if (teamIndex < 0 || teamIndex >= activeProjects.length) return;
    final List members = List.from(activeProjects[teamIndex]['members'] ?? []);
    if (memberIndex < 0 || memberIndex >= members.length) return;
    members.removeAt(memberIndex);
    activeProjects[teamIndex] = Map<String, dynamic>.from(
      activeProjects[teamIndex],
    );
    activeProjects[teamIndex]['members'] = members;
    _saveProjects();
    _refreshUI();
  }

  void _refreshUI() {
    emit(
      DoctorHomeSuccess(
        projects: List<Map<String, dynamic>>.from(activeProjects),
        pendingRequests: List<Map<String, dynamic>>.from(pendingRequests),
        stats: {
          "totalProjects": activeProjects.length,
          "pendingActions": pendingRequests.length,
        },
      ),
    );
  }
}
