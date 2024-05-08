import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Topic {
  String name;
  String creator;
  String image;
  bool isPublic;
  bool isEngType;
  Map<String, dynamic> listVocab;

  Topic(this.name, this.creator, this.image, this.isPublic, this.isEngType,
      this.listVocab);

  factory Topic.fromJson(Map<dynamic, dynamic> json) {
    return Topic(
      json['name'],
      json['creator'],
      json['image'],
      json['isPublic'],
      json['isEngType'],
      json['list_vocab'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'creator': creator,
        'image': image,
        'isPublic': isPublic,
        'isEngType': isEngType,
        'list_vocab': listVocab,
      };

  @override
  String toString() {
    return 'Topic{name: $name, creator: $creator, image: $image, isPublic: $isPublic, isEngType: $isEngType, listVocab: $listVocab}';
  }
}
