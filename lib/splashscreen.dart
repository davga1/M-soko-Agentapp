// // ignore_for_file: prefer_const_constructors
// import 'dart:async';
// import 'package:agentapp/auth/login.dart';
// import 'package:agentapp/common/constant.dart';
// import 'package:agentapp/pages/hompage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// // splashServices() {
// //   Timer(Duration(seconds: 2), () {
// //     Get.offAll(() => LosginForm());
// //   });
// // }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(Duration(seconds: 3), () {
//       navigateToNextScreen();
//     });
//   }

//   void navigateToNextScreen() {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => StreamBuilder(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return GetMaterialApp(
//                 debugShowCheckedModeBanner: false,
//                 home: HomePage(),
//               );
//             } else {
//               return LoginForm();
//             }
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: appColor,
//       body: Center(child: Image.asset("assets/images/logo.png")),
//     );
//   }
// }
