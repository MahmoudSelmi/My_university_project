import 'package:auth_slmi/core/Models/project_model.dart';
import 'package:auth_slmi/feature/Home/Views/ProjectDetailsScreen.dart';
import 'package:auth_slmi/feature/previous_projects_screen/Manager/all_projects_cubit.dart';
import 'package:auth_slmi/feature/previous_projects_screen/Models/previous_project_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreviousProjectsScreen extends StatelessWidget {
  const PreviousProjectsScreen({super.key});

  final LinearGradient meshGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllProjectsCubit()..getAllProjects(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F2F5),
        appBar: _buildAppBar(),
        body: BlocBuilder<AllProjectsCubit, AllProjectsState>(
          builder: (context, state) {
            if (state is AllProjectsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFA855F7)),
              );
            } else if (state is AllProjectsSuccess) {
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                itemCount: state.projects.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) return _buildStatsCard(state.stats);
                  return _buildProjectCard(context, state.projects[index - 1]);
                },
              );
            } else if (state is AllProjectsError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: ShaderMask(
        shaderCallback: (bounds) => meshGradient.createShader(bounds),
        child: const Text(
          'Previous Projects',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(Stats stats) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(
            "Total",
            stats.totalProjects.toString(),
            const Color(0xFF6366F1),
          ),
          _statItem(
            "Completed",
            stats.completedProjects.toString(),
            const Color(0xFF10B981),
          ),
          _statItem(
            "Year",
            stats.currentYearProjects.toString(),
            const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildProjectCard(BuildContext context, ProjectItem project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.08),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.projectTitle ?? 'No Title',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            project.projectDescription ?? '',
            maxLines: 2,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                project.doctorFullName ?? 'Supervisor',
                style: const TextStyle(fontSize: 13),
              ),
              const Spacer(),
              _buildViewButton(context, project),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewButton(BuildContext context, ProjectItem item) {
    return Container(
      decoration: BoxDecoration(
        gradient: meshGradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEC4899).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // الـ Push اللي هيشتغل معاك فوراً
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ProjectDetailsScreen(
                    project: ProjectModel(
                      projectId: item.projectId,
                      projectTitle: item.projectTitle,
                      projectDescription: item.projectDescription,
                      doctorFullName: item.doctorFullName,
                    ),
                  ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'View',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
