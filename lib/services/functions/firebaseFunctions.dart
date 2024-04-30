// ignore: file_names
import 'package:agentapp/common/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreServices {
  static Future saveUser(String name, email, uid) async {
    try {
      await FirebaseFirestore.instance.collection('Agents').doc(email).set({
        'Agent Email': email,
        'Agent Name': name,
        'Agent ID': email,
      });

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Agents')
          .doc(email)
          .get();

      if (documentSnapshot.exists) {
        var agentName = documentSnapshot['Agent Name'];

        Users.set(email, agentName);
      } else {
        debugPrint('Document does not exist');
      }
      await Users.set(email, name);
    } catch (e) {
      debugPrint('Error retrieving agent name: $e');
    }
  }
}
