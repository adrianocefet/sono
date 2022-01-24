import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sono/pages/screen_paciente.dart';

class Paciente extends StatefulWidget {
  const Paciente({Key? key}) : super(key: key);

  @override
  _PacienteState createState() => _PacienteState();
}

class _PacienteState extends State<Paciente> {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('Paciente')
                .where('Hospital',isEqualTo: model.hospital)
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
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return FazGrid(
                      data['Foto'] ?? model.semimagem,
                      data['Nome'] ?? 'sem nome',
                      document.id
                  );
                }).toList(),
              );
          }
        },
      );
    });
  }

  Widget FazGrid(String imagem, String texto, String id) {
    return InkWell(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ScreenPaciente(id))
        );
      },
      child: Column(
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
    ),
    );
  }
}
