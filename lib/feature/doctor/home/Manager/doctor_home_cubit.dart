import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_slmi/core/Models/project_model.dart';
import 'package:auth_slmi/feature/students/Home/data/DioHelper.dart';
import 'doctor_home_states.dart';

class DoctorCubit extends Cubit<DoctorStates> {
  DoctorCubit() : super(DoctorHomeInitial());

  static DoctorCubit get(context) => BlocProvider.of(context);

  void getDoctorDashboard() async {
    emit(DoctorLoading());
    try {
      const String token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NDY5MWJiMTM5NzQyZWI3YmY5MmUwMSIsInJvbGUiOiJkb2N0b3IiLCJpYXQiOjE3Njk4Njg3MjUsImV4cCI6MTc3ODUwODcyNX0.NFZUEBUWfTsaNLo4yxN6gFKV6cy_uIAqKe8ESyRnK9g';

      final statsRes = await DioHelper.getData(
        url: 'projects/doctor/stats',
        token: token,
        data: {},
      );
      final projectsRes = await DioHelper.getData(
        url: 'projects/all/doctor',
        query: {'status': 'start'},
        token: token,
        data: {},
      );

      List<ProjectModel> projects = [];
      if (projectsRes.data['success'] == true) {
        projectsRes.data['data'].forEach(
          (element) => projects.add(ProjectModel.fromJson(element)),
        );
      }

      if (projects.isEmpty) {
        _loadDoctorMockData(statsRes.data['data']?['stats']);
      } else {
        emit(DoctorSuccess(projects, statsRes.data['data']?['stats']));
      }
    } catch (e) {
      _loadDoctorMockData({});
    }
  }

  void _loadDoctorMockData(Map<String, dynamic>? stats) {
    List<ProjectModel> mockData = [
      ProjectModel(
        projectId: "6983252d98e720bad73f3def",
        projectTitle: "سياحه",
        projectDescription: "السياحه في مصر - تطوير منصة إرشاد سياحي ذكية",
        projectYear: "2026",
        projectType: "web",
        doctorFullName: "D / Ahmed Ali",
        id: '',
        title: '',
        description: '',
      ),
      ProjectModel(
        projectId: "69503c11ff866e0c538bc487",
        projectTitle: "الذكاء الاصطناعي",
        projectDescription:
            "استخدام الذكاء الاصطناعي في تطوير الخدمات الحكومية",
        projectYear: "2026",
        projectType: "web",
        doctorFullName: "D / Ahmed Ali",
        id: '',
        title: '',
        description: '',
      ),
    ];
    emit(DoctorSuccess(mockData, stats ?? {}));
  }
}
