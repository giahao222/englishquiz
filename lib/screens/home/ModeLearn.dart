import 'package:englishquiz/screens/activity/ConnectWord.dart';
import 'package:englishquiz/screens/activity/FlashCardMode.dart';
import 'package:englishquiz/screens/activity/Quizzle.dart';
import 'package:englishquiz/screens/activity/WriteAnswer.dart';
import 'package:englishquiz/screens/auth/login.dart';
import 'package:englishquiz/screens/home/ModeLearning.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModeLearnController extends GetxController {
  final String topicId = Get.arguments['topicId'];
  final String name = Get.arguments['name'];
  final String mode = Get.arguments['mode'];
  final bool change = Get.arguments['change'];
}

class ModeLearn extends StatelessWidget {
  final ModeLearnController controller = Get.put(ModeLearnController());

  ModeLearn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mode Learn'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildModeList(context),
    );
  }

  Widget _buildModeList(BuildContext context) {
    List<ModeLearning> modeLearns = [
      ModeLearning("Quizzes", 'quizz'),
      ModeLearning("Flash card", 'flipcard'),
      ModeLearning("Connect Word", 'connect'),
      ModeLearning("Q&A", 'write'),
    ];

    return ListView.builder(
      itemCount: modeLearns.length,
      itemBuilder: (context, index) {
        return _buildModeItem(context, modeLearns[index]);
      },
    );
  }

  Widget _buildModeItem(BuildContext context, ModeLearning modeLearning) {
    return InkWell(
      onTap: () {
        _navigateToSelectedMode(context, modeLearning);
        print('ModeLearning: ${modeLearning.id}');
      },
      child: Container(
        height: 300,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/${modeLearning.id}.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  modeLearning.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToSelectedMode(
      BuildContext context, ModeLearning modeLearning) {
    Widget destinationWidget;

    switch (modeLearning.id) {
      case 'quizz':
        destinationWidget = Quizzle(
          topic: controller.name,
          mode: controller.mode,
          change: controller.change,
        );
        break;
      case 'flipcard':
        destinationWidget = FlashCardMode(
          topic: controller.name,
          mode: controller.mode,
          change: controller.change,
        );
        break;
      case 'connect':
        destinationWidget = ConnectWord(
          topic: controller.name,
          mode: controller.mode,
          change: controller.change,
        );
        break;
      case 'write':
        destinationWidget = WriteAnswer(
          topic: controller.name,
          mode: controller.mode,
          change: controller.change,
        );
        break;
      default:
        destinationWidget = LoginPage();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destinationWidget),
    );
  }
}
