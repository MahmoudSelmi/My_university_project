import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerServiceView extends StatelessWidget {
  const CustomerServiceView({super.key});

  final String email = "Ma7moud.m.selmy1@gmail.com";
  final String phone = "+201098494030";

  // ميثود لفتح الإيميل
  Future<void> _openEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Support Request - Graduation Project App',
    );
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $emailUri';
      }
    } catch (e) {
      debugPrint("Error launching email: $e");
    }
  }

  // ميثود لفتح الواتساب مباشرة
  Future<void> _openWhatsApp() async {
    // نستخدم الرابط الرسمي wa.me فهو الأكثر استقراراً
    final Uri whatsappUri = Uri.parse("https://wa.me/201098494030");
    try {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Error launching WhatsApp: $e");
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
              // --- QR Code Section ---
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
                      child: Image.asset(
                        'assets/images/qr_code.png',
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 180,
                            height: 180,
                            color: Colors.grey.shade100,
                            child: const Icon(
                              Icons.qr_code_2_rounded,
                              size: 100,
                              color: Color(0xFF6366F1),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Center(
                child: Text(
                  "Scan for Instant Support",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(height: 40),

              // --- Contact Options ---
              _buildContactCard(
                context,
                title: "Email Address",
                subtitle: email,
                icon: Icons.alternate_email_rounded,
                color: const Color(0xFF6366F1),
                onTap: _openEmail,
              ),
              const SizedBox(height: 16),
              _buildContactCard(
                context,
                title: "WhatsApp Chat",
                subtitle: "Available 24/7",
                icon: Icons.chat_bubble_outline_rounded,
                color: const Color(0xFF25D366), // لون الواتساب الرسمي
                onTap: _openWhatsApp,
              ),
              const SizedBox(height: 40),

              const Text(
                "Our team usually responds within 2 hours.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
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
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: Colors.grey,
        ),
      ),
    );
  }
}
