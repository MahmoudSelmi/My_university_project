import 'package:auth_slmi/feature/team/manager/TeamsCubit.dart';
import 'package:auth_slmi/feature/team/model/TeamModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({super.key});

  // نفس التدرج اللوني الموحد
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
    return BlocProvider(
      create: (context) => TeamsCubit()..getMyTeam(),
      child: BlocBuilder<TeamsCubit, TeamsState>(
        builder: (context, state) {
          var cubit = TeamsCubit.get(context);

          return Scaffold(
            backgroundColor: const Color(0xFFF0F2F5), // نفس خلفية الـ Home
            appBar: _buildModernAppBar(cubit.teamModel?.teamName),
            body: _buildUI(state, cubit),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar(String? teamName) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 80,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Collaboration 👋',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          ShaderMask(
            shaderCallback: (bounds) => meshGradient.createShader(bounds),
            child: Text(
              teamName ?? 'Team Details',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUI(TeamsState state, TeamsCubit cubit) {
    if (state is TeamsLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFA855F7)),
      );
    } else if (state is TeamsError) {
      return Center(
        child: Text(state.error, style: const TextStyle(color: Colors.red)),
      );
    } else {
      return _buildBody(cubit.teamModel);
    }
  }

  Widget _buildBody(TeamModel? model) {
    if (model == null) return const Center(child: Text("No Data Found"));

    return RefreshIndicator(
      onRefresh: () async => {}, // ضيف هنا دالة الـ refresh لو حابب
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // كارت كود الفريق بشكل Modern
            _buildModernHeaderCard(
              "Team Code",
              model.teamCode ?? "N/A",
              Icons.qr_code_rounded,
            ),

            const SizedBox(height: 25),
            _buildSectionTitle("Project Supervisor"),
            const SizedBox(height: 12),
            _buildDoctorCard(model),

            const SizedBox(height: 25),
            _buildSectionTitle("Team Members"),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: model.teamMembers?.length ?? 0,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder:
                  (context, index) =>
                      _buildMemberCard(model.teamMembers![index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F2937),
      ),
    );
  }

  Widget _buildModernHeaderCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: meshGradient.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6366F1), size: 30),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6366F1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(TeamModel model) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
              child: const Icon(Icons.person_rounded, color: Color(0xFF6366F1)),
            ),
            title: Text(
              model.doctorFullName ?? "N/A",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(model.doctorEmail ?? ""),
          ),
          const Divider(height: 20),
          Row(
            children: [
              const Icon(
                Icons.alternate_email_rounded,
                size: 16,
                color: Color(0xFFEC4899),
              ),
              const SizedBox(width: 8),
              Text(
                model.doctorPhone ?? "No Phone",
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(TeamMember member) {
    bool isLeader = member.memberIsLeader ?? false;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor:
              isLeader
                  ? const Color(0xFFA855F7).withOpacity(0.1)
                  : Colors.grey.shade100,
          child: Icon(
            isLeader ? Icons.star_rounded : Icons.person_outline_rounded,
            color: isLeader ? const Color(0xFFA855F7) : Colors.grey,
          ),
        ),
        title: Text(
          member.memberFullName ?? "Member",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          member.memberRole ?? "Developer",
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        ),
        trailing:
            isLeader
                ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: meshGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Leader",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                : null,
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF6366F1).withOpacity(0.05),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}
