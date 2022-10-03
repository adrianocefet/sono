import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/perfis/perfil_equipamento/equipamento_controller.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/usuario.dart';

Future<Paciente?> mostrarDialogEscolherPaciente(BuildContext context) async {
  ControllerPerfilClinicoEquipamento controller = ControllerPerfilClinicoEquipamento();
  return await showDialog<Paciente>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Material(
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(17),
                        topRight: Radius.circular(17),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: const Center(
                      child: Text(
                        'Selecione o paciente',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 400,
                    height: 200,
                    child: ScopedModelDescendant<Usuario>(
                      builder: (context, child, model) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('pacientes')
                              .where('hospitais_vinculados',
                                  arrayContains: model.instituicao.emString)
                              .snapshots(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              default:
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView(
                                    padding: EdgeInsets.zero,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1,
                                    ),
                                    scrollDirection: Axis.vertical,
                                    children: snapshot.data!.docs.reversed.map(
                                      (DocumentSnapshot document) {
                                        Paciente paciente =
                                            Paciente.porDocumentSnapshot(
                                                document as DocumentSnapshot<
                                                    Map<String, dynamic>>);
                                        return FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                backgroundColor: Colors.white),
                                            onPressed: () {
                                              // map_equipamento['ID do Status'] = id;
                                              // print(map_equipamento.toString());
                                              Navigator.pop(context, paciente);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      child: CircleAvatar(
                                                        radius: 25,
                                                        backgroundImage:
                                                            NetworkImage(
                                                          paciente.urlFotoDePerfil ??
                                                              controller.semimagemPaciente,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8.0),
                                                      child: ConstrainedBox(
                                                          constraints: BoxConstraints(
                                                              minWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.15,
                                                              maxWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.15),
                                                          child: Text(
                                                            paciente
                                                                .nomeCompleto,
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.03,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: Colors
                                                                    .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
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