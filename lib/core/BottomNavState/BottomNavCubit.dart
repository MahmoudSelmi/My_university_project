import 'package:auth_slmi/feature/Home/Views/HomeScreen.dart';
import 'package:auth_slmi/feature/profile/Views/my_project_screen.dart';
import 'package:auth_slmi/feature/profile/Views/profile_screen.dart';
import 'package:auth_slmi/feature/projects/Views/previous_projects_screen.dart';
import 'package:auth_slmi/feature/team/Views/teams_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BottomNavState {}

class BottomNavInitial extends BottomNavState {}

class BottomNavChanged extends BottomNavState {
  final int index;
  BottomNavChanged(this.index);
}

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(BottomNavInitial());

  static BottomNavCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = const [
    HomeScreen(),
    MyProjectScreen(),
    TeamsScreen(),
    PreviousProjectsScreen(),
    ProfileScreen(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(BottomNavChanged(currentIndex));
  }
}
