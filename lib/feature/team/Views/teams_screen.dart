import 'package:auth_slmi/feature/team/manager/TeamsCubit.dart';
import 'package:auth_slmi/feature/team/model/TeamModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({super.key});

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
            backgroundColor: const Color(0xFFF0F2F5),
            appBar: _buildModernAppBar(cubit.teamModel?.teamName),
            body: Stack(
              children: [_buildBackgroundDecoration(), _buildUI(state, cubit)],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackgroundDecoration() {
    return Positioned(
      top: -50,
      left: -50,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF6366F1).withOpacity(0.03),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar(String? teamName) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 90,
      title: AnimationConfiguration.synchronized(
        duration: const Duration(milliseconds: 1000),
        child: SlideAnimation(
          verticalOffset: -20,
          child: FadeInAnimation(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Collaboration 👋',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => meshGradient.createShader(bounds),
                  child: Text(
                    teamName ?? 'Team Details',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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

    return AnimationLimiter(
      child: RefreshIndicator(
        onRefresh: () async => {},
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 600),
              childAnimationBuilder:
                  (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
              children: [
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
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 12),
                  itemBuilder:
                      (context, index) => AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: FlipAnimation(
                          child: _buildMemberCard(model.teamMembers![index]),
                        ),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            gradient: meshGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildModernHeaderCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.08),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: const Color(0xFF6366F1), size: 28),
          ),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
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
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
              child: const Icon(
                Icons.person_rounded,
                color: Color(0xFF6366F1),
                size: 28,
              ),
            ),
            title: Text(
              model.doctorFullName ?? "N/A",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              model.doctorEmail ?? "",
              style: const TextStyle(fontSize: 13),
            ),
            trailing: const Icon(
              Icons.verified_user_rounded,
              color: Colors.blue,
              size: 20,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(height: 1, thickness: 0.5),
          ),
          Row(
            children: [
              Icon(
                Icons.phone_android_rounded,
                size: 16,
                color: Colors.grey.shade400,
              ),
              const SizedBox(width: 8),
              Text(
                model.doctorPhone ?? "No Phone",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:
                isLeader
                    ? const Color(0xFFA855F7).withOpacity(0.1)
                    : Colors.grey.shade100,
            child: Icon(
              isLeader ? Icons.star_rounded : Icons.person_outline_rounded,
              color: isLeader ? const Color(0xFFA855F7) : Colors.grey,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.memberFullName ?? "Member",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  member.memberRole ?? "Developer",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
          if (isLeader)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              child: const Text(
                "Leader",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.96),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF6366F1).withOpacity(0.06),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}
