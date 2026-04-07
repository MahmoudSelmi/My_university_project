import 'package:flutter/material.dart';
import 'package:auth_slmi/feature/previous_projects_screen/Models/previous_project_model.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final ProjectItem project;

  const ProjectDetailsScreen({super.key, required this.project});

  // وضع الألوان في متغيرات ثابتة أو const يحسن الأداء
  static const Color _primaryColor = Color(0xFF6366F1);
  static const Color _bgColor = Color(0xFFF0F2F5);

  // استخدام الـ static const للـ Gradients بيمنع إعادة إنشائها في الـ Memory
  static const LinearGradient _meshGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_primaryColor, Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      // AppBar بسيط وخفيف
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0, // يمنع تغير اللون عند السكرول لتحسين الأداء
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Project Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // استخدام BouncingScrollPhysics يمنع الـ Glow effect اللي بياخد موارد على الأندرويد
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderCard(project: project),
            const SizedBox(height: 30),
            const _SectionTitle(title: "Description"),
            _ContentCard(
              text: project.projectDescription ?? "No description provided.",
            ),
            const SizedBox(height: 25),
            const _SectionTitle(title: "Supervisor"),
            _SupervisorTile(name: project.doctorFullName ?? "N/A"),
          ],
        ),
      ),
    );
  }
}

// فصل الـ Widgets في كلاسات منفصلة const بيخلي Flutter يعمل "Repaint Boundary"
// ويمنع إعادة بناء الـ Widgets اللي مغيرتش داتا.

class _HeaderCard extends StatelessWidget {
  final ProjectItem project;
  const _HeaderCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: ProjectDetailsScreen._meshGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: ProjectDetailsScreen._primaryColor.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.projectTitle?.toUpperCase() ?? "PROJECT",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Year: ${project.projectYear ?? '2025'}",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  final String text;
  const _ContentCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // تقليل الـ BoxShadow أو إلغاؤه في الـ Lists بيحسن الـ FPS
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 5),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 15,
          height: 1.5, // تقليل الـ Height شوية بيخلي الريندر أسرع
        ),
      ),
    );
  }
}

class _SupervisorTile extends StatelessWidget {
  final String name;
  const _SupervisorTile({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: ProjectDetailsScreen._primaryColor,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text("Project Supervisor"),
      ),
    );
  }
}
