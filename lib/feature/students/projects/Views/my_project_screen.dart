import 'package:auth_slmi/feature/students/projects/Views/UploadProjectScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../Manager/MyProjectCubit.dart';
import '../Models/project_model.dart';

class MyProjectDetailsView extends StatelessWidget {
  const MyProjectDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyProjectCubit()..getMyProjectDetails(),
      child: Scaffold(
        body: BlocBuilder<MyProjectCubit, MyProjectState>(
          builder: (context, state) {
            if (state is MyProjectLoading)
              return const Center(child: CircularProgressIndicator());
            if (state is MyProjectError) return Center(child: Text(state.err));
            if (state is MyProjectSuccess)
              return _buildBody(context, state.model);
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MyProjectModel model) {
    const meshGradient = LinearGradient(
      colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
    );

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 150,
          pinned: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.drive_folder_upload,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadProjectScreen(),
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
          ],
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              model.projectTitle ?? "Workspace",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            background: Container(
              decoration: const BoxDecoration(gradient: meshGradient),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 500),
                childAnimationBuilder:
                    (widget) => SlideAnimation(
                      verticalOffset: 50,
                      child: FadeInAnimation(child: widget),
                    ),
                children: [
                  _buildStatusCard(context, model),

                  _buildSectionTitle(context, "Description"),
                  _buildInfoCard(
                    context,
                    model.projectDescription ?? "No description available",
                  ),

                  if (model.technologies != null &&
                      model.technologies!.isNotEmpty) ...[
                    _buildSectionTitle(context, "Technologies"),
                    _buildTechChips(context, model.technologies!),
                  ],

                  _buildSectionTitle(context, "Supervisor"),
                  _buildSupervisorCard(context, model),

                  if (model.teamMembers != null &&
                      model.teamMembers!.isNotEmpty) ...[
                    _buildSectionTitle(context, "Team Members"),
                    ...model.teamMembers!
                        .map((m) => _buildMemberTile(context, m))
                        .toList(),
                  ],

                  _buildSectionTitle(context, "Project Documents"),
                  if (model.files != null && model.files!.isNotEmpty)
                    ...model.files!
                        .map((f) => _buildFileTile(context, f))
                        .toList()
                  else
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("No documents uploaded yet."),
                    ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- ميثودز الـ UI المساعدة (التي تجلب البيانات القديمة) ---

  Widget _buildStatusCard(BuildContext context, MyProjectModel model) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSmallStat(context, "Year", model.projectYear ?? ""),
          _buildSmallStat(
            context,
            "Type",
            model.projectType?.toUpperCase() ?? "",
          ),
          _buildSmallStat(
            context,
            "Status",
            model.projectStatus ?? "Active",
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14, height: 1.5)),
    );
  }

  Widget _buildTechChips(BuildContext context, List<String> techs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        children:
            techs
                .map(
                  (t) => Chip(
                    label: Text(t, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor.withOpacity(0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildSupervisorCard(BuildContext context, MyProjectModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(model.doctorFullName ?? "Supervisor"),
        subtitle: Text(model.doctorEmail ?? "No email"),
      ),
    );
  }

  Widget _buildMemberTile(BuildContext context, TeamMember member) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(child: Text(member.fullName?[0] ?? "?")),
        title: Text(member.fullName ?? "Member"),
        subtitle: Text(member.role ?? "Developer"),
        trailing:
            member.isLeader == true
                ? const Icon(Icons.star, color: Colors.amber)
                : null,
      ),
    );
  }

  Widget _buildFileTile(BuildContext context, ProjectFile file) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
          title: Text(file.fileName ?? "Document"),
          trailing: const Icon(Icons.download_for_offline, color: Colors.blue),
          onTap: () {
            MyProjectCubit.get(context).downloadProjectFile(
              url: file.filePath!,
              fileName: file.fileName!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 25, 16, 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSmallStat(
    BuildContext context,
    String label,
    String value, {
    Color? color,
  }) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
