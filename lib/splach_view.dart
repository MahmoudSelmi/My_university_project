import 'package:auth_slmi/core/BottomNavState/StudentMainLayout.dart';
import 'package:auth_slmi/feature/auth/Login/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'core/helper/app_nav.dart';

class SplachView extends StatefulWidget {
  const SplachView({super.key});

  @override
  State<SplachView> createState() => _SplachViewState();
}

class _SplachViewState extends State<SplachView> {
  final LinearGradient brandGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1), // Indigo
      Color(0xFFA855F7), // Purple
      Color(0xFFEC4899), // Pink
    ],
  );

  @override
  void initState() {
    super.initState();
    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));
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
      backgroundColor: const Color(0xFF0F172A), // لون Deep Dark Navy فخم جداً
      body: Stack(
        children: [
          // تأثير الإضاءة الملونة في الخلفية (Glow Effect)
          _buildAmbientGlow(),

          Center(
            child: AnimationConfiguration.synchronized(
              duration: const Duration(milliseconds: 1500),
              child: FadeInAnimation(
                child: ScaleAnimation(
                  scale: 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // الكلمة بتأثير نيون خفيف
                      ShaderMask(
                        shaderCallback:
                            (bounds) => brandGradient.createShader(bounds),
                        child: const Text(
                          'Khotwa',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 56, // حجم ضخم واحترافي
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // خط رفيع جداً تحت الكلمة لإضافة لمسة جمالية
                      Container(
                        width: 50,
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: brandGradient,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Your Path to Success".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                          letterSpacing: 4.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // مؤشر التحميل بتصميم نيون
          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 40,
                height: 2, // لودر خطي بدل الدائرة لإضافة حداثة
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFFEC4899),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientGlow() {
    return Stack(
      children: [
        // توهج أرجواني فوق يمين
        Positioned(
          top: -100,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.15),
                  blurRadius: 150,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        ),
        // توهج وردي تحت شمال
        Positioned(
          bottom: -100,
          left: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEC4899).withOpacity(0.15),
                  blurRadius: 150,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
