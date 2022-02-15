import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pagina_inicial/widgets/widgets_drawer.dart';

class Fale extends StatefulWidget {
  final PageController pageController;
  const Fale({Key? key, required this.pageController}) : super(key: key);

  @override
  _FaleState createState() => _FaleState();
}

class _FaleState extends State<Fale> {
  //String adriano = 'text';

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Fale conosco"),
          centerTitle: true,
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection("faleconosco").get(),
          //FirebaseFirestore.instance.collection('messages').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              var dividedTiles = ListTile.divideTiles(
                      tiles: snapshot.data!.docs.map((doc) {
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                                //snapshot.data["icon"] ??
                                'https://img.freepik.com/fotos-gratis/imagem-aproximada-em-tons-de-cinza-de-uma-aguia-careca-americana-em-um-fundo-escuro_181624-31795.jpg'),
                          ),
                          title: Text(
                              // snapshot.data["title"] ??
                              'sem texto'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {},
                        );
                      }).toList(),
                      color: Colors.grey[500])
                  .toList();

              return ListView(
                children: dividedTiles,
              );
            }
          },
        ),
        drawer: CustomDrawer(widget.pageController),
        drawerEnableOpenDragGesture: true,
      );
    });
  }
}
