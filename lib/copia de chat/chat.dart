import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  runApp(const MyApp());
  FirebaseApp defaultApp = await Firebase.initializeApp();
  FirebaseFirestore.instance.collection("col").doc("doc").set({"texto": "daniel"});
  //Firestore.instance.collection("col").document("doc").setData({"texto": "daniel"})
  QuerySnapshot snapshot =
  await FirebaseFirestore.instance.collection("mensagens").get();
  snapshot.docs.forEach((d) {
    print(d.data);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(),
    );
  }
}


