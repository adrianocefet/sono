import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sono/pages/avaliacao/avaliacao.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/services/firebase.dart';

class HistoricoDeAvaliacoes extends StatelessWidget {
  final Paciente paciente;
  const HistoricoDeAvaliacoes({Key? key, required this.paciente})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Avaliação"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromRGBO(165, 166, 246, 1.0), Colors.white],
            stops: [0, 0.2],
          ),
        ),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseService().streamAvaliacoesPorIdDoPaciente(paciente.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: const [],
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
