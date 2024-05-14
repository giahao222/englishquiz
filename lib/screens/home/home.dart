import 'dart:ui';

import 'package:englishquiz/models/Topic.dart';
import 'package:englishquiz/screens/library/MyTopics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var isExpanded = {}.obs;
  var publicTopics = <Topic>[].obs;
  final TopicController topicController = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchPublicTopics();
    isExpanded.value = {
      'listOfTopics': false,
      'publicTopics': false,
    };

    ever(topicController.topics, (_) {
      fetchPublicTopics();
    });
  }

  void fetchPublicTopics() {
    publicTopics.value = topicController.topics
        .where((element) => element.isPublic)
        .toList() as List<Topic>;
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final TopicController topicController = Get.find();
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  ListTile(
                    title: Text('Topics'),
                    trailing: IconButton(
                      icon: Icon(homeController.isExpanded['listOfTopics']
                          ? Icons.expand_less
                          : Icons.expand_more),
                      onPressed: () {
                        homeController.isExpanded['listOfTopics'] =
                            !homeController.isExpanded['listOfTopics'];
                        homeController.isExpanded.refresh();
                      },
                    ),
                  ),
                  Visibility(
                    visible: homeController.isExpanded['listOfTopics'],
                    child: GridView.builder(
                      // Replace GridView.builder with ListView.builder
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: topicController.topics.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) {
                        return TopicItemCard(
                          topic: topicController.topics[index],
                          fontSize: 12,
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: !homeController.isExpanded['listOfTopics'],
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: topicController.topics.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: 100,
                            child: TopicItemCard(
                              topic: topicController.topics[index],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Public Topics'),
                    trailing: IconButton(
                      icon: Icon(homeController.isExpanded['publicTopics']
                          ? Icons.expand_less
                          : Icons.expand_more),
                      onPressed: () {
                        homeController.isExpanded['publicTopics'] =
                            !homeController.isExpanded['publicTopics'];
                        homeController.isExpanded.refresh();
                      },
                    ),
                  ),
                  Visibility(
                    visible: homeController.isExpanded['publicTopics'],
                    child: GridView.builder(
                      // Replace GridView.builder with ListView.builder
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: homeController.publicTopics.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) {
                        return TopicItemCard(
                          topic: homeController.publicTopics[index],
                          fontSize: 12,
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: !homeController.isExpanded['publicTopics'],
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: homeController.publicTopics.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: 100,
                            child: TopicItemCard(
                              topic: homeController.publicTopics[index],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(topicController.userId);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
