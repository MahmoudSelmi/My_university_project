import 'package:auth_slmi/feature/doctor/home/Manager/doctor_home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_slmi/core/Models/project_model.dart';
import 'package:auth_slmi/feature/students/Home/data/DioHelper.dart';

class DoctorCubit extends Cubit<DoctorStates> {
  DoctorCubit() : super(DoctorHomeInitial());

  static DoctorCubit get(context) => BlocProvider.of(context);

  void getDoctorDashboard() async {
    emit(DoctorLoading());
    try {
      final String token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NDY5MWJiMTM5NzQyZWI3YmY5MmUwMSIsInJvbGUiOiJkb2N0b3IiLCJpYXQiOjE3Njk4Njg3MjUsImV4cCI6MTc3ODUwODcyNX0.NFZUEBUWfTsaNLo4yxN6gFKV6cy_uIAqKe8ESyRnK9g';

      // جلب الإحصائيات
      final statsRes = await DioHelper.getData(
        url: 'projects/doctor/stats',
        token: token,
        data: {},
      );

      // جلب المشاريع (نفس الـ Endpoint بتاع الـ Home)
      final projectsRes = await DioHelper.getData(
        url: 'projects/all/doctor', // أو 'projects/all' حسب صلاحية الدكتور
        query: {'status': 'start'},
        token: token,
        data: {},
      );

      if (projectsRes.data['success'] == true) {
        List<ProjectModel> projects = [];
        projectsRes.data['data'].forEach((element) {
          projects.add(ProjectModel.fromJson(element));
        });

        // لو السيرفر مطلع لستة فاضية، هنعرض الـ Mock Data عشان الـ UI ميبقاش فاضي
        if (projects.isEmpty) {
          _loadDoctorMockData(statsRes.data['data']['stats']);
        } else {
          emit(DoctorSuccess(projects, statsRes.data['data']['stats']));
        }
      }
    } catch (e) {
      _loadDoctorMockData({}); // لو حصل إيرور حمل البيانات الوهمية
    }
  }

  void _loadDoctorMockData(Map stats) {
    List<ProjectModel> mockData = [
      ProjectModel(
        projectId: "6983252d98e720bad73f3def",
        projectTitle: "سياحه",
        projectDescription: "السياحه في مصر - تطوير منصة إرشاد سياحي ذكية",
        projectYear: "2026",
        projectStatus: "start",
        projectType: "web",
        doctorFullName: "D / Ahmed Ali",
        technologies: ["React", "Node.js", "MongoDB"],
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
        projectStatus: "start",
        projectType: "web",
        doctorFullName: "D / Zeyad Ali",
        technologies: ["MongoDB", "React", "Node.js"],
        id: '',
        title: '',
        description: '',
      ),
    ];
    emit(DoctorSuccess(mockData, stats.cast<String, dynamic>()));
  }
}
