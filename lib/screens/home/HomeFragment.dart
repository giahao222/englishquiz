// import 'package:englishquiz/screens/home/FolderAdapter.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'Folder.dart';
// import 'Topic.dart';
// import 'dart:ui';

// class HomeFragment extends StatefulWidget {
//   @override
//   _HomeFragmentState createState() => _HomeFragmentState();
// }

// class _HomeFragmentState extends State<HomeFragment> {
//   List<Topic> _arrayList = [];
//   List<Folder> _arrayFolder = [];
//   late FolderAdapter _folderAdapter;
//   late FirebaseAuth _mAuth;
//   late User _user;
//   late FirebaseStorage _storage;
//   late Reference _storageReference;
//   int _z = 0;
//   List<String> _imageArray = [
//     "personality",
//     "marketing",
//     "art",
//     "emotion",
//     "time",
//     "tool",
//     "color",
//     "animal",
//     "play",
//     "tool",
//     "weather1",
//     "play",
//     "study",
//     "play"
//   ];
//   DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

//   @override
//   void initState() {
//     super.initState();
//     _folderAdapter = FolderAdapter(context, _arrayFolder, 0);
//     _getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: ListView.builder(
//           itemCount: _arrayList.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(_arrayList[index].name),
//               subtitle: Text(_arrayList[index].des),
//               leading: Image.asset('assets/${_arrayList[index].id}.png'),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void _getData() {
//     List<String> imageList = List.from(_imageArray);
//     List<Folder> mFolder = [];
//     List<Topic> mTopic = [];

//     DatabaseReference folder = _databaseReference
//         .child('home')
//         .child('mode')
//         .child('easy')
//         .child('folder');
//     folder.once().then((snapshot) {
//       final dataSnapshot = snapshot.snapshot;
//       if (dataSnapshot.value != null) {
//         mFolder.clear();
//         (dataSnapshot.value as Map).forEach((key, value) {
//           DatabaseReference s = folder.child(key).child('topics');
//           s.once().then((snapshot2) {
//             final dataSnapshot2 = snapshot2.snapshot;
//             if (dataSnapshot2.value != null) {
//               (dataSnapshot2.value as Map).forEach((key2, value2) {
//                 DatabaseReference des = _databaseReference
//                     .child('home')
//                     .child('mode')
//                     .child('description')
//                     .child(value2);
//                 des.once().then((snapshot3) {
//                   final dataSnapshot3 = snapshot3.snapshot;
//                   ImageProvider imageProvider =
//                       AssetImage("assets/${imageList[_z]}.png");
//                   imageProvider
//                       .resolve(createLocalImageConfiguration(context))
//                       .addListener(
//                     ImageStreamListener((info, _) {
//                       String resourceId = info.image.hashCode.toString();
//                       // Sử dụng resourceId ở đây
//                       mTopic.add(Topic(
//                           value2, dataSnapshot3.value.toString(), resourceId));
//                       _z++;
//                       if (mTopic.length ==
//                           (dataSnapshot2.value as Map).length) {
//                         mFolder.add(Folder(key, List.from(mTopic)));
//                         mTopic.clear();
//                         setState(() {
//                           _arrayList = List.from(mFolder);
//                         });
//                       }
//                     }),
//                   );
//                 });
//               });
//             }
//           });
//         });
//       }
//     });
//     _z = 0;
//   }
// }
