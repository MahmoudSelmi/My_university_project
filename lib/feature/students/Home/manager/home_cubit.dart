import 'package:auth_slmi/core/Models/project_model.dart';
import 'package:auth_slmi/feature/students/Home/data/DioHelper.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<ProjectModel> projects;

  HomeSuccess(this.projects);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);

  void getHomeProjects() async {
    emit(HomeLoading());

    try {
      final value = await DioHelper.getData(
        url: 'projects/all',

        query: {'status': 'start'},
        data: {},
        token: '',
      );

      if (value.data['success'] == true) {
        List<ProjectModel> projects = [];

        value.data['data'].forEach((element) {
          projects.add(ProjectModel.fromJson(element));
        });

        emit(HomeSuccess(projects));
      } else {
        emit(HomeError(value.data['message'] ?? "Error"));
      }
    } catch (error) {
      debugPrint("API Error: ${error.toString()}");

      _loadMockData();
    }
  }

  void _loadMockData() {
    List<ProjectModel> mockData = [
      ProjectModel(
        projectId: "6983252d98e720bad73f3def",

        projectTitle: "سياحه",

        projectDescription: "السياحه في مصر",

        projectYear: "2026",

        projectStatus: "start",

        projectType: "web",

        doctorFullName: "D / Ahmed Ali",

        doctorImage:
            "https://res.cloudinary.com/dgfhgkun1/image/upload/v1770728507/user-profiles/r3e5yx8ifbkf5cuatgel.jpg",

        technologies: ["React", "Node.js", "MongoDB"],
        id: '',
        title: '',
        description: '',
        desc: '',
        teamLeader: '',
        status: '',
        leaderName: '',
        year: '',
        members: [],
      ),

      ProjectModel(
        projectId: "69503c11ff866e0c538bc487",

        projectTitle: "الذكاء الاصطناعي",

        projectDescription: "استخدام الذكاء الاصطناعي في تطوير الخدمات",

        projectYear: "2026",

        projectStatus: "start",

        projectType: "web",

        doctorFullName: "D / Ahmed Ali",

        doctorImage:
            "https://res.cloudinary.com/dgfhgkun1/image/upload/v1770728507/user-profiles/r3e5yx8ifbkf5cuatgel.jpg",

        technologies: ["MongoDB", "React", "Node.js"],
        id: '',
        title: '',
        description: '',
        desc: '',
        teamLeader: '',
        status: '',
        leaderName: '',
        year: '',
        members: [],
      ),
    ];

    emit(HomeSuccess(mockData));
  }
}
