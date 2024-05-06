// import 'package:flutter/material.dart';
// import 'package:flutter/animation.dart';
// import 'package:englishquiz/screens/object/ResultItem.dart';
// import 'package:englishquiz/screens/activity/ResultActivity.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'dart:math';

// class FlashCardMode extends StatefulWidget {
//   final String topic;
//   final String mode;

//   FlashCardMode({required this.topic, required this.mode});

//   @override
//   _FlashCardModeState createState() => _FlashCardModeState();
// }

// class _FlashCardModeState extends State<FlashCardMode> {
//   late List<String> eng;
//   late List<String> viet;
//   late int i;
//   late bool isFront;
//   // late AnimatorSet fontAnim;
//   // late AnimatorSet backAnim;

//   @override
//   void initState() {
//     super.initState();
//     eng = [];
//     viet = [];
//     i = 0;
//     isFront = true;
//     DatabaseReference voc = FirebaseDatabase.instance
//         .reference()
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
//             String meaning_vi = value['meaning_vi'];
//             setState(() {
//               viet.add(meaning_vi);
//               eng.add(word);
//             });
//           });
//         }
//       }

//       int seed = DateTime.now().microsecondsSinceEpoch;
//       setState(() {
//         eng.shuffle(Random(seed));
//         viet.shuffle(Random(seed));
//       });
//     });
//     // fontAnim = AnimatorSet(
//     //   animations: [
//     //     Tween<double>(begin: 0, end: 180).animate(CurvedAnimation(
//     //       parent: AnimationController(
//     //         vsync: this,
//     //         duration: Duration(milliseconds: 500),
//     //       ),
//     //       curve: Curves.easeInOut,
//     //     )),
//     //   ],
//     // );
//     // backAnim = AnimatorSet(
//     //   animations: [
//     //     Tween<double>(begin: -180, end: 0).animate(CurvedAnimation(
//     //       parent: AnimationController(
//     //         vsync: this,
//     //         duration: Duration(milliseconds: 500),
//     //       ),
//     //       curve: Curves.easeInOut,
//     //     )),
//     //   ],
//     // );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flash Card Mode'),
//       ),
//       body: _buildBody(),
//     );
//   }

//   Widget _buildBody() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(height: 20),
//         // AnimatedBuilder(
//         //   animation: fontAnim,
//         //   builder: (context, child) {
//         //     return Transform(
//         //       transform: Matrix4.rotationY(fontAnim.value),
//         //       alignment: Alignment.center,
//         //       child: child,
//         //     );
//         //   },
//         //   child: Text(eng[i]),
//         // ),
//         SizedBox(height: 20),
//         // AnimatedBuilder(
//         //   animation: backAnim,
//         //   builder: (context, child) {
//         //     return Transform(
//         //       transform: Matrix4.rotationY(backAnim.value),
//         //       alignment: Alignment.center,
//         //       child: child,
//         //     );
//         //   },
//         //   child: Text(viet[i]),
//         // ),
//         SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   //_flipCard();
//                 });
//               },
//               child: Text('Flip'),
//             ),
//             SizedBox(width: 20),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   //_nextCard();
//                 });
//               },
//               child: Text('Next'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   // void _flipCard() {
//   //   if (isFront) {
//   //     fontAnim.forward();
//   //     backAnim.reverse();
//   //   } else {
//   //     fontAnim.reverse();
//   //     backAnim.forward();
//   //   }
//   //   isFront = !isFront;
//   // }

//   // void _nextCard() {
//   //   if (i < eng.length - 1) {
//   //     setState(() {
//   //       i++;
//   //       fontAnim.reset();
//   //       backAnim.reset();
//   //       isFront = true;
//   //     });
//   //   } else {
//   //     // Reached the end of cards
//   //     // Handle what to do when reached the end
//   //   }
//   // }
// }
