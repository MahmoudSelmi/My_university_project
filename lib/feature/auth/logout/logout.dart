// import 'package:auth_slmi/core/helper/app_nav.dart';
// import 'package:auth_slmi/feature/auth/Login/views/login_view.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomeView extends StatelessWidget {
//   const HomeView({super.key});

//   Future<void> _logout(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('access_token');
//     await prefs.remove('refresh_token');
//     if (!context.mounted) return;
//     MyNavigator.goTo(
//       context,
//       LoginView(),
//       type: NavigatorType.pushAndRemoveUntil,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => _logout(context),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.red,
//             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//           ),
//           child: const Text("Logout", style: TextStyle(fontSize: 18)),
//         ),
//       ),
//     );
//   }
// }
