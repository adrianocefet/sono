import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/user_model.dart';

Future<Paciente?> mostrarDialogEscolherPaciente(context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Escolher Paciente'),
      content: SizedBox(
        width: 400,
        height: 200,
        child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Paciente')
                  .where('Hospital', isEqualTo: model.hospital)
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return GridView(
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      scrollDirection: Axis.vertical,
                      children: snapshot.data!.docs.reversed.map(
                        (DocumentSnapshot document) {
                          Paciente paciente =
                              Paciente.porDocumentSnapshot(document);
                          return FittedBox(
                            fit: BoxFit.fitHeight,
                            child: InkWell(
                              onTap: () {
                                // map_equipamento['ID do Status'] = id;
                                // print(map_equipamento.toString());
                                Navigator.pop(context, paciente);
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Image.network(
                                    paciente.urlFotoDePerfil ?? model.semimagem,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    paciente.nome,
                                    //style: TextStyle(fontSize: 30,),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    );
                }
              },
            );
          },
        ),
      ),
    ),
  );
}

Widget _fazGrid(BuildContext context, String imagem, String texto, String id) {
  return InkWell(
    onTap: () {
      // map_equipamento['ID do Status'] = id;
      // print(map_equipamento.toString());
      Navigator.pop(context, id);
    },
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.network(
          imagem,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        Text(
          texto,
          //style: TextStyle(fontSize: 30,),
        )
      ],
    ),
  );
}

// _fazGrid(
//                           context,
//                           paciente.urlFoto ?? model.semimagem,
//                           paciente.nome,
//                           document.id,
//                         );