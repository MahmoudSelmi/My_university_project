import 'package:auth_slmi/feature/students/projects/Manager/MyProjectCubit.dart';
import 'package:auth_slmi/feature/students/projects/Models/project_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


class MyProjectDetailsView extends StatelessWidget {
  const MyProjectDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyProjectCubit()..getMyProjectDetails(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<MyProjectCubit, MyProjectState>(
          builder: (context, state) {
            if (state is MyProjectLoading) return const Center(child: CircularProgressIndicator());
            if (state is MyProjectError) return Center(child: Text(state.err));
            if (state is MyProjectSuccess) return _buildBody(context, state.model);
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MyProjectModel model) {
    final meshGradient = const LinearGradient(
      colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
    );

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSliverAppBar(context, model.projectTitle ?? "", meshGradient),
        SliverToBoxAdapter(
          child: AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 500),
                childAnimationBuilder: (widget) => SlideAnimation(verticalOffset: 50, child: FadeInAnimation(child: widget)),
                children: [
                  _buildStatusCard(context, model),
                  _buildSectionTitle(context, "Description"),
                  _buildInfoCard(context, model.projectDescription ?? ""),
                  _buildSectionTitle(context, "Technologies"),
                  _buildTechChips(context, model.technologies ?? []),
                  _buildSectionTitle(context, "Supervisor"),
                  _buildSupervisorCard(context, model),
                  _buildSectionTitle(context, "Team Members"),
                  ...model.teamMembers!.map((m) => _buildMemberTile(context, m)).toList(),
                  _buildSectionTitle(context, "Documents"),
                  ...model.files!.map((f) => _buildFileTile(context, f)).toList(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, String title, Gradient gradient) {
    return SliverAppBar(
      expandedHeight: 150, pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        background: Container(decoration: BoxDecoration(gradient: gradient)),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, MyProjectModel model) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSmallStat(context, "Year", model.projectYear ?? ""),
          _buildSmallStat(context, "Type", model.projectType?.toUpperCase() ?? ""),
          _buildSmallStat(context, "Status", "In Progress", color: Colors.orange),
        ],
      ),
    );
  }

  Widget _buildTechChips(BuildContext context, List<String> techs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        children: techs.map((t) => Chip(
          label: Text(t, style: const TextStyle(fontSize: 12)),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        )).toList(),
      ),
    );
  }

  Widget _buildSupervisorCard(BuildContext context, MyProjectModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(backgroundColor: Colors.blue.withOpacity(0.1), child: const Icon(Icons.person, color: Colors.blue)),
        title: Text(model.doctorFullName ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(model.doctorEmail ?? ""),
        trailing: IconButton(icon: const Icon(Icons.phone, color: Colors.green), onPressed: () {}),
      ),
    );
  }

  Widget _buildMemberTile(BuildContext context, TeamMember member) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(child: Text(member.fullName![0])),
        title: Text(member.fullName ?? ""),
        subtitle: Text(member.role ?? ""),
        trailing: member.isLeader! ? const Icon(Icons.star, color: Colors.amber) : null,
      ),
    );
  }

  Widget _buildFileTile(BuildContext context, ProjectFile file) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
        title: Text(file.fileName ?? "", maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.download),
        onTap: () {},
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoCard(BuildContext context, String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).cardColor.withOpacity(0.5), borderRadius: BorderRadius.circular(15)),
      child: Text(text, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, height: 1.5)),
    );
  }

  Widget _buildSmallStat(BuildContext context, String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color ?? Theme.of(context).textTheme.bodyLarge?.color)),
      ],
    );
  }
}