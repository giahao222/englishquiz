// import 'package:englishquiz/screens/home/AddVocabulary.dart';
// import 'package:englishquiz/screens/home/DetailTopic.dart';
// import 'package:englishquiz/screens/home/Topic.dart';
// import 'package:flutter/material.dart';

// class TopicAdapter extends StatelessWidget {
//   final List<Topic> arrayList;
//   final BuildContext context;
//   final int flag;

//   TopicAdapter(this.context, this.flag, this.arrayList);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: arrayList.length,
//       itemBuilder: (context, index) {
//         return _buildTopicItem(context, arrayList[index]);
//       },
//     );
//   }

//   Widget _buildTopicItem(BuildContext context, Topic topic) {
//     return Card(
//       child: ListTile(
//         leading: Image.asset('assets/${topic.id}.png'),
//         title: Text(topic.name),
//         subtitle: Text(topic.des),
//         onTap: () {
//           if (flag == 0) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DetailTopic(
//                   name: topic.name,
//                   des: topic.des,
//                   re: topic.id,
//                 ),
//               ),
//             );
//           } else if (flag == 1) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => AddVocabulary(),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
