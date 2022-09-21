import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/tabelas/widgets/item_paciente.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:sono/utils/services/firebase.dart';

class PesquisaDePacientes extends SearchDelegate {
  final String identificador;
  final String hospital;
  PesquisaDePacientes(this.identificador, this.hospital);

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
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) =>
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseService().streamPacientesPorHospital(model.hospital),
        builder: (context, snapshot) {
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
                        .where((QueryDocumentSnapshot<Map<String, dynamic>>
                                element) =>
                            removeDiacritics(element['nome_completo'])
                                .toString()
                                .toLowerCase()
                                .contains(
                                    removeDiacritics(query).toLowerCase()))
                        .isNotEmpty
                    ? ListView(
                        children: snapshot.data!.docs
                            .where((QueryDocumentSnapshot<Object?> element) =>
                                removeDiacritics(element['nome_completo'])
                                    .toString()
                                    .toLowerCase()
                                    .contains(
                                        removeDiacritics(query).toLowerCase()))
                            .map(
                          (QueryDocumentSnapshot<Map<String, dynamic>>
                              document) {
                            Paciente paciente =
                                Paciente.porDocumentSnapshot(document);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ItemPaciente(paciente: paciente),
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
        },
      ),
    );
  }
}
