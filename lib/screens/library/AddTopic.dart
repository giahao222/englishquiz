import 'package:englishquiz/utils/UniqueKeyGenerator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTopicController extends GetxController {
  var name = ''.obs;
  var image = ''.obs;
  var isPublic = false.obs;
  var isEngType = false.obs;
  var listVocab = <String, dynamic>{}.obs;
  final _creator = FirebaseAuth.instance.currentUser!.displayName;

  var nameController = TextEditingController();
  var idError = Rx<String?>(null);
  var nameError = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(validateName);
  }

  void uploadTopic() {
    validateName();
    if (nameError.value != null) return;
    final id = UniqueKeyGenerator().generateId();
  }

  void validateName() {
    if (nameController.text.isEmpty) {
      nameError.value = "Name cannot be empty";
    } else {
      nameError.value = null;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
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
        child: Column(
          children: [
            TextField(
              onChanged: (value) => controller.name.value = value,
              decoration: InputDecoration(labelText: 'Name'),
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
    );
  }
}
