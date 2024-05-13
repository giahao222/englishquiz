import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'Result.dart'; // Import lớp Result

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
  final TextEditingController _textEditingController = TextEditingController();
  List<String> userAnswers = []; // Danh sách câu trả lời của người dùng

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
    return Center(
      child: ans.isEmpty
          ? Text('')
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Quiz completed!',
                  style: TextStyle(fontSize: 60, color: Colors.green),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showResult,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    'Result',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Container(
          width: 400,
          height: 300,
          child: Card(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  '${ques[i]}',
                  style: TextStyle(fontSize: 60, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: _textEditingController,
          enabled: true,
          decoration: InputDecoration(
            hintText: 'Enter your answer',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _checkAnswer();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: Text(
            'Check',
            style: TextStyle(color: Colors.white),
          ),
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
      }
      userAnswers.add(answer);
      _nextQuestion();
    } else {
      _showResult();
    }
  }

  void _nextQuestion() {
    setState(() {
      _textEditingController.clear();
      i++;
    });
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
