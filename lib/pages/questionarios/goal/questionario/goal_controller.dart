import 'package:flutter/material.dart';
import 'package:sono/utils/bases_questionarios/base_goal.dart';
import '../../../../utils/helpers/resposta_widget.dart';
import '../../../../utils/models/pergunta.dart';

class GOALController {
  final List<Pergunta> _perguntas =
      baseGOAL.map((e) => Pergunta.pelaBase(e)).toList();

  List<RespostaWidget> listaDeRespostas = [];
  List<Pergunta> get listaDePerguntas => _perguntas;

  List<RespostaWidget> gerarListaDeRespostas(
      context, Future<void> Function() passarPagina) {
    listaDeRespostas = [
      for (Pergunta pergunta in listaDePerguntas)
        RespostaWidget(
          pergunta,
          notifyParent: passarPagina,
        ),
    ];

    return listaDeRespostas;
  }

  ResultadoGOAL? validarFormulario(GlobalKey<FormState> formKey) {
    bool respostasEstaoValidas = formKey.currentState!.validate();

    if (respostasEstaoValidas) formKey.currentState!.save();

    if (respostasEstaoValidas) {
      return ResultadoGOAL(_perguntas);
    }

    return null;
  }
}

class ResultadoGOAL {
  final List<Pergunta> perguntas;
  late final int pontuacao;
  late final bool resultado;

  ResultadoGOAL(this.perguntas) {
    pontuacao = perguntas.where((element) => element.resposta == 1).length;
    resultado = pontuacao >= 2 ? true : false;
  }
}
