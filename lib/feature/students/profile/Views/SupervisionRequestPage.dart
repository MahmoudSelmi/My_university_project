import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:file_picker/file_picker.dart';

class SupervisionRequestPage extends StatefulWidget {
  const SupervisionRequestPage({super.key});

  @override
  State<SupervisionRequestPage> createState() => _SupervisionRequestPageState();
}

class _SupervisionRequestPageState extends State<SupervisionRequestPage> {
  final String _token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5ZmQxMDU2MjhhYTg0M2YwOGIwNDY1NiIsInJvbGUiOiJzdHVkZW50IiwiaWF0IjoxNzc4MzI2Njg3LCJleHAiOjE3ODY5NjY2ODd9.tCHZ9Z67KYHuSYPvDMlnTKRiw8fvAvXyUCZuVmUKYD0";

  // داتا الاستاتيك (Fallback)
  final List<Map<String, String>> staticUniversities = [
    {"_id": "st_1", "name": "معاهد العبور"},
    {"_id": "st_2", "name": "جامعة القاهرة"},
    {"_id": "st_3", "name": "جامعة عين شمس"},
    {"_id": "st_4", "name": "جامعة حلوان"},
  ];

  final List<Map<String, String>> staticDepartments = [
    {"_id": "sd_1", "name": "نظم معلومات الأعمال (BIS)"},
    {"_id": "sd_2", "name": "هندسة البرمجيات"},
    {"_id": "sd_3", "name": "علوم الحاسب"},
    {"_id": "sd_4", "name": "محاسبة"},
  ];

  final List<Map<String, String>> staticDoctors = [
    {"_id": "d_1", "fullName": "دكتور مجدي"},
    {"_id": "d_2", "fullName": "دكتور زياد"},
    {"_id": "d_3", "fullName": "دكتور محمد"},
  ];

  List<dynamic> doctors = [];
  List<dynamic> universities = [];
  List<dynamic> departments = [];

  String? selectedDoctor;
  String? selectedUniversity;
  String? selectedDepartment;
  File? selectedFile;
  String? fileName;
  bool isLoadingData = true;
  bool isUploading = false;

  final projectName = TextEditingController();
  final description = TextEditingController();
  List<Map<String, TextEditingController>> teamMembers = [
    {"name": TextEditingController(), "code": TextEditingController()},
  ];

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  // --- جلب البيانات مع نظام الـ Fallback الذكي ---
  Future<void> _fetchAllData() async {
    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = _token;
      dio.options.connectTimeout = const Duration(seconds: 5);

      final results = await Future.wait([
        dio
            .get(
              'http://54.92.204.187:3000/api/v1/admin/dashboard/all-doctors-detailed',
            )
            .catchError((e) => null),
        dio
            .get(
              'http://54.226.14.225:3000/api/v1/admin/dashboard/all-universities',
            )
            .catchError((e) => null),
        dio
            .get(
              'http://54.226.14.225:3000/api/v1/admin/dashboard/all-department',
            )
            .catchError((e) => null),
      ]);

      setState(() {
        // دمج داتا الـ API مع داتا الـ Static
        doctors =
            (results[0].data['data'] != null &&
                    results[0].data['data'].isNotEmpty)
                ? results[0].data['data']
                : staticDoctors;
        universities =
            (results[1].data['data'] != null &&
                    results[1].data['data'].isNotEmpty)
                ? results[1].data['data']
                : staticUniversities;
        departments =
            (results[2].data['data'] != null &&
                    results[2].data['data'].isNotEmpty)
                ? results[2].data['data']
                : staticDepartments;

        // التأكد من وجود "معاهد العبور" دائماً
        if (!universities.any((u) => u['name'].toString().contains("العبور"))) {
          universities.insert(0, {"_id": "st_0", "name": "معاهد العبور"});
        }

        isLoadingData = false;
      });
    } catch (e) {
      _loadStaticDataOnly();
    }
  }

  void _loadStaticDataOnly() {
    setState(() {
      doctors = staticDoctors;
      universities = staticUniversities;
      departments = staticDepartments;
      isLoadingData = false;
    });
  }

  Future<void> _submitRequest() async {
    if (selectedFile == null || projectName.text.isEmpty) {
      _showSnack("يا هندسة كمل بياناتك وارفع الملف 📁", false);
      return;
    }

    setState(() => isUploading = true);
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          selectedFile!.path,
          filename: fileName,
        ),
        "title": projectName.text,
        "description": description.text,
        "doctorId": selectedDoctor,
        "universityId": selectedUniversity,
        "departmentId": selectedDepartment,
      });

      var response = await Dio().post(
        'http://54.92.204.187:3000/api/v1/projects/upload-file',
        data: formData,
        options: Options(headers: {'Authorization': _token}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _showSuccessDialog();
      }
    } catch (e) {
      _showSnack("فشل الرفع.. جرب تاني يا ريس", false);
    } finally {
      setState(() => isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030712),
      body:
          isLoadingData
              ? _buildDynamicLoader()
              : Stack(
                children: [
                  _buildBackgroundGlow(),
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      _buildSliverAppBar(),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            AnimationLimiter(
                              child: Column(
                                children:
                                    AnimationConfiguration.toStaggeredList(
                                      duration: const Duration(
                                        milliseconds: 600,
                                      ),
                                      childAnimationBuilder:
                                          (w) => SlideAnimation(
                                            verticalOffset: 30,
                                            child: FadeInAnimation(child: w),
                                          ),
                                      children: [
                                        _buildHeader("الفكرة والوصف"),
                                        _buildGlassField(
                                          projectName,
                                          "اسم المشروع",
                                          Icons.rocket_launch,
                                        ),
                                        _buildGlassField(
                                          description,
                                          "اكتب نبذة مختصرة عن فكرتك",
                                          Icons.notes,
                                          maxLines: 3,
                                        ),

                                        const SizedBox(height: 25),
                                        _buildHeader("بيانات الفريق"),
                                        ...teamMembers.asMap().entries.map(
                                          (e) => _buildTeamCard(e.key),
                                        ),
                                        _buildAddMemberBtn(),

                                        const SizedBox(height: 25),
                                        _buildHeader("الملفات المرجعية"),
                                        _buildUploadBox(),

                                        const SizedBox(height: 25),
                                        _buildHeader("البيانات الأكاديمية"),
                                        _buildDynamicDrop(
                                          "الجامعة",
                                          universities,
                                          selectedUniversity,
                                          (v) => setState(
                                            () => selectedUniversity = v,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        _buildDynamicDrop(
                                          "التخصص / القسم",
                                          departments,
                                          selectedDepartment,
                                          (v) => setState(
                                            () => selectedDepartment = v,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        _buildDynamicDrop(
                                          "المشرف المقترح",
                                          doctors,
                                          selectedDoctor,
                                          (v) => setState(
                                            () => selectedDoctor = v,
                                          ),
                                          isDoc: true,
                                        ),

                                        const SizedBox(height: 50),
                                        _buildSubmitBtn(),
                                        const SizedBox(height: 100),
                                      ],
                                    ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }

  // --- UI Components ---
  Widget _buildDynamicDrop(
    String hint,
    List<dynamic> data,
    String? val,
    Function(String?) onChanged, {
    bool isDoc = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: val,
          dropdownColor: const Color(0xFF0F172A),
          hint: Text(
            hint,
            style: const TextStyle(color: Colors.white38, fontSize: 13),
          ),
          isExpanded: true,
          items:
              data
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item['_id'],
                      child: Text(
                        isDoc ? item['fullName'] : item['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTeamCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildGlassField(
              teamMembers[index]['name']!,
              "اسم العضو",
              Icons.person_outline,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildGlassField(
              teamMembers[index]['code']!,
              "الكود",
              Icons.fingerprint,
            ),
          ),
          if (index > 0)
            IconButton(
              onPressed: () => setState(() => teamMembers.removeAt(index)),
              icon: const Icon(
                Icons.remove_circle,
                color: Colors.redAccent,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGlassField(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
          prefixIcon: Icon(icon, color: const Color(0xFF6366F1), size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget _buildUploadBox() {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? r = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'zip'],
        );
        if (r != null) {
          setState(() {
            selectedFile = File(r.files.single.path!);
            fileName = r.files.single.name;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color(0xFF6366F1).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                selectedFile != null ? const Color(0xFF6366F1) : Colors.white10,
          ),
        ),
        child: Column(
          children: [
            Icon(
              selectedFile != null
                  ? Icons.check_circle
                  : Icons.cloud_upload_rounded,
              color: const Color(0xFF6366F1),
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              fileName ?? "ارفع ملف المشروع المرجعي",
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitBtn() => InkWell(
    onTap: isUploading ? null : _submitRequest,
    child: Container(
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.4),
            blurRadius: 20,
          ),
        ],
      ),
      child:
          isUploading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                "إرسال طلب الإشراف",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
    ),
  );

  Widget _buildDynamicLoader() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: Color(0xFF6366F1)),
        SizedBox(height: 20),
        Text(
          "جاري سحب البيانات الأكاديمية...",
          style: TextStyle(color: Colors.white54),
        ),
      ],
    ),
  );
  Widget _buildHeader(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 15, top: 10),
    child: Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          t,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
  Widget _buildAddMemberBtn() => TextButton.icon(
    onPressed:
        () => setState(
          () => teamMembers.add({
            "name": TextEditingController(),
            "code": TextEditingController(),
          }),
        ),
    icon: const Icon(Icons.add_box_outlined, color: Color(0xFF6366F1)),
    label: const Text(
      "إضافة عضو للفريق",
      style: TextStyle(color: Color(0xFF6366F1)),
    ),
  );
  Widget _buildBackgroundGlow() => Positioned(
    top: -100,
    left: -100,
    child: Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withValues(alpha: 0.15),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.2),
            blurRadius: 100,
            spreadRadius: 50,
          ),
        ],
      ),
    ),
  );
  Widget _buildSliverAppBar() => const SliverAppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text(
      "REQUEST SUPERVISION",
      style: TextStyle(
        letterSpacing: 2,
        fontSize: 16,
        fontWeight: FontWeight.w900,
      ),
    ),
    centerTitle: true,
    pinned: true,
  );
  void _showSnack(String m, bool s) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(m),
          backgroundColor: s ? Colors.green : Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
  void _showSuccessDialog() => showDialog(
    context: context,
    builder:
        (c) => AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          title: const Text("تم بنجاح!", style: TextStyle(color: Colors.white)),
          content: const Text("مشروعك الآن تحت المراجعة من قبل القسم."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("حسناً"),
            ),
          ],
        ),
  );
}
