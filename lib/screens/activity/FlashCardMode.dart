import 'package:englishquiz/screens/activity/Finish.dart';
import 'package:englishquiz/screens/home/HomeFragment.dart';
import 'package:englishquiz/screens/home/home.dart';
import 'package:englishquiz/screens/public_topic/Modes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';

class FlashCardMode extends StatefulWidget {
  final String topic;
  final String mode;
  final bool change;
  FlashCardMode(
      {required this.topic, required this.mode, required this.change});

  @override
  _FlashCardModeState createState() => _FlashCardModeState();
}

class _FlashCardModeState extends State<FlashCardMode>
    with SingleTickerProviderStateMixin {
  late List<String> eng;
  late List<String> viet;
  late int i;
  late AnimationController _controller;
  late Animation<double> _rotation;
  bool isFront = true;
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    eng = [];
    viet = [];
    i = 0;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _rotation = Tween<double>(begin: 0, end: pi).animate(_controller);
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
            if (widget.change) {
              String word = item['meaning_vi'] ?? '';
              String meaning_vi = item['word'] ?? '';
              setState(() {
                viet.add(meaning_vi);
                eng.add(word);
              });
            } else {
              String word = item['word'] ?? '';
              String meaning_vi = item['meaning_vi'] ?? '';
              setState(() {
                viet.add(meaning_vi);
                eng.add(word);
              });
            }
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
        title: Text('Flash Card'),
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
            _controller.isCompleted
                ? _controller.reverse()
                : _controller.forward();

            setState(() {
              if (i < eng.length) {
                isFront = !isFront;
              }
            });
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_rotation.value),
                alignment: Alignment.center,
                child: _buildCard(isFront
                    ? (eng.isEmpty ? "" : eng[i])
                    : (viet.isEmpty ? "" : viet[i])),
              );
            },
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (i < eng.length - 1 && i > 0) {
                    i--;
                    isFront = true;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                _controller.isCompleted
                    ? _controller.reverse()
                    : _controller.forward();
                setState(() {
                  if (i < eng.length) {
                    isFront = !isFront;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Flip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                if (i == eng.length - 1) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Finish()));
                }
                setState(() {
                  if (i < eng.length - 1) {
                    i++;
                    isFront = true;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: i == eng.length - 1
                  ? Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )
                  : Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
            ),
          ],
        ),
        SizedBox(height: 20),
        IconButton(
          icon: Icon(Icons.volume_up, size: 30),
          onPressed: () {
            if (isFront) {
              _speakEnglish();
            } else {
              _speakVietnamese();
            }
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCard(String text) {
    return Container(
      width: 400,
      height: 300,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Transform(
                transform: _rotation.value > pi / 2
                    ? Matrix4.rotationY(pi)
                    : Matrix4.rotationY(0),
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _speakEnglish() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(eng[i]);
  }

  void _speakVietnamese() async {
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.speak(viet[i]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
