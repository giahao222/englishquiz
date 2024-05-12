import 'package:uuid/uuid.dart';

class UniqueIdGenerator {
  static final UniqueIdGenerator _instance = UniqueIdGenerator._internal();
  late Uuid _uuid;

  factory UniqueIdGenerator() {
    return _instance;
  }

  UniqueIdGenerator._internal() {
    _uuid = const Uuid();
  }

  String generateUniqueId() {
    return _uuid.v4();
  }
}
