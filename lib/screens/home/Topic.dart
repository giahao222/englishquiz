import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Topic {
  String id;
  String name;
  String creator;
  String image;
  bool isPublic;
  bool isEngType;
  Map<String,dynamic> listVocab;

  Topic(this.id, this.name, this.creator, this.image, this.isPublic,
      this.isEngType, this.listVocab);

  factory Topic.fromJson(String id, Map<dynamic, dynamic> json) {
    return Topic(
      id,
      json['name'],
      json['creator'],
      json['image'],
      json['isPublic'],
      json['isEngType'],
      json['list_vocab'],
    );
  }

  Map<dynamic, dynamic> toJson() => {
        'id': id,
        'name': name,
        'creator': creator,
        'image': image,
        'isPublic': isPublic,
        'isEngType': isEngType,
        'list_vocab': listVocab,
      };
}
