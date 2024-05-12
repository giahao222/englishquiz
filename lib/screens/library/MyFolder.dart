import 'package:englishquiz/models/Folder.dart';
import 'package:englishquiz/models/Topic.dart';
import 'package:englishquiz/services/FirebaseService.dart';
import 'package:englishquiz/utils/UniqueIdGenerator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class FolderController extends GetxController {
  var folders = <Folder>[].obs;
  var isLoading = true.obs;
  var nameFolder = ''.obs;
  var listTopic = <Topic>[].obs;
  var enableAddTopic = false.obs;
  final FirebaseService _firebaseService = Get.find();
  @override
  void onInit() {
    fetchFolders();
    fetchTopics();
    super.onInit();
  }

  void fetchFolders() {
    try {
      isLoading(true);
      var topicRef = FirebaseDatabase.instance.ref().child('Folders');
      topicRef.onValue.listen((event) {
        if (event.snapshot.value == null) {
          return;
        }
        Map<String, dynamic> data =
            event.snapshot.value as Map<String, dynamic>;
        folders.value = _convertToListFolder(data);
      });
    } finally {
      isLoading(false);
    }
  }

  void fetchTopics() {
    try {
      isLoading(true);
      var topicRef = FirebaseDatabase.instance.ref().child('Topics');
      topicRef.onValue.listen((event) {
        if (event.snapshot.value == null) {
          return;
        }
        Map<String, dynamic> data =
            event.snapshot.value as Map<String, dynamic>;
        listTopic.value = _convertToListTopic(data);
      });
    } finally {
      isLoading(false);
    }
  }

  List<Topic> _convertToListTopic(Map<dynamic, dynamic> data) {
    List<Topic> topics = [];
    if(data == null) return List<Topic>.empty(growable: true);
    data.forEach((key, value) {
      topics.add(Topic.fromJson(value));
    });
    return topics;
  }

  List<Folder> _convertToListFolder(Map<dynamic, dynamic> data) {
    List<Folder> folders = [];
    if(data == null) return List<Folder>.empty(growable: true);
    data.forEach((key, value) {
      folders.add(Folder.fromJson(key, value));
    });
    return folders;
  }

  void deleteTopicFromFolder(String folderId, String topicId) {
    _firebaseService.removeData('Folders/$folderId/topics/$topicId');
  }

  void deleteFolder(String folderId) {
    _firebaseService.removeData('Folders/$folderId');
  }

  void addFolder(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Folder'),
          content: TextField(
            onChanged: (value) {
              nameFolder.value = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                String folderId = UniqueIdGenerator().generateUniqueId();
                String topicId = UniqueIdGenerator().generateUniqueId();
                var data = {
                  'id': folderId,
                  'name': nameFolder.value,
                  'topics': {
                    topicId: {
                      'id': topicId,
                      'name': 'No Topic',
                      'creator': 'Unknown',
                      'image': 'https://picsum.photos/200',
                      'isEngType': true,
                      'isPublic': false,
                      'list_vocab': {'ok': 'oke', 'sleep': 'ng'}
                    }
                  }
                };
                _firebaseService.addData('Folders/$folderId', data);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void addTopicToFolder(BuildContext context, Folder folder,
      Function(List<Topic>) onTopicsSelected) {
    RxList<Topic> topics = <Topic>[].obs;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Topic to Folder'),
          content: SingleChildScrollView(
            child: Column(
              children: listTopic.map((topic) {
                return Obx(() => CheckboxListTile(
                      title: Text(topic.name),
                      value: topics.contains(topic),
                      onChanged: (bool? value) {
                        if (value == true) {
                          topics.add(topic);
                        } else {
                          topics.remove(topic);
                        }
                      },
                    ));
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: onTopicsSelected(topics),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void addTopicToFolderDb(Folder folder, List<Topic> topics) {
    for (var topic in topics) {
      var data = {
        'id': topic.id,
        'name': topic.name,
        'creator': topic.creator,
        'image': topic.image,
        'isEngType': topic.isEngType,
        'isPublic': topic.isPublic,
        'list_vocab': topic.listVocab
      };
      _firebaseService.addData('Folders/${folder.id}/topics/${topic.id}', data);
    }
  }
}

class MyFolder extends StatelessWidget {
  MyFolder({super.key});

  final FolderController folderController = Get.put(FolderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (folderController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (folderController.folders.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sync,
                  size: 100,
                  color: Colors.grey,
                ),
                Text(
                  'No Folder',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                )
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: folderController.folders.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(folderController.folders[index].nameFolder),
                  leading: Icon(Icons.folder),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add_rounded,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          folderController.addTopicToFolder(
                              context, folderController.folders[index],
                              (List<Topic> topics) {
                            return () {
                              folderController.addTopicToFolderDb(
                                  folderController.folders[index], topics);
                              Navigator.of(context).pop();
                            };
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete Folder'),
                                content: const Text('Are you sure?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      folderController.deleteFolder(
                                          folderController.folders[index].id);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('No'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: folderController.folders[index].mTopic.length,
                      itemBuilder: (context, indexTopic) {
                        if (folderController
                                .folders[index].mTopic[indexTopic].name !=
                            'No Topic') {
                          return ListTile(
                              title: Text(folderController
                                  .folders[index].mTopic[indexTopic].name),
                              leading: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Icon(Icons.topic),
                              ),
                              onTap: () {
                                Get.toNamed('/topic',
                                    arguments: folderController
                                        .folders[index].mTopic[indexTopic].id);
                              },
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Delete Topic'),
                                        content: const Text('Are you sure?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              folderController
                                                  .deleteTopicFromFolder(
                                                      folderController
                                                          .folders[index].id,
                                                      folderController
                                                          .folders[index]
                                                          .mTopic[indexTopic]
                                                          .id);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Yes'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('No'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ));
                        }
                      },
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                    )
                  ],
                );
              },
            ),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          folderController.addFolder(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
