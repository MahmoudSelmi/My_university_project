import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_slmi/feature/projects/Manager/MyProjectCubit.dart';
import 'package:auth_slmi/feature/projects/Manager/MyProjectState.dart';
import 'package:auth_slmi/core/Models/project_model.dart';

class MyProjectScreen extends StatelessWidget {
  const MyProjectScreen({super.key});

  final LinearGradient meshGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyProjectCubit()..getMyProject(),
      child: BlocConsumer<MyProjectCubit, MyProjectState>(
        listener: (context, state) {
          if (state is MyProjectActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تمت العملية بنجاح!"),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          var cubit = MyProjectCubit.get(context);
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              centerTitle: true,
              title: ShaderMask(
                shaderCallback: (bounds) => meshGradient.createShader(bounds),
                child: const Text(
                  'تفاصيل مشروعي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            body: _buildUI(state, cubit),
          );
        },
      ),
    );
  }

  Widget _buildUI(MyProjectState state, MyProjectCubit cubit) {
    if (state is MyProjectLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFA855F7)),
      );
    } else if (state is MyProjectError) {
      return _buildErrorState(state.message, cubit);
    } else {
      return _buildContent(cubit.myProject, cubit);
    }
  }

  Widget _buildContent(ProjectModel? project, MyProjectCubit cubit) {
    if (project == null) return const Center(child: Text("لا توجد بيانات"));

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionCard(
            title: "معلومات المشروع",
            icon: Icons.assignment_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.projectTitle ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  project.projectDescription ?? '',
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
              ],
            ),
          ),
          _buildSectionCard(
            title: "الإشراف والجامعة",
            icon: Icons.school_rounded,
            child: Column(
              children: [
                _buildInfoRow(
                  Icons.person,
                  "المشرف:",
                  "د. ${project.doctorFullName ?? 'غير محدد'}",
                ),
                // _buildInfoRow(Icons.account_balance, "الجامعة:", project.universityName ?? 'غير محدد'),
              ],
            ),
          ),
          // زر الحذف كمثال للأكشن
          ElevatedButton.icon(
            onPressed: () => cubit.deleteProjectImage(),
            icon: const Icon(Icons.delete_forever),
            label: const Text("حذف صورة المشروع"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFA855F7), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, MyProjectCubit cubit) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 70, color: Colors.redAccent),
          Text(message),
          TextButton(
            onPressed: () => cubit.getMyProject(),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
