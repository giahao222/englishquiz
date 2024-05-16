import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'Result.dart';

class Quizzle extends StatefulWidget {
  final String topic;
  final String mode;
  final bool change;

  Quizzle({required this.topic, required this.mode, required this.change});

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
  late List<String> userAnswers;

  @override
  void initState() {
    super.initState();
    databaseReference = FirebaseDatabase.instance.ref();
    ques = [];
    ans = [];
    rand = [];
    i = 0;
    score = 0.0;
    userAnswers = [];
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
            if (widget.change) {
              String word = item['meaning_vi'] ?? '';
              String fail = item['meaning_vi'] ?? '';
              String meaning_vi = item['word'] ?? '';
              setState(() {
                ques.add(meaning_vi);
                ans.add(word);
                rand.add(fail);
              });
            } else {
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
        Container(
          height: 300,
          width: MediaQuery.of(context).size.width * 0.6,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              '${ques[i]}',
              style: TextStyle(fontSize: 60, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: _buildAnswerButton(answers[0]),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: _buildAnswerButton(answers[1]),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: _buildAnswerButton(answers[2]),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: _buildAnswerButton(answers[3]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnswerButton(String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          userAnswers.add(text);
          _checkAnswer(text);
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
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
          userAnswers: List.from(userAnswers),
          correctAnswers: ans,
        ),
      ),
    );
  }
}
