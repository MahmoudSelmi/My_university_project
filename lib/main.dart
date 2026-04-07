import 'package:auth_slmi/core/BottomNavState/BottomNavCubit.dart';
import 'package:auth_slmi/feature/Home/data/DioHelper.dart';
import 'package:auth_slmi/feature/Home/manager/home_cubit.dart';
import 'package:auth_slmi/feature/projects/Manager/MyProjectState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'splach_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init(); // لازم await هنا
  await DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavCubit()),
        BlocProvider(create: (context) => HomeCubit()..getHomeProjects()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplachView(),
          );
        },
      ),
    );
  }
}
