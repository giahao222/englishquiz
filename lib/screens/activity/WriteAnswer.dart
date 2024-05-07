import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

class WriteAnswer extends StatefulWidget {
  final String topic;
  final String mode;

  WriteAnswer({required this.topic, required this.mode});

  @override
  _WriteAnswerState createState() => _WriteAnswerState();
}

class _WriteAnswerState extends State<WriteAnswer> {
  late DatabaseReference databaseReference;
  late List<String> ques;
  late List<String> ans;
  late int i;
  late double score;
  late TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    databaseReference = FirebaseDatabase.instance.reference();
    ques = [];
    ans = [];
    i = 0;
    score = 0.0;
    DatabaseReference voc = databaseReference
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
              ques.add(meaning_vi);
              ans.add(word);
            });
          }
        }
      }

      int seed = DateTime.now().microsecondsSinceEpoch;

      setState(() {
        ques.shuffle(Random(seed));
        ans.shuffle(Random(seed));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write Answer'),
      ),
      body: ans.isEmpty || i == ans.length ? _buildEmpty() : _buildBody(),
    );
  }

  Widget _buildEmpty() {
    return Text("");
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Text(
          'Question: ${ques[i]}',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 20),
        TextField(
          controller: _textEditingController,
          enabled: true,
          decoration: InputDecoration(
            hintText: 'Type your answer here',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _checkAnswer();
          },
          child: Text('Check Answer'),
        ),
      ],
    );
  }

  void _checkAnswer() {
    String answer = _textEditingController.text;
    if (i < ans.length) {
      if (answer.toLowerCase() == ans[i].toLowerCase()) {
        setState(() {
          score += (10.0 / ans.length);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Correct Answer!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect Answer!')),
        );
      }
      _nextQuestion();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complete!')),
      );
    }
  }

  void _nextQuestion() {
    setState(() {
      _textEditingController.clear();
      i++;
    });
  }
}
