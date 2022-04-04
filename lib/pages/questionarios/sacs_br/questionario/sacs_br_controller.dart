import 'package:flutter/material.dart';
import 'package:sono/utils/bases_questionarios/base_sacs_br.dart';

import '../../../../utils/helpers/resposta_widget.dart';
import '../../../../utils/models/pergunta.dart';

class SacsBRController {
  final List<Pergunta> _perguntas =
      baseSacsBR.map((e) => Pergunta.pelaBase(e)).toList();

  int get tamanhoListaDeRespostas => listaDeRespostas.length;
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

  ResultadoSACSBR? validarFormulario(GlobalKey<FormState> formKey) {
    bool respostasEstaoValidas = formKey.currentState!.validate();

    if (respostasEstaoValidas) formKey.currentState!.save();

    bool respostasNaoEstaoNulas = !_perguntas.any(
      (element) {
        return element.tipo == TipoPergunta.extensoNumerico
            ? element.respostaExtenso == null
            : element.resposta == null;
      },
    );

    if (respostasNaoEstaoNulas && respostasEstaoValidas) {
      return ResultadoSACSBR(_perguntas);
    }

    return null;
  }
}

class ResultadoSACSBR {
  late final List<Pergunta> perguntas;

  late final bool comHAS;
  late final int valorFrequenciaDeRonco;
  late final int valorFrequenciaEngasgo;
  late final double circunferenciaDoPescoco;
  late final List<List<int>> matrixDeResultado;

  late final int pontuacao;

  ResultadoSACSBR(this.perguntas) {
    comHAS = perguntas.first.resposta == 1 ? true : false;

    valorFrequenciaDeRonco = perguntas
        .firstWhere((element) => element.codigo == "freq_ronco")
        .resposta!;

    valorFrequenciaEngasgo = perguntas
        .firstWhere((element) => element.codigo == "freq_engasgo_ou_sufoco")
        .resposta!;

    circunferenciaDoPescoco = double.parse(
      perguntas.last.respostaExtenso!,
    );

    matrixDeResultado = comHAS ? previsaoDeSAOSComHAS : previsaoDeSAOSSemHAS;

    pontuacao = _gerarResultadoDoQuestionario();
  }

  ResultadoSACSBR.porMapa(Map<String, dynamic> mapa) {
    perguntas = baseSacsBR.map((e) => Pergunta.pelaBase(e)).toList();

    for (Pergunta pergunta in perguntas) {
      if ([int, null].contains(mapa[pergunta.codigo].runtimeType)) {
        pergunta.resposta = mapa[pergunta.codigo];
      }
      pergunta.respostaExtenso = mapa[pergunta.codigo].runtimeType == String
          ? mapa[pergunta.codigo]
          : null;
    }

    pontuacao = mapa["pontuacao"];
  }

  String get resultadoEmString {
    return pontuacao > 15
        ? "Alta probabilidade de SAOS!"
        : "Baixa probabilidade de SAOS!";
  }

  int _gerarResultadoDoQuestionario() {
    int colunaDaMatrizDeResultado =
        valorFrequenciaDeRonco + valorFrequenciaEngasgo;

    if (circunferenciaDoPescoco < 30) {
      return matrixDeResultado.first[colunaDaMatrizDeResultado];
    } else if (circunferenciaDoPescoco > 49) {
      return matrixDeResultado.last[colunaDaMatrizDeResultado];
    } else {
      int linhaDaMatrixDeResultado = (circunferenciaDoPescoco - 30) ~/ 2 + 1;
      return matrixDeResultado[linhaDaMatrixDeResultado]
          [colunaDaMatrizDeResultado];
    }
  }

  Map<String, dynamic> get mapaDeRespostasEPontuacao {
    Map<String, dynamic> mapa = {};

    for (Pergunta pergunta in perguntas) {
      mapa[pergunta.codigo] = pergunta.respostaExtenso ?? pergunta.resposta;
    }

    mapa["pontuacao"] = pontuacao;

    return mapa;
  }
}
