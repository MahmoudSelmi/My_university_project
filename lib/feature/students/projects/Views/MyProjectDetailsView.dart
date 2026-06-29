import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UploadProjectScreen extends StatefulWidget {
  const UploadProjectScreen({super.key});

  @override
  State<UploadProjectScreen> createState() => _UploadProjectScreenState();
}

class _UploadProjectScreenState extends State<UploadProjectScreen> {
  final titleController = TextEditingController();
  File? selectedFile;
  String? fileName;
  bool isUploading = false; // لمتابعة حالة الرفع

  final LinearGradient meshGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  // ميثود الرفع الفعلي على هوست افتراضي (file.io)
  Future<void> _handleUpload() async {
    if (selectedFile == null) return;

    setState(() => isUploading = true);

    try {
      // بنستخدم هوست file.io للتجربة الفعلية
      var request = http.MultipartRequest('POST', Uri.parse('https://file.io'));

      // إضافة الملف للطلب
      request.files.add(
        await http.MultipartFile.fromPath('file', selectedFile!.path),
      );

      // إرسال الطلب
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        String fileLink = responseData['link']; // الرابط اللي اترفع عليه الملف

        _showSnackBar("تم رفع الملف بنجاح! ✅", Colors.green);
        print("File Uploaded to: $fileLink");

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.pop(context);
        });
      } else {
        _showSnackBar("فشل الرفع، حاول مرة أخرى ❌", Colors.red);
      }
    } catch (e) {
      _showSnackBar("حدث خطأ في الشبكة ⚠️", Colors.orange);
    } finally {
      if (mounted) setState(() => isUploading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text("Upload Assets"),
              background: Container(
                decoration: BoxDecoration(gradient: meshGradient),
                child: Icon(
                  Icons.cloud_upload,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Document Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: "File Title",
                            prefixIcon: const Icon(Icons.title),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        InkWell(
                          onTap: isUploading ? null : _pickFile,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF6366F1,
                              ).withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(
                                  0xFF6366F1,
                                ).withValues(alpha: 0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  selectedFile == null
                                      ? Icons.attach_file
                                      : Icons.check_circle,
                                  size: 40,
                                  color:
                                      selectedFile == null
                                          ? const Color(0xFFA855F7)
                                          : Colors.green,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  selectedFile == null
                                      ? "Tap to Select Document"
                                      : fileName!,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildUploadButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    bool canUpload = selectedFile != null && !isUploading;
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: canUpload ? meshGradient : null,
        color: !canUpload ? Colors.grey.withValues(alpha: 0.3) : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: canUpload ? _handleUpload : null,
        child:
            isUploading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                  "CONFIRM & UPLOAD",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        fileName = result.files.single.name;
      });
    }
  }
}
