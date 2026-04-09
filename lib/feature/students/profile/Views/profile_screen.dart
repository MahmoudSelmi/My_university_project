import 'package:auth_slmi/core/helper/CacheHelper.dart';
// تأكد من صحة هذا الـ Import حسب مكان الفولدر عندك
import 'package:auth_slmi/feature/students/profile/Views/customer_service_view.dart';
import 'package:auth_slmi/feature/students/profile/Views/egyptian_bot_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_slmi/core/helper/app_nav.dart';
import 'package:auth_slmi/feature/auth/Login/views/login_view.dart';
import 'package:auth_slmi/feature/auth/rest_pass/views/rest_pass_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedGender = 'Male';
  final TextEditingController _bioController = TextEditingController(
    text: "Flutter Developer",
  );
  final TextEditingController _phoneController = TextEditingController();

  final LinearGradient meshGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildModernAppBar(),
      body: AnimationLimiter(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 600),
            childAnimationBuilder:
                (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
            children: [
              _buildMainProfileCard(),
              const SizedBox(height: 25),
              _buildSectionTitle('Academic Information'),
              const SizedBox(height: 15),
              _infoCard(
                "University",
                "Helwan University",
                Icons.school_rounded,
              ),
              _infoCard(
                "Department",
                "Software Engineering",
                Icons.account_tree_rounded,
              ),

              const SizedBox(height: 25),
              _buildSectionTitle('Settings & Security'),
              const SizedBox(height: 15),

              // Dark Mode
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  bool isDark = themeMode == ThemeMode.dark;
                  return _buildThemeOption(
                    title: "Dark Mode",
                    subtitle:
                        isDark ? "Switch to light mode" : "Enable dark theme",
                    icon:
                        isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                    value: isDark,
                    onChanged:
                        (val) => context.read<ThemeCubit>().toggleTheme(val),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Change Password
              _buildSecurityOption(
                title: "Change Password",
                subtitle: "Update your security credentials",
                icon: Icons.lock_outline_rounded,
                onTap:
                    () => MyNavigator.goTo(
                      context,
                      const ResetPasswordView(),
                      type: NavigatorType.push,
                    ),
              ),
              const SizedBox(height: 12),

              // Customer Service (تم الإصلاح هنا)
              _buildSecurityOption(
                title: "Customer Service",
                subtitle: "Contact us anytime",
                icon: Icons.support_agent,
                onTap:
                    () => MyNavigator.goTo(
                      context,
                      const CustomerServiceView(), // التأكد من كتابة الاسم صحيحاً
                      type: NavigatorType.push,
                    ),
              ),

              // ... داخل ListView في صفحة البروفايل تحت "Customer Service" ...
              const SizedBox(height: 12),

              // زرار الشات بوت الجديد
              _buildSecurityOption(
                title: "AI Bot",
                subtitle: "دردش مع البوت  بتاعنا",
                icon: Icons.auto_awesome_rounded, // أيقونة ذكاء اصطناعي
                onTap:
                    () => MyNavigator.goTo(
                      context,
                      const EgyptianBotView(), // الصفحة اللي عملناها فوق
                      type: NavigatorType.push,
                    ),
              ),
              const SizedBox(height: 25),
              _buildSectionTitle('Edit Profile Details'),
              const SizedBox(height: 15),
              _buildEditableCard(
                controller: _bioController,
                label: "Bio",
                icon: Icons.edit_note_rounded,
                hint: "Write your bio...",
              ),
              const SizedBox(height: 15),
              _buildGenderDropdown(),
              const SizedBox(height: 15),
              _buildEditableCard(
                controller: _phoneController,
                label: "Phone Number",
                icon: Icons.phone_android_rounded,
                hint: "Add Phone Number",
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 40),
              _buildSaveButton(),
              const SizedBox(height: 15),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Reusable Widgets (No changes here) ---

  Widget _buildThemeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF6366F1), size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: Switch.adaptive(
          value: value,
          activeColor: const Color(0xFF6366F1),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSecurityOption({
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF6366F1), size: 24),
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

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: ShaderMask(
        shaderCallback: (bounds) => meshGradient.createShader(bounds),
        child: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMainProfileCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: meshGradient,
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 55, color: Color(0xFF6366F1)),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF6366F1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Mahmoud Selmi",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Ma7moud.m.selmy1@gmail.com",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(width: 5),
              Icon(Icons.verified, color: Colors.blue.shade400, size: 14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditableCard({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF6366F1), size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: hint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFA855F7).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.wc_rounded,
              color: Color(0xFFA855F7),
              size: 22,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Gender",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedGender,
                    isDense: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 15,
                    ),
                    items:
                        ['Male', 'Female']
                            .map(
                              (String value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => _selectedGender = val!),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: meshGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEC4899).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showModernSnackBar(context, "Changes Saved!", true),
          child: const Center(
            child: Text(
              'Save Changes',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _logout(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Colors.red.shade400, size: 22),
            const SizedBox(width: 10),
            const Text(
              "Logout",
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            gradient: meshGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade400, size: 20),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    if (!mounted) return;
    _showModernSnackBar(context, "Logged out successfully!", true);
    await Future.delayed(const Duration(milliseconds: 600));
    MyNavigator.goTo(
      context,
      const LoginView(),
      type: NavigatorType.pushAndRemoveUntil,
    );
  }

  void _showModernSnackBar(BuildContext context, String msg, bool isSuccess) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                msg,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor:
            isSuccess ? Colors.green.shade600 : Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }
}

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }
  void toggleTheme(bool isDark) {
    CacheHelper.saveData(key: 'isDark', value: isDark);
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void _loadTheme() {
    bool isDark = CacheHelper.getData(key: 'isDark') ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
