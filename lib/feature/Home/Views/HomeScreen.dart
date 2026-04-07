import 'package:auth_slmi/core/Models/project_model.dart';
import 'package:auth_slmi/feature/Home/Views/ProjectDetailsScreen.dart';
import 'package:auth_slmi/feature/Home/manager/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    HomeCubit.get(context).getHomeProjects();
  }

  final LinearGradient meshGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1), // Indigo
      Color(0xFFA855F7), // Purple
      Color(0xFFEC4899), // Pink
    ],
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF0F2F5),
          appBar: _buildModernAppBar(),
          // استخدام Stack عشان نحط خلفية خفيفة للمحتوى
          body: Stack(
            children: [_buildBackgroundDecoration(), _buildBody(state)],
          ),
        );
      },
    );
  }

  // إضافة دوائر خفيفة في الخلفية لتعزيز شكل البراند
  Widget _buildBackgroundDecoration() {
    return Positioned(
      top: -100,
      right: -100,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: const Color(0xFF6366F1).withOpacity(0.03),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 90,
      title: AnimationConfiguration.synchronized(
        duration: const Duration(milliseconds: 1000),
        child: SlideAnimation(
          verticalOffset: -20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back 👋',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              ShaderMask(
                shaderCallback: (bounds) => meshGradient.createShader(bounds),
                child: const Text(
                  'Explore Projects',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [_buildNotificationIcon()],
    );
  }

  Widget _buildNotificationIcon() {
    return Container(
      margin: const EdgeInsets.only(right: 20, top: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF6366F1),
              size: 22,
            ),
            onPressed: () {},
          ),
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Color(0xFFEC4899), // براند بينك
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
              child: const Text(
                '2',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(HomeState state) {
    if (state is HomeLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFA855F7)),
      );
    } else if (state is HomeSuccess) {
      return AnimationLimiter(
        child: RefreshIndicator(
          onRefresh: () async => HomeCubit.get(context).getHomeProjects(),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
            itemCount: state.projects.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 600),
                child: SlideAnimation(
                  verticalOffset: 30.0,
                  child: FadeInAnimation(
                    child: _buildProjectCard(state.projects[index]),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else if (state is HomeError) {
      return Center(child: Text(state.message));
    }
    return const SizedBox();
  }

  Widget _buildProjectCard(ProjectModel project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.06),
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
                  color: const Color(0xFF6366F1).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  project.projectType?.toUpperCase() ?? 'WEB',
                  style: const TextStyle(
                    color: Color(0xFF6366F1),
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                project.projectYear ?? '',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            project.projectTitle ?? 'No Title',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            project.projectDescription ?? 'No Description',
            maxLines: 2,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
                backgroundImage:
                    project.doctorImage != null
                        ? NetworkImage(project.doctorImage!)
                        : null,
                child:
                    project.doctorImage == null
                        ? const Icon(
                          Icons.person,
                          size: 18,
                          color: Color(0xFF6366F1),
                        )
                        : null,
              ),
              const SizedBox(width: 8),
              Text(
                project.doctorFullName ?? 'Doctor',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              _buildModernButton(project),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernButton(ProjectModel project) {
    return Container(
      decoration: BoxDecoration(
        gradient: meshGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEC4899).withOpacity(0.2),
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
                builder: (context) => ProjectDetailsScreen(project: project),
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Text(
              'Details',
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
