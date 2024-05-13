import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'Result.dart';

class Quizzle extends StatefulWidget {
  final String topic;
  final String mode;

  Quizzle({required this.topic, required this.mode});

  @override
  _QuizzleState createState() => _QuizzleState();
}

class _QuizzleState extends State<Quizzle> {
  late DatabaseReference databaseReference;
  late List<String> ques;
  late List<String> ans;
  late List<String> rand;
  late int i;
  late double score;
  late List<String> userAnswers; // Danh sách chứa câu trả lời của người dùng

  @override
  void initState() {
    super.initState();
    databaseReference = FirebaseDatabase.instance.ref();
    ques = [];
    ans = [];
    rand = [];
    i = 0;
    score = 0.0;
    userAnswers = []; // Khởi tạo danh sách câu trả lời của người dùng
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
            String fail = item['word'] ?? '';
            String meaning_vi = item['meaning_vi'] ?? '';
            setState(() {
              ques.add(meaning_vi);
              ans.add(word);
              rand.add(fail);
            });
          }
        }
      }

      int seed = DateTime.now().microsecondsSinceEpoch;

      setState(() {
        ques.shuffle(Random(seed));
        ans.shuffle(Random(seed));
        rand.shuffle(Random(seed));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quizzle'),
      ),
      body: ques.isEmpty || i == ans.length ? _buildEmpty() : _buildBody(),
    );
  }

  Widget _buildEmpty() {
    return Text("");
  }

  List<String> generateAnswers() {
    List<String> answers = [];

    answers.add(ans[i]);

    List<String> wrongAnswers = List.from(rand)..remove(ans[i]);
    wrongAnswers.shuffle(Random());

    answers.addAll(wrongAnswers.take(3));

    answers.shuffle(Random());

    return answers;
  }

  Widget _buildBody() {
    List<String> answers = generateAnswers();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Text(
          'Question: ${ques[i]}',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnswerButton(answers[0]),
            SizedBox(width: 20),
            _buildAnswerButton(answers[1]),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnswerButton(answers[2]),
            SizedBox(width: 20),
            _buildAnswerButton(answers[3]),
          ],
        ),
      ],
    );
  }

  Widget _buildAnswerButton(String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          userAnswers
              .add(text); // Thêm câu trả lời của người dùng vào danh sách
          _checkAnswer(text);
        });
      },
      child: Text(text),
    );
  }

  void _checkAnswer(String selectedAnswer) {
    if (selectedAnswer == ans[i]) {
      setState(() {
        score += (10.0 / ans.length);
      });
    }
    _nextQuestion();
  }

  void _nextQuestion() {
    setState(() {
      i++;
    });
    if (i == ans.length) {
      _showResult();
    }
  }

  void _showResult() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Result(
          questions: ques,
          userAnswers: List.from(
              userAnswers), // Chuyển danh sách câu trả lời của người dùng vào Result
          correctAnswers: ans,
        ),
      ),
    );
  }
}
