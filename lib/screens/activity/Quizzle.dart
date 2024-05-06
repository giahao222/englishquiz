// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'dart:math';

// class Quizzle extends StatefulWidget {
//   final String topic;
//   final String mode;

//   Quizzle({required this.topic, required this.mode});

//   @override
//   _QuizzleState createState() => _QuizzleState();
// }

// class _QuizzleState extends State<Quizzle> {
//   late DatabaseReference databaseReference;
//   late List<String> ques;
//   late List<String> ans;
//   late List<String> rand;
//   late int i;
//   late double score;
//   late String selectedAnswer;

//   @override
//   void initState() {
//     super.initState();
//     databaseReference = FirebaseDatabase.instance.reference();
//     ques = [];
//     ans = [];
//     rand = [];
//     i = 0;
//     score = 0.0;
//     selectedAnswer = '';
//     DatabaseReference voc = databaseReference
//         .child("home")
//         .child("mode")
//         .child(widget.mode)
//         .child("vocabulary")
//         .child(widget.topic);
//     voc.once().then((snapshot) {
//       final dataSnapshot = snapshot!.snapshot;
//       if (dataSnapshot.exists) {
//         Map<dynamic, dynamic>? values =
//             dataSnapshot.value as Map<dynamic, dynamic>?;
//         if (values != null) {
//           values.forEach((key, value) {
//             String word = value['word'];
//             String fail = value['word'];
//             String meaning_vi = value['meaning_vi'];
//             setState(() {
//               ques.add(meaning_vi);
//               ans.add(word);
//               rand.add(fail);
//             });
//           });
//         }
//       }

//       int seed = DateTime.now().microsecondsSinceEpoch;

//       setState(() {
//         ques.shuffle(Random(seed));
//         ans.shuffle(Random(seed));
//         rand.shuffle();
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quizzle'),
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
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildAnswerButton(ans[i]),
//             SizedBox(width: 20),
//             _buildAnswerButton(rand[0]),
//           ],
//         ),
//         SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildAnswerButton(rand[1]),
//             SizedBox(width: 20),
//             _buildAnswerButton(rand[2]),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildAnswerButton(String text) {
//     return ElevatedButton(
//       onPressed: () {
//         setState(() {
//           selectedAnswer = text;
//           _checkAnswer();
//         });
//       },
//       child: Text(text),
//     );
//   }

//   void _checkAnswer() {
//     if (selectedAnswer == ans[i]) {
//       setState(() {
//         score += (10.0 / ans.length);
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Correct Answer!')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Incorrect Answer!')),
//       );
//     }
//     _nextQuestion();
//   }

//   void _nextQuestion() {
//     setState(() {
//       i++;
//       selectedAnswer = '';
//     });
//     if (i == ans.length) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Quiz Complete!')),
//       );
//     }
//   }
// }
