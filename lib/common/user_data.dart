import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  static String userId = "";
  static String userName = "";

  static Future<void> set(String id, String name) async {
    userId = id;
    userName = name;
  }

  static Future<void> set2(String id) async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('Agents').doc(id).get();
    userId = id;
    userName = documentSnapshot['Agent Name'];
  }

  static String fetchId() {
    return userId;
  }

  static String fetchName() {
    return userName;
  }
}
