import 'package:flutter/material.dart';
import 'package:sono/pages/avaliacao/avaliacao.dart';
import 'package:sono/pages/avaliacao/exame.dart';
import 'package:sono/pages/historico_avaliacoes/avaliacao_detalhe/widgets/exame_descritivo_detalhe.dart';
import 'package:sono/pages/historico_avaliacoes/avaliacao_detalhe/widgets/selecionar_exame_detalhe.dart';
import 'package:sono/pages/historico_avaliacoes/avaliacao_detalhe/widgets/selecionar_questionario_detalhe.dart';

class AvaliacaoEmDetalhe extends StatelessWidget {
  final Avaliacao avaliacao;
  const AvaliacaoEmDetalhe({Key? key, required this.avaliacao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Avaliação em Detalhe"),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    avaliacao.dataDaAvaliacaoFormatada,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ...avaliacao.examesRealizados
                      .where((exame) => ![
                            TipoExame.conclusao,
                            TipoExame.dadosComplementares,
                            TipoExame.questionario
                          ].contains(exame.tipo))
                      .map(
                        (e) => SelecionarExameEmDetalhe(exame: e),
                      ),
                  SelecionarQuestionarioEmDetalhe(avaliacao: avaliacao),
                  ...avaliacao.examesRealizados
                      .where((exame) => [
                            TipoExame.conclusao,
                            TipoExame.dadosComplementares
                          ].contains(exame.tipo))
                      .map(
                        (e) => ExameDescritivoDetalhe(
                          exame: e,
                          avaliacao: avaliacao,
                        ),
                      ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
