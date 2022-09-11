import 'package:flutter/material.dart';
import 'package:sono/utils/bases_questionarios/base_goal.dart';
import 'package:sono/utils/helpers/resposta_widget.dart';
import 'package:sono/utils/models/pergunta.dart';

class GOALController {
  GOALController({Map<String, dynamic>? autoPreencher}) {
    if (autoPreencher != null && autoPreencher.isNotEmpty) {
      for (Pergunta pergunta in _perguntas) {
        pergunta.respostaPadrao = autoPreencher[pergunta.codigo];
      }
    }
  }

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
  late final List<Pergunta> perguntas;
  late final int pontuacao;
  late final bool resultado;

  ResultadoGOAL(this.perguntas) {
    pontuacao =
        perguntas.where((element) => element.respostaNumerica == 1).length;
    resultado = pontuacao >= 2 ? true : false;
  }

  ResultadoGOAL.porMapa(Map<String, dynamic> mapa) {
    perguntas = baseGOAL.map((e) => Pergunta.pelaBase(e)).toList();

    for (Pergunta pergunta in perguntas) {
      if ([int, null].contains(mapa[pergunta.codigo].runtimeType)) {
        pergunta.respostaNumerica = mapa[pergunta.codigo];
      }
      pergunta.respostaExtenso = mapa[pergunta.codigo].runtimeType == String
          ? mapa[pergunta.codigo]
          : null;
    }

    pontuacao = mapa["pontuacao"];
    resultado = mapa["resultado"];
  }

  String get resultadoEmString {
    return resultado == true
        ? "Alta probabilidade de SAOS!"
        : "Baixa probabilidade de SAOS!";
  }

  Map<String, dynamic> get mapaDeRespostasEPontuacao {
    Map<String, dynamic> mapa = {};

    for (Pergunta pergunta in perguntas) {
      mapa[pergunta.codigo] = pergunta.respostaPadrao;
    }

    mapa["pontuacao"] = pontuacao;
    mapa["resultado"] = resultadoEmString;

    return mapa;
  }
}
