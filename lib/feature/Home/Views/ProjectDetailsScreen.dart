import 'package:auth_slmi/core/Models/project_model.dart';
import 'package:auth_slmi/feature/Home/Views/EditProjectState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final ProjectModel project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.project.projectTitle ?? '';
    descriptionController.text = widget.project.projectDescription ?? '';
    yearController.text = widget.project.projectYear ?? '';
    typeController.text = widget.project.projectType ?? '';
    statusController.text = widget.project.projectStatus ?? '';
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    yearController.dispose();
    typeController.dispose();
    statusController.dispose();
    super.dispose();
  }

  final LinearGradient meshGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProjectCubit(),
      child: BlocListener<EditProjectCubit, EditProjectState>(
        listener: (context, state) {
          if (state is EditProjectSuccess) {
            _showModernSnackBar(context, "Project Updated Successfully!", true);
            Navigator.pop(context);
          } else if (state is EditProjectError) {
            // هنا بنعرض رسالة مختصرة عشان نمنع الـ Overflow اللي ظهر في الصورة
            _showModernSnackBar(
              context,
              "Update Failed: Please check your data or connection",
              false,
            );
          }
        },
        child: BlocBuilder<EditProjectCubit, EditProjectState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: const Color(0xFFF0F2F5),
              body: Form(
                key: formKey,
                child: AnimationLimiter(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      _buildSliverAppBar(context),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: AnimationConfiguration.toStaggeredList(
                              duration: const Duration(milliseconds: 500),
                              childAnimationBuilder:
                                  (widget) => SlideAnimation(
                                    horizontalOffset: 50.0,
                                    child: FadeInAnimation(child: widget),
                                  ),
                              children: [
                                _buildEditableField(
                                  "Project Title",
                                  titleController,
                                  Icons.title_rounded,
                                ),
                                const SizedBox(height: 20),
                                _buildEditableField(
                                  "Description",
                                  descriptionController,
                                  Icons.description_rounded,
                                  maxLines: 4,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildEditableField(
                                        "Year",
                                        yearController,
                                        Icons.calendar_today_rounded,
                                        isNumbers: true,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: _buildEditableField(
                                        "Type",
                                        typeController,
                                        Icons.merge_type_rounded,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                _buildEditableField(
                                  "Status",
                                  statusController,
                                  Icons.loop_rounded,
                                ),
                                const SizedBox(height: 30),
                                _buildSectionTitle("Supervisor"),
                                const SizedBox(height: 12),
                                _buildSupervisorCard(),
                                const SizedBox(height: 140),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: _buildActionButtons(context, state),
            );
          },
        ),
      ),
    );
  }

  // الـ SnackBar المانعة للـ Overflow
  void _showModernSnackBar(BuildContext context, String msg, bool isSuccess) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSuccess
                  ? Icons.check_circle_rounded
                  : Icons.error_outline_rounded,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 12),
            Flexible(
              // السطر ده هو اللي بيحل مشكلة الـ Overflow
              child: Text(
                msg,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor:
            isSuccess ? Colors.green.shade600 : Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: const Color(0xFF6366F1),
      leading: IconButton(
        icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          "Edit Project",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(gradient: meshGradient),
        ),
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
    bool isNumbers = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: isNumbers ? TextInputType.number : TextInputType.text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF6366F1).withOpacity(0.6),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
            ),
            validator: (value) => value!.isEmpty ? 'Field required' : null,
          ),
        ),
      ],
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

  Widget _buildSupervisorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
            backgroundImage:
                widget.project.doctorImage != null
                    ? NetworkImage(widget.project.doctorImage!)
                    : null,
            child:
                widget.project.doctorImage == null
                    ? const Icon(
                      Icons.person,
                      color: Color(0xFF6366F1),
                      size: 30,
                    )
                    : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Supervisor",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  widget.project.doctorFullName ?? 'Doctor Name',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.verified_rounded, color: Colors.blue, size: 20),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, EditProjectState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: meshGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEC4899).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child:
                  state is EditProjectLoading
                      ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : ElevatedButton.icon(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<EditProjectCubit>().updateProject(
                              projectId: widget.project.projectId!,
                              title: titleController.text,
                              description: descriptionController.text,
                              year: yearController.text,
                              type: typeController.text,
                              status: statusController.text,
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Apply Changes",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                      ),
            ),
          ),
          const SizedBox(width: 15),
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red.shade100),
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.delete_outline_rounded,
                color: Colors.red.shade400,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
