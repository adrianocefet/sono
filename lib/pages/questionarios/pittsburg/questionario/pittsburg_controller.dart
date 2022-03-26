import 'package:flutter/material.dart';
import 'package:sono/pages/questionarios/pittsburg/questionario/widgets/multipla_custom_pittsburg.dart';
import 'package:sono/pages/questionarios/pittsburg/questionario/widgets/resposta_horario_pittsburg.dart';
import 'package:sono/pages/questionarios/pittsburg/resultado/resultado_pittsburg.dart';
import 'package:sono/pages/questionarios/widgets/enunciado_respostas.dart';
import 'package:sono/utils/bases_questionarios/base_pittsburg.dart';
import 'package:sono/utils/helpers/resposta_widget.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';

class PittsburgController {
  PittsburgController(this.paciente);
  final Paciente paciente;

  final formKey = GlobalKey<FormState>();
  final List<Pergunta> _perguntas =
      basePittsburg.map((e) => Pergunta.pelaBase(e)).toList();

  PageController pageViewController = PageController();
  List<Widget> listaDePaginas = [];

  Future<void> passarParaProximaPagina(
      void Function() questionarioSetState) async {
    questionarioSetState();

    if (pageViewController.position.pixels !=
        pageViewController.position.maxScrollExtent) {
      await pageViewController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    }
  }

  Future<void> passarParaPaginaAnterior() async {
    await pageViewController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }

  List<Widget> gerarListaDePaginas(void Function() questionarioSetState) {
    listaDePaginas = [];

    for (Pergunta pergunta in _perguntas) {
      listaDePaginas.add(
        ["10I", "5J"].contains(pergunta.codigo)
            ? MultiplaCustomizadaPittsburg(
                pergunta: pergunta,
                passarPagina: () =>
                    passarParaProximaPagina(questionarioSetState),
              )
            : ["1", "3"].contains(pergunta.codigo)
                ? RespostaHorarioPittsburg(
                    pergunta,
                    passarPagina: () =>
                        passarParaProximaPagina(questionarioSetState),
                  )
                : RespostaWidget(
                    pergunta,
                    notifyParent: () =>
                        passarParaProximaPagina(questionarioSetState),
                  ),
      );
    }

    _inserirEnunciado("1");
    _inserirEnunciado("5A");
    _inserirEnunciado("10E");

    _filtrarPerguntasCondicionais();

    return listaDePaginas;
  }

  ResultadoPittsburg? validarFormulario() {
    bool respostasEstaoValidas = formKey.currentState!.validate();

    if (respostasEstaoValidas) formKey.currentState!.save();

    if (respostasEstaoValidas) {
      return ResultadoPittsburg(_perguntas);
    }

    return null;
  }

  void _filtrarPerguntasCondicionais() {
    if (_perguntas.firstWhere((element) => element.codigo == "10").resposta ==
        0) {
      listaDePaginas.removeRange(
        listaDePaginas.indexWhere(
              (element) =>
                  element.runtimeType == RespostaWidget &&
                  (element as RespostaWidget).pergunta.codigo == "10",
            ) +
            1,
        listaDePaginas.length,
      );

      for (Pergunta pergunta in _perguntas.where(
        (element) => element.dominio == "10" && element.codigo != "10",
      )) {
        pergunta.setResposta(0);
        pergunta.setRespostaExtenso("");
      }
    }
  }

  void _inserirEnunciado(String keyEnunciado) {
    int indice = listaDePaginas.indexWhere((element) =>
        element.runtimeType != EnunciadoRespostasDeQuestionarios &&
        (element as dynamic).pergunta.codigo == keyEnunciado);

    listaDePaginas.insert(
      indice,
      EnunciadoRespostasDeQuestionarios(
          enunciado: enunciadosPittsburg[keyEnunciado]!),
    );
  }
}
