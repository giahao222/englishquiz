import 'dart:ui';

import 'package:englishquiz/models/Topic.dart';
import 'package:englishquiz/screens/library/MyFolder.dart';
import 'package:englishquiz/services/FirebaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TopicController extends GetxController {
  var userTopics = <Topic>[].obs;
  var topics = <Topic>[].obs;
  var isLoading = true.obs;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void onInit() {
    fetchTopics();
    super.onInit();
  }

  void fetchTopics() {
    try {
      isLoading(true);
      var topicRef = FirebaseDatabase.instance.ref().child('Topics');
      topicRef.onValue.listen((event) {
        if (event.snapshot.value == null) {
          topics.value = [];
          return;
        }
        Map<String, dynamic> data =
            event.snapshot.value as Map<String, dynamic>;
        topics.value = _convertToListTopic(data);
        userTopics.value = topics
            .where((element) => element.creator == userId)
            .toList();
      });
    } finally {
      isLoading(false);
    }
  }

  List<Topic> _convertToListTopic(Map<String, dynamic> data) {
    List<Topic> topics = [];
    data.forEach((key, value) {
      topics.add(Topic.fromJson(value));
    });
    return topics;
  }
}

class MyTopics extends StatelessWidget {
  MyTopics({super.key});

  final FirebaseService firebaseService = Get.find();
  final TopicController topicController = Get.put(TopicController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (topicController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (topicController.userTopics.isEmpty) {
          return PageEmpty();
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: topicController.userTopics.length,
              itemBuilder: (context, index) {
                Topic topic = topicController.userTopics[index];
                return TopicItemCard(topic: topic, fontSize: 24);
              },
            ),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Get.toNamed('/add-topic');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TopicItemCard extends StatelessWidget {
  double fontSize;

  TopicItemCard({
    super.key,
    required this.topic,
    this.fontSize = 20,
  });

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed('mode-learn', arguments: {
          'topicId': topic.id,
          'name': topic.name,
          'mode': 'user'
        });
      },
      child: Card(
        elevation: 10,
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
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    topic.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
