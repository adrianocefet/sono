import 'package:flutter/material.dart';
import 'package:sono/utils/base_perguntas/base_stopbang.dart';
import 'package:sono/utils/helpers/respostas.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/utils/models/questionario.dart';

class StopBangController implements Questionario {
  static final List<Pergunta> _perguntas = baseStopBang.map((e) {
    return Pergunta(
      e['enunciado'],
      e['tipo'],
      e['pesos'],
      e['dominio'],
      e['codigo'],
      validador: e['validador'],
    );
  }).toList();

  static final List<Resposta> _respostas = _perguntas
      .map(
        (e) => Resposta(
          e,
          formularioEWHODAS: false,
          corTexto: Colors.black,
        ),
      )
      .toList();

  static dynamic _resultado;

  List<Resposta> get listaDeRespostas => _respostas;

  @override
  List<Pergunta> get listaDePerguntas => _perguntas;

  @override
  get resultado => _resultado;

  ResultadoStopBang _gerarResultadoDoQuestionario() {
    int pontuacaoDasPerguntasIniciais = 0;
    int pontuacaoTotal = 0;
    Map mapaDeRepostas = {};

    for (Pergunta pergunta in _perguntas) {
      int resposta = pergunta.resposta as int;

      mapaDeRepostas[pergunta.codigo] = pergunta.resposta;

      if (_perguntas.indexOf(pergunta) <= 3) {
        pontuacaoDasPerguntasIniciais += resposta;
      }

      pontuacaoTotal += resposta;
    }

    print("INICIAIS $pontuacaoDasPerguntasIniciais");
    print("TOTAL $pontuacaoTotal");
    print(mapaDeRepostas);

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
    return _gerarResultadoDoQuestionario();
  }
}

enum ResultadoStopBang {
  altoRiscoDeAOS,
  riscoIntermediarioDeAOS,
  riscoBaixoDeAOS
}
