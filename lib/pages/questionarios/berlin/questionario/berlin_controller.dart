import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sono/utils/bases_questionarios/base_berlin.dart';
import 'package:sono/utils/helpers/resposta_widget.dart';
import 'package:sono/utils/models/pergunta.dart';

class BerlinController {
  final List<Pergunta> _perguntas =
      baseBerlin.map((e) => Pergunta.pelaBase(e)).toList();

  final List<String> _codigosPerguntasCondicionais = [
    "seu_ronco",
    "frequencia_ronco",
    "incomodou",
  ];

  int tamanhoListaDeRespostas = 0;
  List<RespostaWidget> listaDeRespostas = [];
  List<Pergunta> get listaDePerguntas => _perguntas;

  int obterPaginaDaQuestaoNaoRespondida(List<Widget> listaDeRespostas) {
    return listaDeRespostas.indexOf(
      listaDeRespostas.firstWhere(
        (element) {
          if (element.runtimeType == Column) {
            return (element as Column).children.any(
              (pergunta) {
                return pergunta.runtimeType == RespostaWidget
                    ? (pergunta as RespostaWidget).pergunta.resposta == null
                    : false;
              },
            );
          } else {
            Pergunta pergunta = (element as RespostaWidget).pergunta;
            return pergunta.tipo == TipoPergunta.extensoNumerico
                ? pergunta.respostaExtenso == null
                : pergunta.resposta == null;
          }
        },
      ),
    );
  }

  List<RespostaWidget> gerarListaDeRespostas(
      context, Future<void> Function() passarPagina) {
    listaDeRespostas = [
      for (Pergunta pergunta in listaDePerguntas)
        RespostaWidget(
          pergunta,
          notifyParent: passarPagina,
        ),
    ];

    Pergunta perguntaVoceRonca = listaDePerguntas
        .firstWhere((pergunta) => pergunta.codigo == "voce_ronca");

    if (perguntaVoceRonca.resposta == 0) {
      _removerPerguntasCondicionaisDaListaDeRespostas();
    }

    tamanhoListaDeRespostas = listaDeRespostas.length;

    return listaDeRespostas;
  }

  void _removerPerguntasCondicionaisDaListaDeRespostas() {
    _zerarRespostasDasPerguntasCondicionais();

    listaDeRespostas.removeWhere(
      (resposta) =>
          _codigosPerguntasCondicionais.contains((resposta).pergunta.codigo),
    );
  }

  void _zerarRespostasDasPerguntasCondicionais() {
    _perguntas
        .where(
          (pergunta) =>
              _codigosPerguntasCondicionais.contains(pergunta.codigo) &&
              pergunta.resposta != 0,
        )
        .forEach(
          (pergunta) => pergunta.setResposta(0),
        );
  }

  ResultadoBerlin? validarFormulario(GlobalKey<FormState> formKey) {
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
      return ResultadoBerlin(_perguntas);
    }

    return null;
  }
}

class ResultadoBerlin {
  final List<Pergunta> perguntas;

  Map<String, dynamic> respostasPorPergunta = {};

  Map<String, int> pontuacoesPorCategoria = {
    "categoria_1": 0,
    "categoria_2": 0,
    "categoria_3": 0,
  };

  Map<String, bool> resultadosPorCategoria = {
    "categoria_1": false,
    "categoria_2": false,
    "categoria_3": false,
  };

  double? imc;

  ResultadoBerlin(this.perguntas) {
    _gerarResultadoDoQuestionario();
  }

  void _gerarResultadoDoQuestionario() {
    for (Pergunta pergunta in perguntas) {
      if (pergunta.dominio != "inicial") {
        int pontuacaoNaCategoria = pontuacoesPorCategoria[pergunta.dominio]!;
        pontuacoesPorCategoria[pergunta.dominio] =
            pontuacaoNaCategoria + pergunta.resposta!;
      }
    }

    for (MapEntry<String, int> pontuacao in pontuacoesPorCategoria.entries) {
      if (pontuacao.key == "categoria_3") {
        if (pontuacao.value >= 1 || _calcularIMC > 30) {
          resultadosPorCategoria[pontuacao.key] = true;
          imc = _calcularIMC;
        }
      } else {
        if (pontuacao.value >= 2) resultadosPorCategoria[pontuacao.key] = true;
      }
    }

    for (Pergunta pergunta in perguntas) {
      respostasPorPergunta[pergunta.codigo] =
          pergunta.tipo != TipoPergunta.extensoNumerico
              ? pergunta.resposta
              : pergunta.respostaExtenso;
    }
  }

  double get _calcularIMC {
    double peso = double.parse(
      perguntas
          .firstWhere((element) => element.codigo == "peso")
          .respostaExtenso!
          .replaceAll(",", "."),
    );

    double altura = double.parse(
      perguntas
          .firstWhere((element) => element.codigo == "altura")
          .respostaExtenso!
          .replaceAll(",", "."),
    );

    return peso / (altura * altura);
  }
}
