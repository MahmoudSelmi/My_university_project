import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auth_slmi/core/BottomNavState/StudentMainLayout.dart';
import 'package:auth_slmi/feature/auth/Login/views/login_view.dart';
import 'core/helper/app_nav.dart';

class SplachView extends StatefulWidget {
  const SplachView({super.key});

  @override
  State<SplachView> createState() => _SplachViewState();
}

class _SplachViewState extends State<SplachView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // تدرج الألوان المعتمد بتاعك
  final LinearGradient brandGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  @override
  void initState() {
    super.initState();

    // أنيميشن الدوران المنظوري (4D Movement)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    await Future.delayed(const Duration(seconds: 5));
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF010208), // أسود فضاء عميق جداً
      body: Stack(
        alignment: Alignment.center,
        children: [
          // --- 1. الـ Nebula المتحركة في الخلفية ---
          _buildAnimatedNebula(),

          // --- 2. الـ 4D Core (اللوجو والاسم بنظام المنظور) ---
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.identity()
                      ..setEntry(3, 2, 0.002) // إضافة عمق للمنظور (Perspective)
                      ..rotateY(
                        _controller.value * 0.2,
                      ) // دوران خفيف حول المحور الرأسي
                      ..rotateX(
                        _controller.value * 0.1,
                      ), // ميلان خفيف للأمام والخلف
                child: child,
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _build4DGraduationLogo(),
                SizedBox(height: 40.h),
                _build4DTitle(),
                SizedBox(height: 15.h),
                _buildShadowText(),
              ],
            ),
          ),

          // --- 3. لودر "ماسح الضوء" (Scanning Loader) ---
          _buildScanningLoader(),
        ],
      ),
    );
  }

  Widget _build4DGraduationLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // توهج خلفي (Halo)
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                blurRadius: 60,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
        // القبَّعة السودة بتصميم مجسم
        Container(
          padding: EdgeInsets.all(25.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 0.5,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [Colors.white.withValues(alpha: 0.1), Colors.transparent],
            ),
          ),
          child: Icon(Icons.school_rounded, color: Colors.white, size: 70.sp),
        ),
      ],
    );
  }

  Widget _build4DTitle() {
    return Stack(
      children: [
        // ظل خلفي بعيد لإعطاء إحساس الـ 3D
        Text(
          'Khotwa',
          style: TextStyle(
            fontSize: 65.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.5,
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 4
                  ..color = Colors.white.withValues(alpha: 0.05),
          ),
        ),
        // النص الأصلي المتدرج
        ShaderMask(
          shaderCallback: (bounds) => brandGradient.createShader(bounds),
          child: Text(
            'Khotwa',
            style: TextStyle(
              color: Colors.white,
              fontSize: 65.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShadowText() {
    return Text(
      "UNIVERSAL ACADEMIC SYSTEM",
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.4),
        fontSize: 10.sp,
        letterSpacing: 8.0,
        fontWeight: FontWeight.w300,
        shadows: [
          Shadow(color: Colors.white.withValues(alpha: 0.5), blurRadius: 10),
        ],
      ),
    );
  }

  Widget _buildScanningLoader() {
    return Positioned(
      bottom: 80.h,
      child: Column(
        children: [
          Container(
            width: 200.w,
            height: 1.h,
            color: Colors.white.withValues(alpha: 0.1),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: _controller.value * 200.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          const Color(0xFF6366F1),
                          Colors.white,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            "CORE MODULE LOADING...",
            style: TextStyle(
              color: Colors.white24,
              fontSize: 8.sp,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedNebula() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: -100.h + (_controller.value * 50),
              right: -50.w + (_controller.value * 30),
              child: _glowOrb(
                const Color(0xFF6366F1).withValues(alpha: 0.2),
                400.w,
              ),
            ),
            Positioned(
              bottom: -100.h - (_controller.value * 40),
              left: -50.w - (_controller.value * 20),
              child: _glowOrb(
                const Color(0xFFEC4899).withValues(alpha: 0.15),
                450.w,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _glowOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }
}
