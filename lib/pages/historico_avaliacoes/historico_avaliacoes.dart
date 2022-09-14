import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sono/pages/historico_avaliacoes/widgets/item_avaliacao_antiga.dart';
import 'package:sono/utils/models/avaliacao.dart';
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
        title: const Text("Histórico de Avaliações"),
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
          stream:
              FirebaseService().streamAvaliacoesPorIdDoPaciente(paciente.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Avaliacao> avaliacoesSemExames = snapshot.data!.docs
                  .map(
                    (e) => Avaliacao(
                      examesRealizados: [],
                      id: e.id,
                      idAvaliador: e.data()['id_avaliador'],
                      dataDaAvaliacao: e.data()['data_de_realizacao'],
                    ),
                  )
                  .toList();
              avaliacoesSemExames.sort(
                (a, b) => b.dataDaAvaliacao.compareTo(a.dataDaAvaliacao),
              );
              return Scrollbar(
                scrollbarOrientation: ScrollbarOrientation.left,
                child: ListView(
                  children: avaliacoesSemExames
                      .map(
                        (e) => ItemAvaliacaoAntiga(
                          avaliacaoSemExames: e,
                          paciente: paciente,
                        ),
                      )
                      .toList(),
                ),
              );
            } else if (snapshot.hasError) {
              return Expanded(
                child: Center(
                  child: Text(
                    "Erro ao acessar as avaliações do paciente!",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              );
            } else {
              return const Expanded(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
