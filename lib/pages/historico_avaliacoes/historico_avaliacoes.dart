import 'package:flutter/material.dart';
import 'package:sono/pages/historico_avaliacoes/widgets/item_avaliacao_antiga.dart';
import 'package:sono/utils/models/paciente.dart';

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
        child: Scrollbar(
          scrollbarOrientation: ScrollbarOrientation.left,
          child: ListView(
            children: paciente.avaliacoes!
                .map(
                  (e) => ItemAvaliacaoAntiga(
                    avaliacao: e,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
