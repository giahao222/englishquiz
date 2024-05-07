import 'package:englishquiz/utils/UniqueKeyGenerator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WordPair {
  String eng;
  String vie;

  WordPair({required this.eng, required this.vie});
}

class AddTopicController extends GetxController {
  var name = ''.obs;
  var image = ''.obs;
  var isPublic = false.obs;
  var isEngType = false.obs;
  var listVocab = <String, dynamic>{}.obs;
  var topics = <WordPair>[].obs;
  final _creator = FirebaseAuth.instance.currentUser!.displayName;


  @override
  void onInit() {
    super.onInit();
  }

  void uploadTopic() {
  }

  void addCard() {
    topics.add(WordPair(eng: '', vie: ''));
  }

  void removeCard(int index) {
    topics.removeAt(index);
  }

  String? textValidator(String value) {
    if (value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}

class AddTopic extends StatelessWidget {
  final AddTopicController controller = Get.put(AddTopicController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Topic"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) => controller.name.value = value,
                decoration: InputDecoration(labelText: 'Name'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => controller.textValidator(value!),
              ),
              TextField(
                onChanged: (value) => controller.image.value = value,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              Obx(() => SwitchListTile(
                    title: Text("Is Public?"),
                    value: controller.isPublic.value,
                    onChanged: (value) => controller.isPublic.value = value,
                  )),
              Obx(() => SwitchListTile(
                    title: Text("Is English Type?"),
                    value: controller.isEngType.value,
                    onChanged: (value) => controller.isEngType.value = value,
                  )),
              Container(
                height: 2,
                margin: EdgeInsets.symmetric(vertical: 25),
                color: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('List Vocabulary'),
                  IconButton(
                    tooltip: 'Import from csv file',
                    onPressed: () {
                    },
                    icon: Icon(Icons.import_contacts_rounded),
                  ),
                ],
              ),
              Obx(
                () => Column(
                  children: List.generate(
                      controller.topics.length,
                      (index) => Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  TextField(
                                    onChanged: (value) =>
                                        controller.topics[index].eng = value,
                                    decoration:
                                        InputDecoration(labelText: 'English'),
                                  ),
                                  TextField(
                                    onChanged: (value) =>
                                        controller.topics[index].vie = value,
                                    decoration:
                                        InputDecoration(labelText: 'Vietnamese'),
                                  ),
                                  if (controller.topics.length > 1)
                                    IconButton(
                                      onPressed: () =>
                                          controller.removeCard(index),
                                      icon: Icon(Icons.delete),
                                      color: Colors.red,
                                    ),
                                ],
                              ),
                            ),
                          )),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  controller.addCard();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  fixedSize: MaterialStateProperty.all(Size.fromWidth(100)),
                ),
                child: Icon(Icons.add, color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.uploadTopic,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                  fixedSize: MaterialStateProperty.all(Size.fromWidth(200)),
                ),
                child:
                    Text('Upload Topic', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
