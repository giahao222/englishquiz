import 'Topic.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Folder {
  String id;
  String nameFolder;
  List<Topic> mTopic;

  Folder(this.id, this.nameFolder, this.mTopic);

  factory Folder.fromJson(String key, Map<dynamic, dynamic> json) {
    List<Topic> topics = [];
    if (json['topics'] == null) return Folder(key, json['name'], topics);
    json['topics'].forEach((key, value) {
      topics.add(Topic.fromJson(value));
    });
    return Folder(key, json['name'], topics);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameFolder': nameFolder,
        'topics': mTopic,
      };

  @override
  String toString() {
    return 'Folder{id:$id nameFolder: $nameFolder, topics: $mTopic}';
  }
}
