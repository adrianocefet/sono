import 'dart:math';

import '../../../../utils/models/pergunta.dart';

class ResultadoWHODAS {
  Map<String, dynamic> resultado = {};
  num _somaPontuacaoTotal = 0;
  num _somaPesosMaxTotal = 0;

  ResultadoWHODAS(List<Pergunta> perguntas) {
    _gerarResultadoDoFormulario(perguntas);
  }

  Map<String, dynamic> _gerarResultadoDoFormulario(perguntas) {
    Map<String, dynamic> pontuacaoDominios = {
      'dom_1': gerarPontuacaoDominio(
              perguntas.where((element) => element.dominio == "dom_1").toList())
          ?.ceil(),
      'dom_2': gerarPontuacaoDominio(
              perguntas.where((element) => element.dominio == "dom_2").toList())
          ?.ceil(),
      'dom_3': gerarPontuacaoDominio(
              perguntas.where((element) => element.dominio == "dom_3").toList())
          ?.ceil(),
      'dom_4': gerarPontuacaoDominio(
              perguntas.where((element) => element.dominio == "dom_4").toList())
          ?.ceil(),
      'dom_51': gerarPontuacaoDominio(perguntas
              .where(
                (element) =>
                    element.dominio == "dom_51" &&
                    element.tipo == TipoPergunta.marcar,
              )
              .toList())
          ?.ceil(),
      'dom_52': gerarPontuacaoDominio(perguntas
              .where(
                (element) =>
                    element.dominio == "dom_52" &&
                    element.tipo == TipoPergunta.marcar,
              )
              .toList())
          ?.ceil(),
      'dom_6': gerarPontuacaoDominio(
              perguntas.where((element) => element.dominio == "dom_6").toList())
          ?.ceil(),
      'total': _somaPontuacaoTotal < 0
          ? 0
          : (_somaPontuacaoTotal / _somaPesosMaxTotal * 100).ceil(),
    };

    _gerarPontuacaoPerguntasMultiplas(perguntas);
    _gerarPontuacaoPerguntasEscrever(perguntas);
    resultado.addAll(pontuacaoDominios);

    _somaPontuacaoTotal = 0;
    _somaPesosMaxTotal = 0;

    return resultado;
  }

  _gerarPontuacaoPerguntasMultiplas(List<Pergunta> perguntasMultipla) {
    for (var p in perguntasMultipla) {
      if (p.tipo == TipoPergunta.multipla ||
          p.tipo == TipoPergunta.afirmativa) {
        resultado[p.codigo] = p.resposta;
      }
    }
  }

  List<String> _gerarPontuacaoPerguntasEscrever(
      List<Pergunta> perguntasEscrever) {
    List<String> perguntas = [];
    for (var p in perguntasEscrever) {
      if (p.tipo == TipoPergunta.extenso ||
          p.tipo == TipoPergunta.extensoNumerico) {
        resultado[p.codigo] = p.respostaExtenso ?? "";
        perguntas.add(p.respostaExtenso ?? "");
      }
    }
    return perguntas;
  }

  num? gerarPontuacaoDominio(List<Pergunta> perguntas) {
    num soma = 0;
    num somaPesosMax = 0;
    num numNaoSeAplica = 0;

    for (var item in perguntas) {
      int index = item.resposta!;
      resultado[item.codigo] = item.resposta;

      num peso = item.pesos[index];
      num pesoMax = (item.pesos).reduce(max);

      soma += peso;
      _somaPontuacaoTotal += peso;

      index != (item.pesos.length - 1)
          ? () {
              somaPesosMax += pesoMax;
            }()
          : numNaoSeAplica++;
    }

    _somaPesosMaxTotal += somaPesosMax;
    return numNaoSeAplica == perguntas.length
        ? -1
        : (soma / somaPesosMax) * 100;
  }
}
