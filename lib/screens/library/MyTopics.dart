import 'dart:ui';

import 'package:englishquiz/screens/auth/login.dart';
import 'package:englishquiz/models/Topic.dart';
import 'package:englishquiz/screens/library/AddTopic.dart';
import 'package:englishquiz/services/FirebaseService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TopicController extends GetxController {
  var topics = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchTopics();
    super.onInit();
  }

  void fetchTopics() async {
    try {
      isLoading(true);
      var topicRef = await FirebaseDatabase.instance.ref().child('Topics');
      topicRef.onValue.listen((event) {
        if(event.snapshot.value == null) {
          return;
        }
        Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
        topics.value = _convertToListTopic(data);
      });
    } finally {
      isLoading(false);
    }
  }

  List<Topic> _convertToListTopic(Map<dynamic, dynamic> data) {
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
              return InkWell(
                onTap: () {
                  Get.toNamed('/topic', arguments: topic);
                },
                child: Card(
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
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.orange[700],
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                          
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            
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
