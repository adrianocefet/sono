import 'package:chat/text_composer.dart';
import 'package:flutter/material.dart';

//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

//execute "flutter pub add firebase_storage"
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';



class chatScreen extends StatefulWidget {
  const chatScreen({Key? key}) : super(key: key);

  @override

  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  Map teste = {'adri': 'text'};
  void _sendMenssage({String? text, XFile? imgFile}) async {
    Map<String, dynamic> data = {};
    if (imgFile != null) {
      File largeFile = File(imgFile.path);

      firebase_storage.UploadTask task = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(largeFile);

      firebase_storage.TaskSnapshot taskSnapshot = await task;
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imgUrl'] = url;
    }

    if (text != null) data['text'] = text;

    FirebaseFirestore.instance.collection('messages').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('olá'),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('messages').snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return ListView(
                      reverse: true,
                      children: snapshot.data!.docs.reversed.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        return ListTile(
                          leading: Icon(Icons.account_circle),
                          title: Text(data['text'] ?? 'sem texto',
                              style: Theme.of(context).textTheme.headline6),
                          subtitle: Text(data['imgUrl'] ?? 'sem imagem'),
                          trailing: Text(data.length.toString()),
                        );
                      }).toList(),
                    );
                 }
              },
            ),
          ),
          TextComposer(_sendMenssage),
        ],
      ),
    );
  }
}
