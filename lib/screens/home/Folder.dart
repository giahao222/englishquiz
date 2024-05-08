import '../../models/Topic.dart';

class Folder {
  String nameFolder;
  List<Topic> mTopic;

  Folder(this.nameFolder, this.mTopic);

  String getNameFolder() {
    return nameFolder;
  }

  void setNameFolder(String nameFolder) {
    this.nameFolder = nameFolder;
  }

  List<Topic> getmTopic() {
    return mTopic;
  }

  void setmTopic(List<Topic> mTopic) {
    this.mTopic = mTopic;
  }
}
