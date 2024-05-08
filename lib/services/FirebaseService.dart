import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class FirebaseService extends GetxService {
  late final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<Map<String, dynamic>> fetchData(String node) async {
    try {
      DatabaseReference voc = _database.child(node);
      final snapshot = await voc.once();
      final dataSnapshot = snapshot.snapshot.value as Map<String, dynamic>;
      return dataSnapshot;
    } catch (e) {
      print(e);
      return {'error': e};
    }
  }

  Future<void> addData(String node, Map<String, dynamic> data) async {
    try {
      DatabaseReference voc = _database.child(node);
      await voc.set(data);
    } catch (e) {
      print(e);
    }
  }

  //update data
  Future<void> updateData(String node, Map<String, dynamic> data) async {
    try {
      DatabaseReference voc = _database.child(node);
      await voc.update(data);
    } catch (e) {
      print(e);
    }
  }
}
