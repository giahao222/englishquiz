import 'package:englishquiz/screens/home/ModeLearning.dart';
import 'package:flutter/material.dart';

class ModeLearn extends StatelessWidget {
  final String name;
  final String mode;

  ModeLearn({required this.name, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mode Learn'),
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
        // Thực hiện hành động khi Card được nhấn
        print('ModeLearning: ${modeLearning.name}');
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
                SizedBox(height: 8), // Khoảng cách giữa ảnh và tiêu đề
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
}
