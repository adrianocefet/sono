import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/usuario.dart';
import '../../../../constants/constants.dart';
import '../../perfis/perfil_equipamento/equipamento_controller.dart';
import 'item_equipamento.dart';

class PesquisaEquipamento extends SearchDelegate {
  final ControllerPerfilClinicoEquipamento controller;
  final TipoEquipamento tipo;
  final StatusDoEquipamento status;
  PesquisaEquipamento({required this.controller,required this.tipo, required this.status});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ScopedModelDescendant<Usuario>(
      builder: (context, child, model) => StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('equipamentos')
              .where('hospital', isEqualTo: model.instituicao.emString)
              .where('status', isEqualTo: controller.status.emString)
              .where('tipo', isEqualTo: controller.tipo.emStringSnakeCase)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                return Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Color.fromARGB(255, 194, 195, 255),
                        Colors.white
                      ],
                          stops: [
                        0,
                        0.4
                      ])),
                  child: snapshot.data!.docs
                          .where((QueryDocumentSnapshot<Object?> element) =>
                              removeDiacritics(element['nome'])
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      removeDiacritics(query).toLowerCase()))
                          .isNotEmpty
                      ? ListView(
                          children: snapshot.data!.docs
                              .where((QueryDocumentSnapshot<Object?> element) =>
                                  removeDiacritics(element['nome'])
                                      .toString()
                                      .toLowerCase()
                                      .contains(removeDiacritics(query)
                                          .toLowerCase()))
                              .map(
                            (QueryDocumentSnapshot<Object?> document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ItemEquipamento(id: document.id,controller: controller,),
                              );
                            },
                          ).toList(),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.cancel,
                                  size: 80.0,
                                  color: Constantes.corAzulEscuroPrincipal,
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                Text(
                                  '"${query}" não encontrado!',
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Constantes.corAzulEscuroPrincipal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                );
            }
          }),
    );
  }

  /* List<Widget> itensEquipamento(List<Equipamento> equipamentos)=> 
    equipamentos.where((equipamento) => equipamento.nome.toLowerCase().contains(query.toLowerCase())&&tipo==equipamento.tipo&&status==Constantes.status2.indexOf(equipamento.status)).isNotEmpty?
    equipamentos.map((Equipamento equipamento) {
      return tipo==equipamento.tipo&&status==Constantes.status2.indexOf(equipamento.status)&&equipamento.nome.toLowerCase().contains(query.toLowerCase())?Padding(
        padding: const EdgeInsets.symmetric(horizontal:8.0),
        child: ItemEquipamento(equipamento: equipamento),
      ):Container();
    }).toList():[
        Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.search_off,
                      size: 80.0,
                      color: Constantes.corAzulEscuroPrincipal,
                    ),
                    SizedBox(height: 16.0,),
                    Text(
                      'Equipamento não encontrado!',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Constantes.corAzulEscuroPrincipal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
      
      ]; */

}
