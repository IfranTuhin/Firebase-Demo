import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_practice/Screen/home_screen.dart';
import 'package:firebase_practice/Screen/phone_auth/sign_in_with_phone.dart';
import 'package:firebase_practice/Services/notification_services.dart';
import 'package:flutter/material.dart';

import 'Screen/email_auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Notification Services
  await NotificationServices.initialize();

  // firebase fire store data fetching
  // DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("users").doc("HaJbEG06tri3MvlV8Kdf").get();
  // print(snapshot.data().toString());

  // Map<String, dynamic> newUserData = {
  //   "name" : "Tuhin",
  //   "email" : "tuhin@gmail.com"
  // };
  //
  // await FirebaseFirestore.instance.collection("users").doc("Your-id-hear").update({
  //   "email" : "efrantuhin@gmail.com"
  // });
  // print("New user save");

  // delete
  // await FirebaseFirestore.instance.collection("users").doc("wAe2XL9tmks8WSyoW1on").delete();



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: (FirebaseAuth.instance.currentUser != null) ? HomeScreen() : SingInWithPhone(),
    );
  }
}
