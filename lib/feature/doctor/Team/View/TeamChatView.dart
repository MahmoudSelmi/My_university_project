// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class TeamChatView extends StatelessWidget {
//   final String teamName;
//   const TeamChatView({super.key, required this.teamName});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F172A),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1E293B),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               teamName,
//               style: TextStyle(color: Colors.white, fontSize: 16.sp),
//             ),
//             Text(
//               "متصل الآن",
//               style: TextStyle(color: Colors.greenAccent, fontSize: 10.sp),
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.all(20.r),
//               children: [
//                 _chatBubble(
//                   "يا شباب، محتاجين نخلص الـ API النهاردة ضروري.",
//                   "محمود سلمي",
//                   true,
//                 ),
//                 _chatBubble(
//                   "أنا خلصت الـ Auth وببدأ في الـ Home دلوقتي.",
//                   "عبادي",
//                   false,
//                 ),
//                 _chatBubble(
//                   "تمام جداً، هراجع الكود وراكم المسا.",
//                   "الدكتور",
//                   true,
//                 ),
//               ],
//             ),
//           ),
//           _buildChatInput(),
//         ],
//       ),
//     );
//   }

//   Widget _chatBubble(String msg, String sender, bool isMe) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.only(bottom: 15.h),
//         padding: EdgeInsets.all(15.r),
//         decoration: BoxDecoration(
//           color: isMe ? const Color(0xFF6366F1) : const Color(0xFF1E293B),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20.r),
//             topRight: Radius.circular(20.r),
//             bottomLeft: isMe ? Radius.circular(20.r) : Radius.zero,
//             bottomRight: isMe ? Radius.zero : Radius.circular(20.r),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (!isMe)
//               Text(
//                 sender,
//                 style: TextStyle(
//                   color: Colors.blueAccent,
//                   fontSize: 10.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             SizedBox(height: 5.h),
//             Text(msg, style: TextStyle(color: Colors.white, fontSize: 13.sp)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildChatInput() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E293B),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               style: const TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: "اكتب رسالة...",
//                 hintStyle: TextStyle(color: Colors.white24, fontSize: 14.sp),
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.all(10.r),
//             decoration: const BoxDecoration(
//               color: Color(0xFF6366F1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(Icons.send_rounded, color: Colors.white, size: 20.sp),
//           ),
//         ],
//       ),
//     );
//   }
// }
