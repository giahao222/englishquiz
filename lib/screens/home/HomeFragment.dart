import 'package:englishquiz/screens/activity/ConnectWord.dart';
import 'package:englishquiz/screens/activity/FlashCardMode.dart';
import 'package:englishquiz/screens/activity/Quizzle.dart';
import 'package:englishquiz/screens/activity/WriteAnswer.dart';
import 'package:englishquiz/screens/auth/login.dart';
import 'package:englishquiz/screens/home/ModeLearn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'Folder.dart';
import 'Topic.dart';
import 'package:get/get.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  List<Folder> _arrayFolder = [];
  late FirebaseAuth _mAuth;
  late User _user;
  late FirebaseStorage _storage;
  late Reference _storageReference;
  int _z = 0;
  List<String> _imageArray = [
    "personality",
    "marketing",
    "art",
    "emotion",
    "time",
    "tool",
    "color",
    "animal",
    "play",
    "tool",
    "weather1",
    "play",
    "study",
    "play"
  ];
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: _buildListView(),
      ),
    );
  }

  Widget _buildListView() {
    if (_arrayFolder.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        itemCount: _arrayFolder.length,
        itemBuilder: (context, index) {
          return _buildFolderItem(_arrayFolder[index]);
        },
      );
    }
  }

  Widget _buildFolderItem(Folder folder) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              folder.getNameFolder(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          SizedBox(
            height: 250.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: folder.mTopic.length,
              itemBuilder: (context, index) {
                return _buildTopicCard(folder.mTopic[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(Topic topic) {
    return GestureDetector(
      onTap: () => _showDifficultyDialog(context, topic),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/${_getImage(_imageArray)}.jpg',
                  height: 100.0,
                  width: 100.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 8.0),
                Text(
                  topic.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  topic.des,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDifficultyDialog(BuildContext context, Topic topic) async {
    bool isChanged = false;

    final mode = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SimpleDialog(
              title: Text('Select Difficulty'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(
                        context, {'difficulty': 'easy', 'change': isChanged});
                  },
                  child: const Text(
                    'Easy',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(
                        context, {'difficulty': 'medium', 'change': isChanged});
                  },
                  child: const Text(
                    'Medium',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(
                        context, {'difficulty': 'hard', 'change': isChanged});
                  },
                  child: const Text(
                    'Hard',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SwitchListTile(
                    title: Text(
                      'Vietnamese to English',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    value: isChanged,
                    onChanged: (bool value) {
                      setState(() {
                        isChanged = value;
                      });
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (mode != null) {
      Get.to(() => ModeLearn(), arguments: {
        'name': topic.name,
        'mode': mode['difficulty'],
        'topicId': topic.id,
        'change': isChanged,
      });
    }
  }

  void _getData() async {
    List<String> imageList = List.from(_imageArray);

    try {
      DatabaseReference folder = _databaseReference
          .child('home')
          .child('mode')
          .child('easy')
          .child('folder');
      DatabaseEvent snapshot = await folder.once();

      Map<dynamic, dynamic> dataSnapshot =
          snapshot.snapshot.value as Map<dynamic, dynamic>;
      if (dataSnapshot != null) {
        for (var entry in dataSnapshot.entries) {
          List<Topic> mTopic = await _getTopics(
              entry.key.toString(), entry.value.toString(), imageList);
          _arrayFolder.add(Folder(entry.key, List.from(mTopic)));
        }
        setState(() {});
      }
    } catch (e) {
      print('Error getting data: $e');
    }
  }

  Future<List<Topic>> _getTopics(
      String key, String value, List<String> imageList) async {
    List<Topic> mTopic = [];

    try {
      DatabaseReference s = _databaseReference
          .child('home')
          .child('mode')
          .child('easy')
          .child('folder')
          .child(key)
          .child('topics');
      DatabaseEvent snapshot2 = await s.once();

      List<dynamic> dataSnapshot2 = snapshot2.snapshot.value as List<dynamic>;
      if (dataSnapshot2 != null) {
        for (var entry in dataSnapshot2) {
          DatabaseReference des = _databaseReference
              .child('home')
              .child('mode')
              .child('description')
              .child(entry.toString());
          DatabaseEvent snapshot3 = await des.once();
          String dataSnapshot3 = snapshot3.snapshot.value as String;
          String imageId = _getImage(imageList);

          mTopic.add(Topic(entry.toString(), dataSnapshot3, imageId));
          print('data: ' + dataSnapshot3);
        }
      }
    } catch (e) {
      print('Error getting topics: $e');
    }

    return mTopic;
  }

  String _getImage(List<String> imageList) {
    String imageId = imageList[_z % imageList.length];
    _z++;
    return imageId;
  }
}
