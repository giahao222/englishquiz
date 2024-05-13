import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'Result.dart';

class ConnectWord extends StatefulWidget {
  final String topic;
  final String mode;

  ConnectWord({required this.topic, required this.mode});

  @override
  _ConnectWordState createState() => _ConnectWordState();
}

String shuffleStringWithSlash(String input) {
  List<String> characters = input.split('');
  characters.shuffle();
  return characters.join('/');
}

class _ConnectWordState extends State<ConnectWord> {
  final TextEditingController _textEditingController = TextEditingController();
  late List<String> ques;
  late List<String> ans;
  late List<String> des;
  late List<String> quesChange;
  late List<bool> arrayList;
  late List<String> userAnswers; // Thêm danh sách câu trả lời của người dùng
  late int i;
  late double score;

  @override
  void initState() {
    super.initState();
    score = 0.0;
    i = 0;
    ques = [];
    ans = [];
    des = [];
    quesChange = [];
    arrayList = [];
    userAnswers = [];
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
            String meaning = shuffleStringWithSlash(word);
            String desc = item['meaning_en'] ?? '';
            setState(() {
              ques.add(meaning);
              ans.add(word);
              des.add(desc);
            });

            print('Word: $word');
            print('Meaning: $meaning');
          } else {
            print('Error: item is not a Map');
          }
        }
      } else {
        debugPrint('Word: null');
      }

      int seed = DateTime.now().microsecondsSinceEpoch;
      setState(() {
        ques.shuffle(Random(seed));
        ans.shuffle(Random(seed));
        des.shuffle(Random(seed));
        quesChange.add(ques[i]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Word'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        SizedBox(height: 20),
        if (ques != null && i < ques.length) Text('Question: ${ques[i]}'),
        SizedBox(height: 20),
        if (des != null && i < des.length) Text('Description: ${des[i]}'),
        SizedBox(height: 20),
        TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            hintText: 'Enter your answer',
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _checkAnswer,
          child: Text('Check'),
        ),
        SizedBox(height: 20),
        Text('Your score: $score'),
      ],
    );
  }

  void _checkAnswer() {
    String answer = _textEditingController.text;
    userAnswers.add(answer);

    if (answer.toLowerCase() == ans[i].toLowerCase()) {
      setState(() {
        score += 10.0 / ans.length;
        arrayList.add(true);
      });
    } else {
      setState(() {
        arrayList.add(false);
      });
    }

    if (i < ans.length - 1) {
      setState(() {
        i++;
        _textEditingController.clear();
        quesChange.add(ques[i]);
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Result(
          questions: ques,
          userAnswers: userAnswers,
          correctAnswers: ans,
        ),
      ),
    );
  }
}
