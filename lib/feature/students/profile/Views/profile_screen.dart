import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// المسارات الخاصة بمشروعك
import 'package:auth_slmi/core/Theme%20Option/ThemeCubit.dart';
import 'package:auth_slmi/core/helper/app_nav.dart';
import 'package:auth_slmi/feature/auth/Login/views/login_view.dart';
import 'package:auth_slmi/feature/auth/forget_pass/views/forget_pass_view.dart';
import 'package:auth_slmi/feature/students/profile/Views/customer_service_view.dart';
import 'package:auth_slmi/feature/students/profile/Views/AI/egyptian_bot_view.dart';
import 'package:auth_slmi/feature/students/profile/Views/SupervisionRequestPage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _selectedGender;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final LinearGradient meshGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // --- تحميل البيانات وتثبيت الحالة ---
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('user_name') ?? "Mahmoud Selmi";
      _bioController.text = prefs.getString('user_bio') ?? "";
      _phoneController.text = prefs.getString('user_phone') ?? "";
      _selectedGender = prefs.getString('user_gender');

      String? imagePath = prefs.getString('user_image');
      if (imagePath != null && imagePath.isNotEmpty) {
        _imageFile = File(imagePath);
      }
    });
  }

  // --- حفظ البيانات (الكاش النهائي) ---
  Future<void> _saveAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    await prefs.setString('user_bio', _bioController.text);
    await prefs.setString('user_phone', _phoneController.text);
    if (_selectedGender != null) {
      await prefs.setString('user_gender', _selectedGender!);
    } else {
      await prefs.remove('user_gender');
    }

    if (_imageFile != null) {
      await prefs.setString('user_image', _imageFile!.path);
    }

    if (mounted) {
      _showModernSnackBar(context, "تم حفظ وتكييش البيانات بنجاح! ✅", true);
    }
  }

  // --- خيارات الصورة ---
  void _showImageOptions() {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => CupertinoActionSheet(
            title: const Text('Profile Picture'),
            message: const Text('Choose how you want to update your photo'),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
                child: const Text('Take a Photo (Camera)'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
                child: const Text('Choose from Gallery'),
              ),
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  _removeImage();
                },
                child: const Text('Remove Current Photo'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_image', pickedFile.path);
    }
  }

  Future<void> _removeImage() async {
    setState(() {
      _imageFile = null;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_image');
  }

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
                "معاهد العبور",
                Icons.account_balance_rounded,
              ),
              _infoCard("Department", "BIS", Icons.analytics_rounded),
              const SizedBox(height: 25),
              _buildSectionTitle('Personal Details'),
              const SizedBox(height: 15),
              _buildEditableField(
                _nameController,
                "Full Name",
                Icons.person_pin_rounded,
                "Enter your name",
              ),
              _buildEditableField(
                _bioController,
                "Bio",
                Icons.auto_fix_high_rounded,
                "Describe yourself...",
              ),
              _buildGenderDropdown(),
              _buildEditableField(
                _phoneController,
                "Phone",
                Icons.phone_iphone_rounded,
                "01xxxxxxxxx",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 25),
              _buildSectionTitle('Services & Support'),
              const SizedBox(height: 15),
              _buildThemeToggle(),
              _buildSecurityOption(
                "Change Password",
                "Secure your account",
                Icons.vpn_key_rounded,
                () => MyNavigator.goTo(
                  context,
                  const ForgetPassView(),
                  type: NavigatorType.push,
                ),
              ),
              _buildSecurityOption(
                "AI Egyptian Bot",
                "دردش مع الذكاء الاصطناعي",
                Icons.auto_awesome_rounded,
                () => MyNavigator.goTo(
                  context,
                  const KhotwaOmniAI(),
                  type: NavigatorType.push,
                ),
              ),
              _buildSecurityOption(
                "Customer Service",
                "تواصل مع الدعم الفني",
                Icons.headset_mic_rounded,
                () => MyNavigator.goTo(
                  context,
                  const CustomerServiceView(),
                  type: NavigatorType.push,
                ),
              ),
              _buildSecurityOption(
                "Supervision Request",
                "Submit Project",
                Icons.rocket_launch_rounded,
                () => MyNavigator.goTo(
                  context,
                  const SupervisionRequestPage(),
                  type: NavigatorType.push,
                ),
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

  Widget _buildMainProfileCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                onTap: _showImageOptions,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: meshGradient,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                    child:
                        _imageFile == null
                            ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            )
                            : null,
                  ),
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
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            _nameController.text.isEmpty
                ? "Student Name"
                : _nameController.text,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            _bioController.text.isEmpty
                ? "No bio added yet"
                : _bioController.text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildEditableField(
    TextEditingController controller,
    String label,
    IconData icon,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
          border: InputBorder.none,
        ),
        onChanged: (val) => setState(() {}),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(Icons.wc_rounded, color: Colors.purple.shade300, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGender,
                hint: const Text("Select Gender"),
                isExpanded: true,
                items:
                    ['Male', 'Female'].map((String val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    }).toList(),
                onChanged: (val) => setState(() => _selectedGender = val),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle() {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        bool isDark = mode == ThemeMode.dark;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: ListTile(
            leading: Icon(
              isDark ? Icons.nights_stay_rounded : Icons.wb_sunny_rounded,
              color: const Color(0xFF6366F1),
            ),
            title: const Text(
              "Dark Experience",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Switch.adaptive(
              value: isDark,
              activeColor: const Color(0xFF6366F1),
              onChanged: (val) => context.read<ThemeCubit>().toggleTheme(val),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSecurityOption(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFF6366F1)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      ),
    );
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade400, size: 20),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
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
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: _saveAllData,
        borderRadius: BorderRadius.circular(22),
        child: const Center(
          child: Text(
            'Save & Cache Profile',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return TextButton(
      onPressed: () => _logout(context),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout, color: Colors.red),
          Text(
            " Logout",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'My Profile',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    MyNavigator.goTo(
      context,
      const LoginView(),
      type: NavigatorType.pushAndRemoveUntil,
    );
  }

  void _showModernSnackBar(BuildContext context, String msg, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
