import 'dart:ui';

import 'package:englishquiz/screens/home/Topic.dart';
import 'package:englishquiz/screens/library/AddTopic.dart';
import 'package:englishquiz/screens/library/TopicController.dart';
import 'package:englishquiz/services/FirebaseService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MyTopics extends StatelessWidget {
  MyTopics({super.key});

  final FirebaseService firebaseService = Get.find();
  final TopicController topicController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (topicController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: topicController.topics.length,
            itemBuilder: (context, index) {
              Topic topic = topicController.topics[index];
              print(topic.toString());
              return Card(
                elevation: 5,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Image.network(
                            topic.image,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.2,
                          ),
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                          child: Container(
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                        Text(
                          topic.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Get.toNamed('/add_topic');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
