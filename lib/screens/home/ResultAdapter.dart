// import 'package:englishquiz/screens/object/ResultItem.dart';
// import 'package:englishquiz/screens/object/iClick.dart';
// import 'package:flutter/material.dart';

// class ResultAdapter extends StatelessWidget {
//   final ResultItem resultItem;
//   final IClick onClickSeeDetail;

//   ResultAdapter({required this.resultItem, required this.onClickSeeDetail});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: resultItem.ques.length,
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           onTap: () {
//             //onClickSeeDetail.onClickSeeDetail(index);
//           },
//           child: Card(
//             child: Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   Text(
//                     'Question ${index + 1}',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 16.0,
//                   ),
//                   if (resultItem.result[index])
//                     Text(
//                       'Correct',
//                       style: TextStyle(
//                         color: Colors.green,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     )
//                   else
//                     Text(
//                       'Incorrect',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
