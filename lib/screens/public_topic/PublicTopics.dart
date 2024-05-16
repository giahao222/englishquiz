import 'package:englishquiz/models/Topic.dart';
import 'package:englishquiz/screens/library/MyTopics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PublicTopicController extends GetxController {
  var isExpanded = {}.obs;
  var publicTopics = <Topic>[].obs;
  var isLoaded = false.obs;
  final TopicController topicController = Get.put(TopicController());

  @override
  void onInit() {
    super.onInit();
    fetchPublicTopics();

    ever(topicController.topics, (_) {
      fetchPublicTopics();
    });
  }

  void fetchPublicTopics() {
    publicTopics.value =
        topicController.topics.where((element) => element.isPublic).toList();
  }
}

class PublicTopicsPage extends StatelessWidget {
  PublicTopicsPage({super.key});
  final publicTopicController = Get.put(PublicTopicController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Public Topics',
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: Obx(() {
          if (publicTopicController.isLoaded.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: publicTopicController.publicTopics.length,
              itemBuilder: (context, index) {
                final topic = publicTopicController.publicTopics[index];
                return TopicItemCard(topic: topic, fontSize: 20);
              },
            ),
          );
        }));
  }
}
