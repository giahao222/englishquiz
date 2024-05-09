import 'package:csv/csv.dart';
import 'package:englishquiz/models/Topic.dart';
import 'package:englishquiz/models/WordPair.dart';
import 'package:englishquiz/services/FirebaseService.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InTopicController extends GetxController {
  var name = ''.obs;
  var image = ''.obs;
  var isPublic = false.obs;
  var isEngType = false.obs;
  var listVocab = <String, dynamic>{}.obs;
  var engWord = '';
  var vieWord = '';
  var listCard = <WordPair>[].obs;
  Topic topic = Topic('', '', '', '', false, false, {});
  final id = Get.arguments;
  final FirebaseService _firebaseService = Get.find();
  // final _creator = FirebaseAuth.instance.currentUser!.displayName??'Unknown';

  final nameController = TextEditingController();
  final imageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    DatabaseReference ref = FirebaseDatabase.instance.ref('Topics').child(id);
    ref.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      topic = Topic.fromJson(data);
      isPublic.value = topic.isPublic;
      name.value = topic.name;
      image.value = topic.image;
      nameController.text = topic.name;
      imageController.text = topic.image;
      isEngType.value = topic.isEngType;
      listCard.clear();
      topic.listVocab.forEach((key, value) {
        listCard
            .add(WordPair(english: key.obs, vietnamese: value.toString().obs));
      });
    });
  }

  void importFromCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result == null || result.files.single.bytes == null) return;
    final input = String.fromCharCodes(result.files.first.bytes!);
    List<List<dynamic>> csvList = const CsvToListConverter().convert(input);
    for (var row in csvList) {
      if (row.length != 2) {
        Get.snackbar('Error', 'Invalid CSV file',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2));
        return;
      }
      addCard(WordPair(
          english: row[0].toString().obs, vietnamese: row[1].toString().obs));
    }
  }

  void updateTopic() async {
    if (name.value.isEmpty || image.value.isEmpty || listCard.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 2));
      return;
    }
    Topic topic = Topic(id, name.value, 'Unknown', image.value,
        isPublic.value, isEngType.value, _listCardToJson(listCard));
    await _firebaseService.updateData('Topics/$id', topic.toJson());
    print(topic);
    // Get.back();
  }

  Map<String, dynamic> _listCardToJson(RxList<WordPair> listCard) {
    Map<String, dynamic> listVocab = {};
    for (var card in listCard) {
      listVocab.addAll({card.english.value: card.vietnamese.value});
    }
    return listVocab;
  }

  void deleteTopic() async {
    await _firebaseService.removeData('Topics/$id');
    Get.back();
    Get.back();
  }

  // Function to add card
  void addCard(WordPair card) {
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

  @override
  void onClose() {
    nameController.dispose();
    imageController.dispose();
    super.onClose();
  }
}

class InTopic extends StatelessWidget {
  final InTopicController controller = Get.put(InTopicController());

  InTopic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Topic"),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: controller.updateTopic,
              icon: Icon(
                Icons.replay_outlined,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: 'Delete Topic',
                  content: Text('Are you sure to delete this topic?'),
                  actions: [
                    TextButton(
                      onPressed: controller.deleteTopic,
                      child: Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('No'),
                    ),
                  ],
                );
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
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
                controller: controller.nameController,
                onChanged: (value) => controller.name.value = value,
                decoration: InputDecoration(labelText: 'Name'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => controller.textValidator(value!),
              ),
              TextFormField(
                controller: controller.imageController,
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
                    title: Text("English to Vietnamese?"),
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
                                        controller.addCard(WordPair(
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
                      onPressed: controller.importFromCSV,
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
                onPressed: controller.updateTopic,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                  fixedSize: MaterialStateProperty.all(Size.fromWidth(200)),
                ),
                child:
                    Text('Update Topic', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
