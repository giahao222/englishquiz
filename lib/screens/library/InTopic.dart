import 'package:englishquiz/models/Topic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InTopic extends StatelessWidget {
  var topic = Get.arguments as Topic;
  InTopic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topic: ${topic.name}', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        
      ),
    );
  }
}
