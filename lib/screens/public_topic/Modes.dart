import 'dart:convert';
import 'package:englishquiz/models/Question.dart';
import 'package:englishquiz/utils/APIFetcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

enum ModeType { quiz, connect, flashcard, write }

class SimpleModeFactory {
  static Widget getMode(ModeType mode) {
    switch (mode) {
      case ModeType.quiz:
        return QuizPage();
      case ModeType.connect:
        return ConnectWordPage();
      case ModeType.flashcard:
        return FlashCardPage();
      case ModeType.write:
        return WriteAnswerPage();
      default:
        return const Placeholder();
    }
  }
}

class ModeController extends GetxController {
  var mode = ModeType.quiz.obs;
  final topic = Get.arguments['topic'];
  late ListQuestion listQuestion;
  var quesIndex = 0.obs;
  var userAnswer = <String>[];
  var nextButton = 'Next'.obs;
  var isFront = true.obs;

  @override
  void onInit() async {
    super.onInit();
    changeMode(Get.arguments['mode'] ?? ModeType.quiz);
    listQuestion = ListQuestion.fromTopic(topic, mode.value);
  }

  void changeMode(ModeType newMode) {
    mode.value = newMode;
  }

  void nextQuestion(String answer) {
    userAnswer.add(answer);
    if (quesIndex.value < listQuestion.questions.length - 1) {
      quesIndex++;
    } else {
      Get.offAllNamed('/result', arguments: {
        'listQuestion': listQuestion,
        'userAnswer': userAnswer,
        'mode': mode.value
      });
    }
  }

  void flipCard() {
    isFront.value = !isFront.value;
  }
}

class QuizPage extends StatelessWidget {
  QuizPage({super.key});
  final ModeController modeController = Get.put(ModeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: _buildQuiz(modeController: modeController),
    );
  }
}

class _buildQuiz extends StatelessWidget {
  const _buildQuiz({
    required this.modeController,
  });

  final ModeController modeController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: Card(
                  color: const Color(0xFFFCE4EC),
                  elevation: 4,
                  child: Center(
                    child: Text(
                      modeController.listQuestion
                          .questions[modeController.quesIndex.value].question,
                      style: const TextStyle(
                          fontSize: 24,
                          color: Color(0xFFC2185B),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: modeController.listQuestion
                    .questions[modeController.quesIndex.value].options.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      modeController.nextQuestion(modeController
                          .listQuestion
                          .questions[modeController.quesIndex.value]
                          .options[index]);
                    },
                    child: Card(
                      elevation: 4,
                      color: Color(0xFFFFFDE7),
                      child: Center(
                        child: Text(
                          modeController
                              .listQuestion
                              .questions[modeController.quesIndex.value]
                              .options[index],
                          style: const TextStyle(
                              fontSize: 20, color: Color(0xFFFF8F00)),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  modeController.nextQuestion('');
                },
                child: Text(
                  modeController.nextButton.value,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFC2185B),
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20),
                  backgroundColor: const Color(0xFFFCE4EC),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConnectWordPage extends StatelessWidget {
  final ModeController modeController = Get.put(ModeController());
  final TextEditingController answerController = TextEditingController();
  ConnectWordPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title:
            const Text('Connect Word', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          modeController
                              .listQuestion
                              .questions[modeController.quesIndex.value]
                              .question,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Color(0xFFC2185B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FutureBuilder<String>(
                          future: APIFetcher.instance.fetchHints(modeController
                              .listQuestion
                              .questions[modeController.quesIndex.value]
                              .answer),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return const Text('Not found hints');
                            }
                            String hints = jsonDecode(snapshot.data.toString())
                                .first['meanings']
                                .first['definitions']
                                .first['definition'];
                            return Text(
                              'Hint: $hints',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFFC2185B),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: answerController,
                  decoration: const InputDecoration(
                    labelText: 'Answer',
                    border: OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (value) {
                    modeController.nextQuestion(value);
                    answerController.clear();
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  modeController.nextQuestion(answerController.text);
                  answerController.clear();
                },
                child: Text(
                  modeController.nextButton.value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFC2185B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20),
                  backgroundColor: const Color(0xFFFCE4EC),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlashCardPage extends StatelessWidget {
  FlashCardPage({super.key});
  final ModeController modeController = Get.put(ModeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Obx(
              () => GestureDetector(
                onTap: () {
                  modeController.flipCard();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(modeController.isFront.value ? 0 : 3.14),
                  transformAlignment: Alignment.center,
                  child: modeController.isFront.value
                      ? SizedBox(
                          height: 300,
                          child: Card(
                            elevation: 4,
                            color: const Color(0xFFFCE4EC),
                            child: Center(
                              child: Text(
                                modeController
                                    .listQuestion
                                    .questions[modeController.quesIndex.value]
                                    .question,
                                style: const TextStyle(
                                    fontSize: 48,
                                    color: Color(0xFFC2185B),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(3.14),
                          child: SizedBox(
                            height: 300,
                            child: Card(
                              elevation: 4,
                              color: const Color(0xFFFCE4EC),
                              child: Center(
                                child: Text(
                                  modeController
                                      .listQuestion
                                      .questions[modeController.quesIndex.value]
                                      .answer,
                                  style: const TextStyle(
                                      fontSize: 48,
                                      color: Color(0xFFC2185B),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                modeController.nextQuestion('');
              },
              child: Text(
                modeController.nextButton.value,
                style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFC2185B),
                    fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: const Color(0xFFFCE4EC),
              ),
            )
          ]),
        ),
      )),
    );
  }
}

class WriteAnswerPage extends StatelessWidget {
  WriteAnswerPage({super.key});
  final TextEditingController answerController = TextEditingController();
  final ModeController modeController = Get.put(ModeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title:
            const Text('Connect Word', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          modeController
                              .listQuestion
                              .questions[modeController.quesIndex.value]
                              .question,
                          style: const TextStyle(
                            fontSize: 36,
                            color: Color(0xFFC2185B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: answerController,
                  decoration: const InputDecoration(
                    labelText: 'Answer',
                    border: OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (value) {
                    modeController.nextQuestion(value);
                    answerController.clear();
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  modeController.nextQuestion(answerController.text);
                  answerController.clear();
                },
                child: Text(
                  modeController.nextButton.value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFC2185B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20),
                  backgroundColor: const Color(0xFFFCE4EC),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultController extends GetxController {
  ListQuestion listQuestion = Get.arguments['listQuestion'];
  List<String> userAnswer = Get.arguments['userAnswer'];
  ModeType mode = Get.arguments['mode'];

  var score = 0.obs;

  @override
  void onInit() {
    super.onInit();
    for (int i = 0; i < listQuestion.questions.length; i++) {
      if (listQuestion.questions[i].answer == userAnswer[i]) {
        score++;
      }
    }
  }
}

class ResultPage extends StatelessWidget {
  ResultPage({super.key});
  final ResultController resultController = Get.put(ResultController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Result', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: resultController.mode == ModeType.flashcard
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300,
                    child: Lottie.network(
                        'https://lottie.host/b7292b51-1d94-4385-be08-dbd2e528e048/LTFxvyA25Z.json'),
                  ),
                  Center(
                    child: Text(
                      'Congratulations! You have finished the flashcard mode!',
                      style: TextStyle(
                          fontSize: 18,
                          color: const Color(0xFFC2185B),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed('/home');
                      Get.toNamed('/public-topics');
                    },
                    child: const Text('OK',
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFFC2185B))),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 20),
                      backgroundColor: const Color(0xFFFCE4EC),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    // Add ListView.builder
                    itemCount: resultController.listQuestion.questions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(resultController
                            .listQuestion.questions[index].question, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Your answer: ${resultController.userAnswer[index]}'),
                            Text('Correct answer: ${resultController.listQuestion.questions[index].answer}')
                          ],
                        ),
                        trailing: resultController
                                    .listQuestion.questions[index].answer ==
                                resultController.userAnswer[index]
                            ? const Icon(Icons.check, color: Colors.green)
                            : const Icon(Icons.close, color: Colors.red),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Score: ${resultController.score.value}/${resultController.listQuestion.questions.length}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed('/home');
                      Get.toNamed('/public-topics');
                    },
                    child: const Text('OK',
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFFC2185B))),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 20),
                      backgroundColor: const Color(0xFFFCE4EC),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
