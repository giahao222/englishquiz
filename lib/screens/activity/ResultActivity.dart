// import 'package:englishquiz/screens/home/ResultAdapter.dart';
// import 'package:englishquiz/screens/object/IClick.dart';
// import 'package:englishquiz/screens/object/ResultItem.dart';
// import 'package:flutter/material.dart';

// class ResultActivity extends StatefulWidget {
//   final ResultItem resultItem;

//   ResultActivity({Key? key, required this.resultItem}) : super(key: key);

//   @override
//   _ResultActivityState createState() => _ResultActivityState();
// }

// class _ResultActivityState extends State<ResultActivity> implements IClick {
//   late ResultAdapter resultAdapter;
//   late Dialog dialog;

//   @override
//   void initState() {
//     super.initState();
//     // resultAdapter = ResultAdapter(
//     //   resultItem: widget.resultItem,
//     //   onClickSeeDetail: this,
//     // );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Result'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: ListView(
//           children: [
//             SizedBox(
//               height: 16.0,
//             ),
//             Text(
//               'Your Results:',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(
//               height: 16.0,
//             ),
//             //resultAdapter,
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void onClickSeeDetail(int i) {
//     createDialog(i, widget.resultItem);
//   }

//   void createDialog(int i, ResultItem resultItem) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: Container(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Question: ${resultItem.quesafter[i]}',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   'Answer: ${resultItem.ques[i]}',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   'Your Answer: ${resultItem.answer[i]}',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(
//                   height: 16.0,
//                 ),
//                 Align(
//                   alignment: Alignment.center,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text('OK'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
