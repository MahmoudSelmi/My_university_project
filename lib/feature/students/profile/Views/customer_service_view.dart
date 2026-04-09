import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerServiceView extends StatelessWidget {
  const CustomerServiceView({super.key});

  final String email = "Ma7moud.m.selmy1@gmail.com";
  final String phone = "01098494030";

  // ميثود لفتح الإيميل (التوافق مع النسخ القديمة والجديدة)
  Future<void> _openEmail() async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  // ميثود لفتح الواتساب
  Future<void> _openWhatsApp() async {
    final Uri whatsappUri = Uri.parse("https://wa.me/201098494030");
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    const LinearGradient meshGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => meshGradient.createShader(bounds),
          child: const Text(
            'Support Center',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: AnimationLimiter(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 600),
            childAnimationBuilder:
                (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
            children: [
              // --- عرض الـ QR Code اللي بعته في الصورة ---
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: meshGradient,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      // استبدل المسار ده بالمسار الصحيح في الـ Assets عندك
                      child: Image.asset(
                        'assets/images/qr_code.png', // الصورة اللي إنت بعتها
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // لو الصورة لسه فيها مشكلة تظهر أيقونة بدل ما الشاشة تضرب أحمر
                          return const Icon(
                            Icons.qr_code_2_rounded,
                            size: 100,
                            color: Color(0xFF6366F1),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const Center(
                child: Text(
                  "Scan QR for Technical Support",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),

              // كارت الإيميل
              _buildContactCard(
                context,
                title: "Email Support",
                subtitle: email,
                icon: Icons.alternate_email_rounded,
                onTap: _openEmail,
              ),

              const SizedBox(height: 15),

              // كارت الواتساب
              _buildContactCard(
                context,
                title: "WhatsApp",
                subtitle: phone,
                icon: Icons.chat_bubble_outline_rounded,
                onTap: _openWhatsApp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF6366F1), size: 26),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      ),
    );
  }
}
