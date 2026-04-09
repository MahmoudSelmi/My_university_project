import 'package:flutter/material.dart';
import 'package:auth_slmi/feature/students/previous_projects_screen/Models/previous_project_model.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final ProjectItem project;

  const ProjectDetailsScreen({super.key, required this.project});

  static const Color _primaryColor = Color(0xFF6366F1);

  static const LinearGradient _meshGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_primaryColor, Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  @override
  Widget build(BuildContext context) {
    // شيلنا الـ Theme ويدجت اللي كانت بتجبر الشاشة على اللايت مود
    return Scaffold(
      // الخلفية بتسمع من الثيم (هتبقى غامقة لو فعلت الدارك مود)
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Project Details",
          style: TextStyle(
            // لون النص بيتغير تلقائياً حسب المود
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
              color: Colors.white, // أبيض دائماً فوق الجريدينت
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
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          // العنوان يتبع الثيم
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
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
        // لون الكارت يتغير (أبيض في اللايت، كحلي/أسود في الدارك)
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 5),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          // النص يتبع الثيم ويكون مريح للعين
          color: Theme.of(context).textTheme.bodyMedium?.color,
          fontSize: 15,
          height: 1.5,
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
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: ProjectDetailsScreen._primaryColor,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            // اسم الدكتور يتبع لون النصوص الرئيسي للثيم لضمان الوضوح التام
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: Text(
          "Project Supervisor",
          style: TextStyle(
            color: Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withOpacity(0.1),
          ),
        ),
      ),
    );
  }
}
