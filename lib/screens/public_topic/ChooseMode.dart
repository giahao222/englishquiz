import 'package:englishquiz/models/Topic.dart';
import 'package:englishquiz/screens/public_topic/Modes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseModeController extends GetxController {
  bool isMyTopic = false;
  final Topic topic = Get.arguments['topic'];
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
    isMyTopic = topic.creator == userId;
  }
}

class ChooseModePage extends StatelessWidget {
  ChooseModePage({super.key});

  final ChooseModeController chooseModeController =
      Get.put(ChooseModeController());
  final modes = {
    ModeType.quiz: 'Quizz',
    ModeType.connect: 'Connect Word',
    ModeType.flashcard: 'Flashcard',
    ModeType.write: 'Q&A',
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Mode', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          Visibility(
            child: IconButton(
              icon: Icon(Icons.edit_rounded, color: Colors.white),
              onPressed: () {
                Get.toNamed(
                  '/topic',
                  arguments: {'topicId': chooseModeController.topic.id},
                );
              },
            ),
            visible: chooseModeController.isMyTopic,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(children: [
            GestureDetector(
              onTap: () => _onTapMode(ModeType.quiz),
              child: SizedBox(
                width: double.infinity,
                height: 250,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 180,
                        child: Image(
                          image: AssetImage('assets/quizz.png'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        modes[ModeType.quiz]!,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _onTapMode(ModeType.connect),
              child: SizedBox(
                width: double.infinity,
                height: 250,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 180,
                        child: Image(
                          image: AssetImage('assets/connect.png'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        modes[ModeType.connect]!,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _onTapMode(ModeType.flashcard),
              child: SizedBox(
                width: double.infinity,
                height: 250,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 180,
                        child: Image(
                          image: AssetImage('assets/flipcard.png'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        modes[ModeType.flashcard]!,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _onTapMode(ModeType.write),
              child: SizedBox(
                width: double.infinity,
                height: 250,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 180,
                        child: Image(
                          image: AssetImage('assets/write.png'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        modes[ModeType.write]!,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ]),
        ),
      ),
    );
  }

  void _onTapMode(ModeType mode) {
    Get.to(
      () => SimpleModeFactory.getMode(mode),
      arguments: {
        'topic': chooseModeController.topic,
        'mode': mode,
      },
    );
  }
}
