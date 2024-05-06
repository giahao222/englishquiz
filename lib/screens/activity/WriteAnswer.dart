// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'dart:math';

// class WriteAnswer extends StatefulWidget {
//   final String topic;
//   final String mode;

//   WriteAnswer({required this.topic, required this.mode});

//   @override
//   _WriteAnswerState createState() => _WriteAnswerState();
// }

// class _WriteAnswerState extends State<WriteAnswer> {
//   late DatabaseReference databaseReference;
//   late List<String> ques;
//   late List<String> ans;
//   late int i;
//   late double score;

//   @override
//   void initState() {
//     super.initState();
//     databaseReference = FirebaseDatabase.instance.reference();
//     ques = [];
//     ans = [];
//     i = 0;
//     score = 0.0;
//     DatabaseReference voc = FirebaseDatabase.instance
//         .reference()
//         .child("home")
//         .child("mode")
//         .child(widget.mode)
//         .child(widget.topic);
//     voc.once().then((snapshot) {
//       final dataSnapshot = snapshot.snapshot;
//       return dataSnapshot;
//     }).catchError((error) {
//       print(error);
//     });

//     int seed = DateTime.now().microsecondsSinceEpoch;

//     setState(() {
//       ques.shuffle(Random(seed));
//       ans.shuffle(Random(seed));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Write Answer'),
//       ),
//       body: _buildBody(),
//     );
//   }

//   Widget _buildBody() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(height: 20),
//         Text(
//           'Question: ${ques[i]}',
//           style: TextStyle(fontSize: 20),
//         ),
//         SizedBox(height: 20),
//         TextField(
//           controller: TextEditingController(),
//           enabled: true,
//           decoration: InputDecoration(
//             hintText: 'Type your answer here',
//             border: OutlineInputBorder(),
//           ),
//         ),
//         SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: () {
//             _checkAnswer();
//           },
//           child: Text('Check Answer'),
//         ),
//       ],
//     );
//   }

//   void _checkAnswer() {
//     String answer =
//         (ModalRoute.of(context)?.settings.arguments as String?) ?? '';
//     if (i < ans.length) {
//       if (answer.toLowerCase() == ans[i].toLowerCase()) {
//         setState(() {
//           score += (10.0 / ans.length);
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Correct Answer!')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Incorrect Answer!')),
//         );
//       }
//       _nextQuestion();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Complete!')),
//       );
//     }
//   }

//   void _nextQuestion() {
//     setState(() {
//       i++;
//     });
//   }
// }
