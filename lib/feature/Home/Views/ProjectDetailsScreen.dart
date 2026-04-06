import 'package:auth_slmi/core/Models/project_model.dart';
import 'package:auth_slmi/feature/Home/Views/EditProjectState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final ProjectModel project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  // الـ Controllers لمسك الداتا القابلة للتعديل
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>(); // لعمل Validate على الـ Form

  @override
  void initState() {
    super.initState();
    // نهيئ الـ Controllers بالداتا الحالية للمشروع
    titleController.text = widget.project.projectTitle ?? '';
    descriptionController.text = widget.project.projectDescription ?? '';
    yearController.text = widget.project.projectYear ?? '';
    typeController.text = widget.project.projectType ?? '';
    statusController.text = widget.project.projectStatus ?? '';
  }

  @override
  void dispose() {
    // مهم جداً نقفل الـ Controllers عشان Memory Leaks
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
    colors: [
      Color(0xFF6366F1), // Indigo
      Color(0xFFA855F7), // Purple
      Color(0xFFEC4899), // Pink
    ],
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProjectCubit(),
      child: BlocListener<EditProjectCubit, EditProjectState>(
        listener: (context, state) {
          if (state is EditProjectSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Project Updated Successfully!"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context); // نرجع للصفحة اللي قبلها بعد النجاح
          } else if (state is EditProjectError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<EditProjectCubit, EditProjectState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: const Color(0xFFF0F2F5),
              body: Form(
                key: formKey, // نربط الـ Form بالـ Key
                child: CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(context),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // حقول الإدخال القابلة للتعديل
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
                              maxLines: 5,
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

                            // أجزاء غير قابلة للتعديل (Supervisor)
                            _buildSectionTitle("Supervisor"),
                            const SizedBox(height: 12),
                            _buildSupervisorCard(),
                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ),
                  ],
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

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF6366F1),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.close_rounded,
          color: Colors.white,
        ), // علامة X بدلاً من السهم
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(gradient: meshGradient),
        ),
        title: const Text(
          "Edit Project", // تغيير العنوان
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  // ويدجت موحدة لإنشاء حقول إدخال قابلة للتعديل
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
        _buildSectionTitle(label),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
            ],
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: isNumbers ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF6366F1).withOpacity(0.7),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(18),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF374151),
      ),
    );
  }

  Widget _buildSupervisorCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
            backgroundImage:
                widget.project.doctorImage != null
                    ? NetworkImage(widget.project.doctorImage!)
                    : null,
            child:
                widget.project.doctorImage == null
                    ? const Icon(Icons.person, color: Color(0xFF6366F1))
                    : null,
          ),
          const SizedBox(width: 15),
          Text(
            widget.project.doctorFullName ?? 'Doctor Name',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, EditProjectState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // زرار حفظ التعديلات
          Expanded(
            flex: 2,
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                gradient: meshGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 15,
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
                          // نتحقق إن الداتا سليمة قبل ما نبعت للـ API
                          if (formKey.currentState!.validate()) {
                            // ننادي على الـ Cubit عشان يبعت التعديلات
                            BlocProvider.of<EditProjectCubit>(
                              context,
                            ).updateProject(
                              projectId:
                                  widget.project.projectId!, // مهم جداً الـ ID
                              title: titleController.text,
                              description: descriptionController.text,
                              year: yearController.text,
                              type: typeController.text,
                              status: statusController.text,
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.save_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Save Changes",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
          // زرار الحذف (كما هو)
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red.shade100),
            ),
            child: IconButton(
              onPressed: () => _showDeleteDialog(context),
              icon: Icon(
                Icons.delete_sweep_rounded,
                color: Colors.red.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    // ... نفس كود الـ Dialog اللي عملناه سابقاً ...
  }
}
