import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Equipamento extends StatefulWidget {
  const Equipamento({Key? key}) : super(key: key);

  @override
  _EquipamentoState createState() => _EquipamentoState();
}

class _EquipamentoState extends State<Equipamento> {
  String semimagem = 'https://firebasestorage.googleapis.com/v0/b/sono-ufc.appspot.com/o/sem.jpg?alt=media&token=b31fdc7d-88a2-4781-85bb-a06a2fb04a64';

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('Equipamento')
                .where('Hospital',isEqualTo: model.hospital)
                .where('Equipamento',isEqualTo:'Equipamento')
                .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return GridView(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                scrollDirection: Axis.vertical,
                children: snapshot.data!.docs.reversed
                    .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return FazGrid(
                      data['Imagem'] ?? semimagem,
                      data['Nome'] ?? 'sem nome'
                  );
                }).toList(),
              );
          }
        },
      );
    });
  }

  Widget FazGrid(String imagem, String texto) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.network(
          imagem,
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.width * 0.25,
          fit: BoxFit.cover,
        ),
        Text(
          texto,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03,),
        )
      ],
    );
  }
}
