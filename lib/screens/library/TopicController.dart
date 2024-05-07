import 'package:englishquiz/screens/home/Topic.dart';
import 'package:englishquiz/services/FirebaseService.dart';
import 'package:get/get.dart';

class TopicController extends GetxController{
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
      var topics = await FirebaseService().fetchData('Topics');
      this.topics = _convertToListTopic(topics).obs;
    } finally {
      isLoading(false);
    }
  }

  List<Topic> _convertToListTopic(Map<dynamic, dynamic> data) {
    List<Topic> topics = [];
    data.forEach((key, value) {
      topics.add(Topic.fromJson(key, value));
    });
    return topics;
  }
  
}