import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorProjectDetailsView extends StatelessWidget {
  final Map<String, dynamic> project;
  const DoctorProjectDetailsView({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> members = project['members'] ?? [];
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          project['title'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.picture_as_pdf_rounded,
              color: Colors.redAccent,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tile(
              "قائد الفريق",
              project['leader'],
              Icons.person_pin_rounded,
              const Color(0xFF10B981),
            ),
            SizedBox(height: 15.h),
            _tile(
              "الوصف",
              project['desc'],
              Icons.description_rounded,
              Colors.orangeAccent,
            ),
            SizedBox(height: 30.h),
            Text(
              "أعضاء الفريق (${members.length})",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: members.length,
                separatorBuilder:
                    (context, index) => Divider(
                      color: Colors.white.withValues(alpha: 0.05),
                      height: 1,
                    ),
                itemBuilder:
                    (context, index) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent.withValues(
                          alpha: 0.1,
                        ),
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                      title: Text(
                        members[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(String l, String v, IconData i, Color c) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(20.r),
    decoration: BoxDecoration(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(i, color: c, size: 18),
            SizedBox(width: 8.w),
            Text(l, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          v,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}
