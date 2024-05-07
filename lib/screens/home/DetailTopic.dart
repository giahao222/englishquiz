// import 'package:englishquiz/screens/home/ModeLearn.dart';
// import 'package:flutter/material.dart';

// class DetailTopic extends StatelessWidget {
//   final String name;
//   final String des;
//   final String re;

//   DetailTopic({required this.name, required this.des, required this.re});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Detail Topic'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(name),
//           Image.asset('assets/$re.png'),
//           Text(des),
//           ElevatedButton(
//             onPressed: () {
//               _showOptionsDialog(context);
//             },
//             child: Text('Start'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showOptionsDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Choose mode'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: [
//                 _buildDialogOption(context, 'Easy', 'easy'),
//                 _buildDialogOption(context, 'Medium', 'medium'),
//                 _buildDialogOption(context, 'Hard', 'hard'),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDialogOption(BuildContext context, String label, String mode) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ModeLearn(
//               name: name,
//               mode: mode,
//             ),
//           ),
//         );
//       },
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 8.0),
//         child: Text(label),
//       ),
//     );
//   }
// }
