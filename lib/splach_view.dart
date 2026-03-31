import 'package:auth_slmi/core/BottomNavState/StudentMainLayout.dart';
import 'package:auth_slmi/feature/auth/Login/views/login_view.dart';
import 'package:auth_slmi/feature/auth/logout/logout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/helper/app_nav.dart';
import 'core/utiles/app_icons.dart';
import 'core/widgts/custom_svg.dart';

class SplachView extends StatefulWidget {
  const SplachView({super.key});

  @override
  State<SplachView> createState() => _SplachViewState();
}

class _SplachViewState extends State<SplachView> {
  @override
  void initState() {
    super.initState();
    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (!mounted) return;

    if (accessToken != null && accessToken.isNotEmpty) {
      MyNavigator.goTo(
        context,
        const StudentMainLayout(),
        type: NavigatorType.pushAndRemoveUntil,
      );
    } else {
      MyNavigator.goTo(
        context,
        const LoginView(),
        type: NavigatorType.pushAndRemoveUntil,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: const CustomSvg(path: AppIcons.logo))],
      ),
    );
  }
}
