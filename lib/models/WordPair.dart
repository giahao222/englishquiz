import 'package:get/get.dart';

class WordPair {
  RxString vietnamese = ''.obs;
  RxString english = ''.obs;

  WordPair({required this.vietnamese, required this.english});

  set setVietnamese(String value) => vietnamese.value = value;
  set setEnglish(String value) => english.value = value;
}