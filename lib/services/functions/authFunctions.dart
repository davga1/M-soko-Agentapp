// ignore: file_names
import 'package:agentapp/common/user_data.dart';
import 'package:agentapp/common/utils.dart';
import 'package:agentapp/services/functions/firebaseFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices {
  static signupUser(
      String email, String password, String name, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);

      await FirestoreServices.saveUser(name, email, userCredential.user?.uid);
      // ignore: use_build_context_synchronously
      ToastM().toastMessage('Registration Successful');
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Registration Successful')));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password Provided is too weak')));
      } else if (e.code == 'email-already-in-use') {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email Provided already Exists')));
      }
    } catch (e) {
      ToastM().toastMessage('$e');
      // ignore: use_build_context_synchronously
      // ScaffoldMessenger.of(context)
      // .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static signinUser(String email, String password, BuildContext context) async {
    try {
      try {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('Agents')
            .doc(email)
            .get();

        if (documentSnapshot.exists) {
          var agentName = documentSnapshot['Agent Name'];

          Users.set(email, agentName);
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
        } else {
          debugPrint('Document does not exist');
        }
      } catch (e) {
        if(e.toString().contains('[firebase_auth/invalid-credential]')){
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wrong password')));
        }
        debugPrint('Error retrieving agent name: $e');
      }
    } on FirebaseAuthException catch (e) {
      
      if (e.code == 'user-not-found') {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user Found with this Email')));
      } else if (e.code == 'wrong-password') {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password did not match')));
      }
    }
  }
}
