import 'dart:convert';
import 'dart:math';
import 'package:englishquiz/models/Topic.dart';
import 'package:englishquiz/screens/public_topic/Modes.dart';
import 'package:englishquiz/utils/APIFetcher.dart';
import 'package:web/helpers.dart';

class Question {
  final String question;
  final List<String> options;
  final String answer;

  Question({
    required this.question,
    required this.options,
    required this.answer,
  });
}

class ListQuestion {
  final List<Question> questions;
  final ModeType mode;

  ListQuestion({required this.questions, required this.mode});

  static ListQuestion fromTopic(Topic topic, ModeType mode)  {
    List<Question> questions = [];
    List<String> engWords = topic.isEngType
        ? topic.listVocab.keys.toList()
        : topic.listVocab.values.map((e) => e.toString()).toList();
    List<dynamic> vietWords = topic.isEngType
        ? topic.listVocab.values.map((e) => e.toString()).toList()
        : topic.listVocab.keys.toList();
    print('EngWords: $engWords');
    print('VietWords: $vietWords');
    switch (mode) {
      case ModeType.quiz:
        for (int i = 0; i < vietWords.length; i++) {
          List<String> randOptions = [];
          randOptions.add(vietWords[i]);
          while (randOptions.length < 4) {
            String randWord = vietWords[Random().nextInt(engWords.length)];
            if (!randOptions.contains(randWord)) {
              randOptions.add(randWord);
            }
          }
          randOptions.shuffle();
          questions.add(Question(
            question: engWords[i],
            options: randOptions,
            answer: vietWords[i],
          ));
        }
        questions.shuffle();
        return ListQuestion(questions: questions, mode: mode);
      case ModeType.connect: // Kết quả: t/t/a/o/j
        for (int i = 0; i < vietWords.length; i++) {
          String engWord = engWords[i];
          List<String> engWordSpilt = engWord.split('');
          engWordSpilt.shuffle();
          String question = engWordSpilt.join('/');
          questions.add(Question(
            question: question,
            options: [],
            answer: vietWords[i],
          ));
        }
        questions.shuffle();
        return ListQuestion(questions: questions, mode: mode);
      case ModeType.flashcard:
        for (int i = 0; i < vietWords.length; i++) {
          questions.add(Question(
            question: engWords[i],
            options: [],
            answer: vietWords[i],
          ));
        }
        questions.shuffle();
        return ListQuestion(questions: questions, mode: mode);
      default:
        return ListQuestion(questions: [], mode: mode);
    }
  }

  @override
  String toString() {
    String str = '';
    for (int i = 0; i < questions.length; i++) {
      str += 'Question ${i + 1}: ${questions[i].question}\n';
      for (int j = 0; j < questions[i].options.length; j++) {
        str += 'Option ${j + 1}: ${questions[i].options[j]}\n';
      }
      str += 'Answer: ${questions[i].answer}\n\n';
    }
    return str;
  }
}
