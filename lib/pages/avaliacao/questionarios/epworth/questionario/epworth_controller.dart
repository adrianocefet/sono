import 'package:flutter/material.dart';
import 'package:sono/pages/avaliacao/questionarios/epworth/resultado/resultado_epworth.dart';
import 'package:sono/utils/bases_questionarios/base_epworth.dart';
import 'package:sono/utils/helpers/resposta_widget.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';

class EpworthController {
  EpworthController(this.paciente);

  final Paciente paciente;
  final List<Pergunta> _perguntas =
      baseEpworth.map((e) => Pergunta.pelaBase(e)).toList();

  final PageController pageViewController = PageController();
  final formKey = GlobalKey<FormState>();

  List<Widget> get listaDePaginas => [
        for (Pergunta pergunta in _perguntas)
          RespostaWidget(
            pergunta,
            notifyParent: passarParaProximaPagina,
          )
      ];

  ResultadoEpworth get resultado {
    return ResultadoEpworth(_perguntas);
  }

  Future<void> passarParaProximaPagina() async {
    await pageViewController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }

  Future<void> passarParaPaginaAnterior() async {
    await pageViewController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }
}
