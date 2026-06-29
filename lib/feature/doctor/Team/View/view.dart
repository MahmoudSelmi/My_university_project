// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class TeamsViewdoc extends StatefulWidget {
//   const TeamsViewdoc({super.key});

//   @override
//   State<TeamsViewdoc> createState() => _TeamsViewState();
// }

// class _TeamsViewState extends State<TeamsViewdoc> {
//   // داتا الفرق - تقدر تعدلها أو تضيف فيها براحتك
//   List<Map<String, dynamic>> teams = [
//     {
//       "title": "AI Medical Assistant",
//       "leader": "أحمد علي",
//       "status": "قيد العمل",
//       "progress": 0.65,
//       "color": const Color(0xFF6366F1),
//       "members": ["أحمد", "سارة", "خالد", "ليلى"],
//     },
//     {
//       "title": "E-Learning Platform",
//       "leader": "محمود حسن",
//       "status": "مكتمل",
//       "progress": 1.0,
//       "color": const Color(0xFF10B981),
//       "members": ["محمود", "إبراهيم", "نور"],
//     },
//     {
//       "title": "Smart Logistics System",
//       "leader": "ياسين محمد",
//       "status": "متأخر",
//       "progress": 0.30,
//       "color": const Color(0xFFF43F5E),
//       "members": ["ياسين", "عبد الله", "مريم", "عمر", "هبة"],
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F172A),
//       body: Stack(
//         children: [
//           // إضاءة خلفية خفيفة
//           Positioned(
//             top: -100.h,
//             right: -50.w,
//             child: _buildGlow(const Color(0xFF6366F1).withValues(alpha: 0.1)),
//           ),

//           CustomScrollView(
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               _buildHeader(),
//               SliverPadding(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w),
//                 sliver: SliverList(
//                   delegate: SliverChildBuilderDelegate(
//                     (context, index) => _buildTeamCard(index),
//                     childCount: teams.length,
//                   ),
//                 ),
//               ),
//               const SliverToBoxAdapter(child: SizedBox(height: 120)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // --- مكونات الشاشة ---

//   Widget _buildHeader() => SliverToBoxAdapter(
//     child: Padding(
//       padding: EdgeInsets.only(
//         top: 60.h,
//         left: 24.w,
//         right: 24.w,
//         bottom: 20.h,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "فرق العمل",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 28.sp,
//               fontWeight: FontWeight.w900,
//             ),
//           ),
//           SizedBox(height: 5.h),
//           Text(
//             "لديك ${teams.length} فرق تحت إشرافك حالياً",
//             style: TextStyle(color: Colors.white38, fontSize: 13.sp),
//           ),
//         ],
//       ),
//     ),
//   );

//   Widget _buildTeamCard(int index) {
//     var team = teams[index];
//     return Container(
//       margin: EdgeInsets.only(bottom: 20.h),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E293B).withValues(alpha: 0.6),
//         borderRadius: BorderRadius.circular(28.r),
//         border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(28.r),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Padding(
//             padding: EdgeInsets.all(20.r),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildStatusBadge(team['status'], team['color']),
//                     IconButton(
//                       icon: const Icon(Icons.more_horiz, color: Colors.white54),
//                       onPressed: () => _showOptions(index),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12.h),
//                 Text(
//                   team['title'],
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 Text(
//                   "قائد الفريق: ${team['leader']}",
//                   style: TextStyle(color: Colors.white38, fontSize: 12.sp),
//                 ),

//                 SizedBox(height: 20.h),
//                 // بروجرس بار احترافي
//                 Row(
//                   children: [
//                     Expanded(
//                       child: LinearProgressIndicator(
//                         value: team['progress'],
//                         backgroundColor: Colors.white.withValues(alpha: 0.05),
//                         color: team['color'],
//                         minHeight: 6.h,
//                         borderRadius: BorderRadius.circular(10.r),
//                       ),
//                     ),
//                     SizedBox(width: 15.w),
//                     Text(
//                       "${(team['progress'] * 100).toInt()}%",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),

//                 SizedBox(height: 20.h),
//                 // عرض الأعضاء بستايل الـ Stack
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildMemberStack(team['members']),
//                     _buildActionIcon(
//                       Icons.chat_bubble_outline_rounded,
//                       team['color'],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // --- أدوات مساعدة (Helpers) ---

//   Widget _buildStatusBadge(String text, Color color) => Container(
//     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
//     decoration: BoxDecoration(
//       color: color.withValues(alpha: 0.1),
//       borderRadius: BorderRadius.circular(10.r),
//     ),
//     child: Text(
//       text,
//       style: TextStyle(
//         color: color,
//         fontSize: 10.sp,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//   );

//   Widget _buildMemberStack(List<String> members) {
//     return SizedBox(
//       height: 32.h,
//       width: 100.w,
//       child: Stack(
//         children: List.generate(
//           members.length > 3 ? 4 : members.length,
//           (i) => Positioned(
//             left: i * 20.w,
//             child: CircleAvatar(
//               radius: 16.r,
//               backgroundColor: const Color(0xFF0F172A),
//               child: CircleAvatar(
//                 radius: 14.r,
//                 backgroundColor: const Color(0xFF1E293B),
//                 child: Text(
//                   i == 3 ? "+${members.length - 3}" : members[i][0],
//                   style: TextStyle(color: Colors.white70, fontSize: 10.sp),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildActionIcon(IconData icon, Color color) => Container(
//     padding: EdgeInsets.all(8.r),
//     decoration: BoxDecoration(
//       color: color.withValues(alpha: 0.1),
//       shape: BoxShape.circle,
//     ),
//     child: Icon(icon, color: color, size: 20.sp),
//   );

//   Widget _buildGlow(Color color) => Container(
//     width: 200.r,
//     height: 200.r,
//     decoration: BoxDecoration(
//       shape: BoxShape.circle,
//       boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
//     ),
//   );

//   void _showOptions(int index) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xFF1E293B),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
//       ),
//       builder:
//           (context) => Container(
//             padding: EdgeInsets.all(20.r),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.edit, color: Colors.blueAccent),
//                   title: const Text(
//                     "تعديل بيانات الفريق",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onTap: () => Navigator.pop(context),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.delete, color: Colors.redAccent),
//                   title: const Text(
//                     "حذف الفريق",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onTap: () {
//                     setState(() => teams.removeAt(index));
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           ),
//     );
//   }
// }
