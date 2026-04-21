import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:file_picker/file_picker.dart';

class SupervisionRequestPage extends StatefulWidget {
  const SupervisionRequestPage({super.key});

  @override
  State<SupervisionRequestPage> createState() => _SupervisionRequestPageState();
}

class _SupervisionRequestPageState extends State<SupervisionRequestPage> {
  final List<Map<String, String>> doctors = [
    {"id": "1", "name": "دكتور مجدي"},
    {"id": "2", "name": "دكتور زياد"},
    {"id": "3", "name": "دكتور محمد"},
  ];

  final List<Map<String, String>> departments = [
    {"id": "101", "name": "BIS"},
    {"id": "102", "name": "برمجيات"},
  ];

  String? selectedDoctor;
  String? selectedDepartment;
  File? selectedFile;
  String? fileName;
  bool isUploading = false;

  final projectName = TextEditingController();
  final description = TextEditingController();
  final year = TextEditingController(text: "2026");

  final LinearGradient meshGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      if (file.lengthSync() > 20 * 1024 * 1024) {
        _showMsg('حجم الملف كبير جداً! الحد الأقصى 20 ميجا', false);
      } else {
        setState(() {
          selectedFile = file;
          fileName = result.files.single.name;
        });
      }
    }
  }

  Future<void> submit() async {
    if (selectedDoctor == null ||
        selectedDepartment == null ||
        projectName.text.isEmpty ||
        selectedFile == null) {
      _showMsg('كمل بياناتك وارفع الـ PDF يا بطل', false);
      return;
    }

    setState(() => isUploading = true);
    String doctorName =
        doctors.firstWhere((doc) => doc['id'] == selectedDoctor)['name']!;

    try {
      // الرفع على هوست خارجي (file.io) للتجربة الفعلية
      var request = http.MultipartRequest('POST', Uri.parse('https://file.io'));
      request.files.add(
        await http.MultipartFile.fromPath('file', selectedFile!.path),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(
          "رابط الملف المرفوع: ${data['link']}",
        ); // الرابط هيظهر في الـ Console

        _showMsg('تم الرفع لـ $doctorName بنجاح! الرابط شغال ✅', true);
        Future.delayed(
          const Duration(seconds: 2),
          () => Navigator.pop(context),
        );
      } else {
        _showMsg('السيرفر الخارجي فيه مشكلة، حاول تاني', false);
      }
    } catch (e) {
      _showMsg('فشل الاتصال.. تأكد من الإنترنت', false);
    } finally {
      setState(() => isUploading = false);
    }
  }

  void _showMsg(String msg, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: success ? Colors.green.shade600 : Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "تقديم مشروع التخرج",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: AnimationLimiter(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 600),
            childAnimationBuilder:
                (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
            children: [
              _buildSectionTitle("بيانات المشروع"),
              const SizedBox(height: 15),
              _buildField(projectName, "اسم المشروع", Icons.edit_rounded),
              _buildField(
                description,
                "وصف المشروع",
                Icons.description_rounded,
                maxLines: 2,
              ),
              _buildField(year, "السنة", Icons.calendar_today_rounded),
              const SizedBox(height: 15),
              _buildUploadArea(),
              const SizedBox(height: 25),
              _buildSectionTitle("التنسيق الأكاديمي"),
              const SizedBox(height: 15),
              _buildDropdown(
                "اختر الدكتور",
                doctors,
                selectedDoctor,
                (val) => setState(() => selectedDoctor = val),
              ),
              const SizedBox(height: 12),
              _buildDropdown(
                "اختر القسم",
                departments,
                selectedDepartment,
                (val) => setState(() => selectedDepartment = val),
              ),
              const SizedBox(height: 40),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: pickPDF,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color:
                selectedFile != null
                    ? Colors.green
                    : const Color(0xFF6366F1).withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              selectedFile != null
                  ? Icons.check_circle_rounded
                  : Icons.picture_as_pdf_rounded,
              size: 45,
              color:
                  selectedFile != null ? Colors.green : const Color(0xFF6366F1),
            ),
            const SizedBox(height: 12),
            Text(
              selectedFile != null ? fileName! : "اضغط لرفع ملف الـ PDF",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "الحد الأقصى 20 ميجا بايت",
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    List<Map<String, String>> data,
    String? value,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          initialValue: value,
          hint: Text(hint),
          items:
              data
                  .map(
                    (item) => DropdownMenuItem(
                      value: item['id'],
                      child: Text(item['name']!),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(border: InputBorder.none),
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: meshGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: isUploading ? null : submit,
        borderRadius: BorderRadius.circular(20),
        child: Center(
          child:
              isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                    "إرسال طلب الإشراف",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        ),
      ),
    );
  }
}
