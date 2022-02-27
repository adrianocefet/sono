import 'package:flutter/material.dart';
import 'package:sono/pages/questionarios/stop_bang/questionario/widgets/resposta_afirmativa_stopbang.dart';
import 'package:sono/utils/base_perguntas/base_stopbang.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/utils/models/questionario.dart';

class StopBangController implements Questionario {
  final List<Pergunta> _perguntas = baseStopBang.map(
    (e) {
      return Pergunta(
        e['enunciado'],
        e['tipo'],
        e['pesos'],
        e['dominio'],
        e['codigo'],
        validador: e['validador'],
      );
    },
  ).toList();

  dynamic _resultado;

  List<RespostaAfirmativaStopBang> listaDeRespostas(
          Future<void> Function() passarPagina) =>
      _perguntas
          .map(
            (e) => RespostaAfirmativaStopBang(
              pergunta: e,
              passarPagina: passarPagina,
            ),
          )
          .toList();

  @override
  List<Pergunta> get listaDePerguntas => _perguntas;

  @override
  get resultado => _resultado;

  ResultadoStopBang _gerarResultadoDoQuestionario() {
    int pontuacaoDasPerguntasIniciais = 0;
    int pontuacaoTotal = 0;
    Map mapaDeRepostas = {};

    for (Pergunta pergunta in _perguntas) {
      int? resposta = pergunta.resposta;

      mapaDeRepostas[pergunta.codigo] = pergunta.resposta;

      if (_perguntas.indexOf(pergunta) <= 3) {
        pontuacaoDasPerguntasIniciais += resposta!;
      }

      pontuacaoTotal += resposta!;
    }

    // print("INICIAIS $pontuacaoDasPerguntasIniciais");
    // print("TOTAL $pontuacaoTotal");
    // print(mapaDeRepostas);

    if (pontuacaoDasPerguntasIniciais >= 2) {
      for (Pergunta pergunta in _perguntas.where(
        (pergunta) => ['imc', 'pescoco_grosso', 'sexo_masculino']
            .contains(pergunta.codigo),
      )) {
        if (pergunta.resposta == 1) {
          return ResultadoStopBang.altoRiscoDeAOS;
        } else {
          continue;
        }
      }
    }

    if (pontuacaoTotal <= 2) {
      return ResultadoStopBang.riscoBaixoDeAOS;
    } else if ([3, 4].contains(pontuacaoTotal)) {
      return ResultadoStopBang.riscoIntermediarioDeAOS;
    } else {
      return ResultadoStopBang.altoRiscoDeAOS;
    }
  }

  @override
  ResultadoStopBang? validarFormulario(GlobalKey<FormState> formKey) {
    if (!_perguntas.any((element) {
      return element.resposta == null;
    })) {
      formKey.currentState!.save();
      return _gerarResultadoDoQuestionario();
    }
    return null;
  }
}

enum ResultadoStopBang {
  altoRiscoDeAOS,
  riscoIntermediarioDeAOS,
  riscoBaixoDeAOS
}
