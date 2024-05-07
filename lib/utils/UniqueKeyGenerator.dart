import 'package:uuid/uuid.dart';

class UniqueKeyGenerator {
  static final UniqueKeyGenerator _instance = UniqueKeyGenerator._internal();

  final Uuid _uuid = const Uuid();

  UniqueKeyGenerator._internal();

  factory UniqueKeyGenerator() => _instance;
  
  String generateId() {
    return _uuid.v4();
  }
}