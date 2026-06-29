import 'package:auth_slmi/core/Models/project_model.dart';
import 'package:auth_slmi/feature/students/Home/Views/ProjectDetailsScreen.dart';
import 'package:auth_slmi/feature/students/previous_projects_screen/Manager/all_projects_cubit.dart';
import 'package:auth_slmi/feature/students/previous_projects_screen/Models/previous_project_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
        // استخدام خلفية الثيم
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(context),
        body: BlocBuilder<AllProjectsCubit, AllProjectsState>(
          builder: (context, state) {
            if (state is AllProjectsLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            } else if (state is AllProjectsSuccess) {
              return AnimationLimiter(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                  itemCount: state.projects.length + 1,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 600),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child:
                              index == 0
                                  ? _buildStatsCard(context, state.stats)
                                  : _buildProjectCard(
                                    context,
                                    state.projects[index - 1],
                                  ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is AllProjectsError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 70,
      title: ShaderMask(
        shaderCallback: (bounds) => meshGradient.createShader(bounds),
        child: const Text(
          'Previous Projects',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, Stats stats) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        // لون الكارت يتغير حسب الثيم
        color: Theme.of(context).cardColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(
            context,
            "Total",
            stats.totalProjects.toString(),
            const Color(0xFF6366F1),
            Icons.folder_copy_outlined,
          ),
          _statItem(
            context,
            "Done",
            stats.completedProjects.toString(),
            const Color(0xFF10B981),
            Icons.check_circle_outline,
          ),
          _statItem(
            context,
            "Year",
            stats.currentYearProjects.toString(),
            const Color(0xFFF59E0B),
            Icons.calendar_month_outlined,
          ),
        ],
      ),
    );
  }

  Widget _statItem(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: color.withValues(alpha: 0.7), size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color:
                Theme.of(
                  context,
                ).textTheme.bodyMedium?.color, // لون النص الفرعي من الثيم
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectCard(BuildContext context, ProjectItem project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // لون الكارت من الثيم
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "PAST PROJECT",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.history_toggle_off_rounded,
                size: 14,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            project.projectTitle ?? 'No Title',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color:
                  Theme.of(context).textTheme.bodyLarge?.color, // لون العنوان
            ),
          ),
          const SizedBox(height: 6),
          Text(
            project.projectDescription ?? '',
            maxLines: 2,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color, // لون الوصف
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withValues(alpha: 0.1),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 18,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                project.doctorFullName ?? 'Supervisor',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEC4899).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
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
                        id: '',
                        title: '',
                        description: '',
                        desc: '',
                        teamLeader: '',
                        status: '',
                        leaderName: '',
                        year: '',
                        members: [],
                      ),
                    ),
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            child: Text(
              'View',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
