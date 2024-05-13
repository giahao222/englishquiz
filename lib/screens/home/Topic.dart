class Topic {
  String name;
  String des;
  String id;

  Topic(this.name, this.des, this.id);

  String getName() {
    return name;
  }

  void setName(String name) {
    this.name = name;
  }

  String getId() {
    return id;
  }

  void setId(String id) {
    this.id = id;
  }

  String getDes() {
    return des;
  }

  void setDes(String des) {
    this.des = des;
  }

  @override
  String toString() {
    return "Topic{name: $name, des: $des, id: $id}";
  }
}
