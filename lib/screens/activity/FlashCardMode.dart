import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:englishquiz/screens/object/ResultItem.dart';
import 'package:englishquiz/screens/activity/ResultActivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

class FlashCardMode extends StatefulWidget {
  final String topic;
  final String mode;

  FlashCardMode({required this.topic, required this.mode});

  @override
  _FlashCardModeState createState() => _FlashCardModeState();
}

class _FlashCardModeState extends State<FlashCardMode> {
  late List<String> eng;
  late List<String> viet;
  late int i;
  late bool isFront;

  @override
  void initState() {
    super.initState();
    eng = [];
    viet = [];
    i = 0;
    isFront = true;
    DatabaseReference voc = FirebaseDatabase.instance
        .reference()
        .child("home")
        .child("mode")
        .child(widget.mode)
        .child("vocabulary")
        .child(widget.topic);
    voc.once().then((snapshot) {
      final dataSnapshot = snapshot.snapshot.value;
      if (dataSnapshot != null) {
        List<dynamic> dataList = dataSnapshot as List<dynamic>;
        for (var item in dataList) {
          if (item is Map<String, dynamic>) {
            String word = item['word'] ?? '';
            String meaning_vi = item['meaning_vi'] ?? '';
            setState(() {
              viet.add(meaning_vi);
              eng.add(word);
            });
          }
        }
      }

      int seed = DateTime.now().microsecondsSinceEpoch;
      setState(() {
        eng.shuffle(Random(seed));
        viet.shuffle(Random(seed));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flash Card Mode'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            setState(() {
              isFront = !isFront;
            });
          },
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: isFront
                ? Text(eng.isEmpty ? "" : eng[i])
                : Text(viet.isEmpty ? "" : viet[i]),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isFront = !isFront;
                });
              },
              child: Text('Flip'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (i < eng.length - 1) {
                    i++;
                    isFront = true;
                  } else {}
                });
              },
              child: Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}
