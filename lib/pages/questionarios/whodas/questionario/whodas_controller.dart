import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/questionarios/whodas/questionario/widgets/enunciado_dominio.dart.dart';
import 'package:sono/pages/questionarios/whodas/questionario/widgets/resposta_ativ_trab.dart';
import 'package:sono/utils/bases_questionarios/base_whodas.dart';
import 'package:sono/utils/models/pergunta.dart';
import '../../../../utils/helpers/resposta_widget.dart';
import '../../../../utils/models/paciente.dart';
import '../resultado/resultado_whodas.dart';
import 'widgets/enunciado_secao.dart';

class WHODASController {
  Paciente paciente;
  WHODASController(this.paciente);

  final formKey = GlobalKey<FormState>();
  final List<Pergunta> _perguntas =
      baseWHODAS.map((e) => Pergunta.pelaBase(e)).toList();

  PageController pageViewController = PageController();
  List<Widget> listaDePaginas = [];
  bool q501habilitada = false;
  bool q502habilitada = false;
  Map<String, bool> estadosDosDominios = {
    "dom_1": true,
    "dom_2": true,
    "dom_3": true,
    "dom_4": true,
    "dom_51": true,
    "dom_52": true,
    "dom_6": true,
  };

  List<Pergunta> get listaDePerguntas => _perguntas;
  String tituloSecaoAtual(Pergunta? perguntaAtual) {
    switch (perguntaAtual?.codigo.toString()[0]) {
      case "n":
      case "F":
        return "\nFolha De Rosto";
      case "A":
        return "\nInformações gerais e demográficas";
      case "D":
        return "\nRevisão dos domínios";
      case "H":
        return "\nConclusão";
      default:
        return "";
    }
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

  List<Widget> gerarListaDePaginas(void Function() questionarioSetState) {
    listaDePaginas = [];
    String dominioAtual = "";

    for (Pergunta pergunta in listaDePerguntas) {
      if (dominioAtual != pergunta.dominio) {
        dominioAtual = pergunta.dominio;
        if (dominioAtual == "dom_1") {
          listaDePaginas.addAll(
            [
              const EnunSecao(indiceSecao: 3),
              EnunDominio(
                questionarioSetState: questionarioSetState,
                dominio: pergunta.dominio,
                controller: this,
              ),
            ],
          );
        } else if (dominioAtual != "") {
          listaDePaginas.add(
            EnunDominio(
              questionarioSetState: questionarioSetState,
              dominio: pergunta.dominio,
              controller: this,
            ),
          );
        }
      }

      listaDePaginas.add(
        pergunta.codigo == "A5"
            ? RespostaAtividadeTrabalho(
                pergunta: pergunta,
                passarPagina: passarParaProximaPagina,
                formKey: formKey,
              )
            : RespostaWidget(
                pergunta,
                notifyParent: passarParaProximaPagina,
                autoPreencher: _autoPreencher(pergunta, paciente),
              ),
      );
    }

    listaDePaginas.insert(
      listaDePaginas.indexWhere((resposta) =>
              resposta.runtimeType == RespostaWidget &&
              (resposta as RespostaWidget).pergunta.codigo == "F1") -
          1,
      const EnunSecao(indiceSecao: 0),
    );

    listaDePaginas.insert(
      listaDePaginas.indexWhere((resposta) =>
          resposta.runtimeType == RespostaWidget &&
          (resposta as RespostaWidget).pergunta.codigo == "A1"),
      const EnunSecao(indiceSecao: 1),
    );

    listaDePaginas.insert(
      listaDePaginas.indexWhere(
              (resposta) => resposta.runtimeType == RespostaAtividadeTrabalho) +
          1,
      const EnunSecao(indiceSecao: 2),
    );

    _filtrarPerguntasCondicionais();
    _removerPerguntasDeDominiosNaoAplicaveis();

    return listaDePaginas;
  }

  ResultadoWHODAS? validarFormulario(GlobalKey<FormState> formKey) {
    bool respostasEstaoValidas = formKey.currentState!.validate();

    if (respostasEstaoValidas) formKey.currentState!.save();

    if (respostasEstaoValidas) {
      return ResultadoWHODAS(_perguntas);
    }

    return null;
  }

  void desabilitarDominio(bool remover, String codigoDominio) {
    if (remover) {
      for (Pergunta pergunta in listaDePerguntas) {
        if (pergunta.dominio == codigoDominio) {
          pergunta.resposta =
              pergunta.opcoes == null ? 0 : pergunta.opcoes!.length - 1;
          pergunta.respostaExtenso = pergunta.opcoes?.last;
        }
      }

      estadosDosDominios[codigoDominio] = false;
    } else {
      for (Pergunta pergunta in listaDePerguntas) {
        if (pergunta.dominio == codigoDominio) {
          pergunta.resposta = null;
          pergunta.respostaExtenso = null;
        }
      }

      estadosDosDominios[codigoDominio] = true;
    }
  }

  void _removerPerguntasDeDominiosNaoAplicaveis() {
    listaDePaginas.removeWhere(
      (pagina) =>
          pagina.runtimeType == RespostaWidget &&
          estadosDosDominios[(pagina as RespostaWidget).pergunta.dominio] ==
              false,
    );
  }

  void _filtrarPerguntasCondicionais() {
    _verificarRequisitosParaPerguntasCondicionais();
    if (!q501habilitada) {
      listaDePaginas.removeWhere(
        (pagina) =>
            pagina.runtimeType == RespostaWidget &&
            (pagina as RespostaWidget).pergunta.codigo == "D5.01",
      );
    }

    if (!q502habilitada) {
      listaDePaginas.removeWhere(
        (pagina) =>
            pagina.runtimeType == RespostaWidget &&
            (pagina as RespostaWidget).pergunta.codigo == "D5.02",
      );
    }
  }

  void _verificarRequisitosParaPerguntasCondicionais() {
    if (listaDePerguntas
        .where((pergunta) =>
            pergunta.dominio == "dom_51" &&
            !["D5.1", "D5.5"].contains(pergunta.codigo))
        .any(
          (pergunta) => ![0, 5].contains(pergunta.resposta) == false,
        )) {
      q501habilitada = false;
    } else {
      q501habilitada = true;
    }

    if (listaDePerguntas
        .where((pergunta) =>
            pergunta.dominio == "dom_52" &&
            !["D5.9", "D5.10"].contains(pergunta.codigo))
        .any(
          (pergunta) => ![0, 5].contains(pergunta.resposta) == false,
        )) {
      q502habilitada = false;
    } else {
      q502habilitada = true;
    }
  }

  dynamic _autoPreencher(Pergunta pergunta, Paciente paciente) {
    switch (pergunta.codigo) {
      case "nome":
        return paciente.nome;
      case "F4":
        return DateFormat("dd/MM/yyyy").format(DateTime.now());
      case "A2":
      case "A3":
        return "30";
      default:
        return null;
    }
  }
}
