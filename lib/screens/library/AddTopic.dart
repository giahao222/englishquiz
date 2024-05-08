import 'package:englishquiz/screens/home/Topic.dart';
import 'package:englishquiz/services/FirebaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardData {
  var vietnamese = ''.obs;
  var english = ''.obs;

  CardData({required this.vietnamese, required this.english});
}

class AddTopicController extends GetxController {
  var name = ''.obs;
  var image = ''.obs;
  var isPublic = false.obs;
  var isEngType = false.obs;
  var listVocab = <String, dynamic>{}.obs;
  var engWord = '';
  var vieWord = '';
  var listCard = <CardData>[].obs;
  // final _creator = FirebaseAuth.instance.currentUser!.displayName??'Unknown';

  void uploadTopic() async {
    if (name.value.isEmpty || image.value.isEmpty || listCard.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 2));
      return;
    }

    Topic topic = Topic(
        name.value,
        'Unknown',
        image.value,
        isPublic.value,
        isEngType.value,
        _convertToListVocab(listCard));
    await FirebaseService().addData('Topics', topic.toJson());
    Get.back();
  }

  Map<String, dynamic> _convertToListVocab(RxList<CardData> listCard) {
    Map<String, dynamic> listVocab = {};
    listCard.forEach((card) {
      listVocab[card.english.value] = card.vietnamese.value;
    });
    return listVocab;
  }

  // Function to add card
  void addCard(CardData card) {
    listCard.add(card);
  }

  // Function to remove card
  void removeCard(int index) {
    listCard.removeAt(index);
    for (int i = 0; i < listCard.length; i++) {
      print(
          'Card $i: ${listCard[i].english.value} - ${listCard[i].vietnamese.value}');
    }
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

  AddTopic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Topic"),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.save,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Form(
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) => controller.name.value = value,
                decoration: InputDecoration(labelText: 'Name'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => controller.textValidator(value!),
              ),
              TextFormField(
                onChanged: (value) => controller.image.value = value,
                decoration: InputDecoration(labelText: 'Image URL'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => controller.textValidator(value!),
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
                  Expanded(
                    child: Text('List Vocabulary'),
                    flex: 6,
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      tooltip: 'Add Vocabulary',
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text('Add Vocabulary'),
                                  content: Column(
                                    children: [
                                      TextFormField(
                                        onChanged: (value) =>
                                            controller.engWord = value,
                                        decoration: InputDecoration(
                                            labelText: 'English'),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) =>
                                            controller.textValidator(value!),
                                      ),
                                      TextFormField(
                                        onChanged: (value) =>
                                            controller.vieWord = value,
                                        decoration: InputDecoration(
                                            labelText: 'Vietnamese'),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) =>
                                            controller.textValidator(value!),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        controller.addCard(CardData(
                                            english: controller.engWord.obs,
                                            vietnamese:
                                                controller.vieWord.obs));
                                        Get.back();
                                      },
                                      child: Text('Add'),
                                    ),
                                  ],
                                ));
                      },
                      icon: Icon(Icons.add),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      tooltip: 'Import from csv file',
                      onPressed: () {},
                      icon: Icon(Icons.import_contacts_rounded),
                    ),
                  ),
                ],
              ),
              Obx(() => Column(
                    children: controller.listCard
                        .map((card) => Card(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    padding: EdgeInsets.all(15),
                                    child: Text(
                                      '${card.english.value} : ${card.vietnamese.value}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  IconButton(
                                    onPressed: () => controller.removeCard(
                                        controller.listCard.indexOf(card)),
                                    icon: Icon(Icons.remove),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  )),
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
      ]),
    );
  }
}
