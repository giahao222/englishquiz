// import 'package:flutter/material.dart';
// import 'package:englishquiz/screens/home/ModeLearning.dart';
// import 'package:englishquiz/screens/activity/ConnectWord.dart';
// import 'package:englishquiz/screens/activity/FlashCardMode.dart';
// import 'package:englishquiz/screens/activity/Quizzle.dart';
// import 'package:englishquiz/screens/activity/WriteAnswer.dart';

// class ModeAdapter extends StatelessWidget {
//   final List<ModeLearning>? arrayList;
//   final String? topic;
//   final String? mode;
//   final BuildContext context;

//   ModeAdapter({
//     required this.context,
//     this.arrayList,
//     this.topic,
//     this.mode,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: arrayList?.length ?? 0,
//       itemBuilder: (context, index) {
//         final modeLearning = arrayList![index];
//         return ListTile(
//           leading: Image.asset(
//               'assets/mode_image.png'), // Thay thế bằng ảnh tương ứng cho từng mode
//           title: Text(modeLearning
//               .name), // Sử dụng trực tiếp thuộc tính name trong ModeLearning
//           onTap: () => _navigateToMode(modeLearning),
//         );
//       },
//     );
//   }

//   void _navigateToMode(ModeLearning modeLearning) {
//     final modeName = modeLearning.name;
//     if (modeName == "Flash card") {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => FlashCardMode(topic: topic!, mode: mode!),
//         ),
//       );
//     } else if (modeName == "Q&A") {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => WriteAnswer(topic: topic!, mode: mode!),
//         ),
//       );
//     } else if (modeName == "Connect Word") {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ConnectWord(topic: topic!, mode: mode!),
//         ),
//       );
//     } else if (modeName == "Quizzes") {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Quizzle(topic: topic!, mode: mode!),
//         ),
//       );
//     }
//   }
// }
