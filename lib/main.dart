import 'package:auth_slmi/core/Theme%20Option/ThemeCubit.dart';
import 'package:auth_slmi/core/BottomNavState/BottomNavCubit.dart';
import 'package:auth_slmi/core/BottomNavState/StudentMainLayout.dart'; // تأكد من المسار
import 'package:auth_slmi/feature/doctor/DoctorMainLayout/Views/DoctorMainLayout.dart';
import 'package:auth_slmi/core/helper/CacheHelper.dart';
import 'package:auth_slmi/feature/students/Home/data/DioHelper.dart';
import 'package:auth_slmi/feature/students/Home/manager/home_cubit.dart';
import 'package:auth_slmi/splach_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//Ma7moud Selmi
//522660

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await DioHelper.init();

  Widget widget;
  bool? isLoggedIn = CacheHelper.getData(key: 'isLoggedIn');
  String? userRole = CacheHelper.getData(key: 'userRole');

  if (isLoggedIn == true) {
    if (userRole == 'doctor') {
      widget = const DoctorMainLayout();
    } else {
      widget = const StudentMainLayout();
    }
  } else {
    widget = const SplachView();
  }

  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => BottomNavCubit()),
        BlocProvider(create: (context) => HomeCubit()..getHomeProjects()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                themeMode: themeMode,
                theme: ThemeData(
                  brightness: Brightness.light,
                  scaffoldBackgroundColor: const Color(0xFFF8FAFC),
                  primaryColor: const Color(0xFF6366F1),
                  cardColor: Colors.white,
                ),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  scaffoldBackgroundColor: const Color(0xFF0F172A),
                  primaryColor: const Color(0xFF6366F1),
                  cardColor: const Color(0xFF1E293B),
                ),
                home: startWidget,
              );
            },
          );
        },
      ),
    );
  }
}
