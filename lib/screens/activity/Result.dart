import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final List<String> questions;
  final List<String> userAnswers;
  final List<String> correctAnswers;

  Result({
    required this.questions,
    required this.userAnswers,
    required this.correctAnswers,
  });

  @override
  Widget build(BuildContext context) {
    int correctCount = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i].toLowerCase() == correctAnswers[i].toLowerCase()) {
        correctCount++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                bool isCorrect = userAnswers[index].toLowerCase() ==
                    correctAnswers[index].toLowerCase();

                return ListTile(
                  title: Text('Question ${index + 1}: ${questions[index]}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Answer: ${userAnswers[index]}'),
                      Text(
                        'Correct Answer: ${correctAnswers[index]}',
                        style: TextStyle(
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Score: $correctCount/${questions.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
