import 'package:flutter/material.dart';
import 'package:sono/pages/avaliacao/questionarios/stop_bang/resultado/resultado_stop_bang.dart';
import 'package:sono/utils/bases_questionarios/base_stopbang.dart';
import 'package:sono/utils/helpers/resposta_widget.dart';
import 'package:sono/utils/models/pergunta.dart';

class StopBangController {
  StopBangController({Map<String, dynamic>? autoPreencher}) {
    if (autoPreencher != null && autoPreencher.isNotEmpty) {
      for (Pergunta pergunta in _perguntas) {
        pergunta.respostaPadrao = autoPreencher[pergunta.codigo];
      }
    }
  }

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
  final int _pontuacaoTotal = 0;

  List<RespostaWidget> listaDeRespostas(Future<void> Function() passarPagina) =>
      _perguntas
          .map(
            (e) => RespostaWidget(
              e,
              notifyParent: passarPagina,
            ),
          )
          .toList();

  List<Pergunta> get listaDePerguntas => _perguntas;

  get resultado => _resultado;

  ResultadoStopBang? validarFormulario(GlobalKey<FormState> formKey) {
    if (!_perguntas.any((element) {
      return element.respostaPadrao == null;
    })) {
      formKey.currentState!.save();
      return ResultadoStopBang(_perguntas);
    }
    return null;
  }

  Map<String, dynamic> get mapaDeRespostasEPontuacao {
    Map<String, dynamic> mapa = {};

    for (Pergunta pergunta in _perguntas) {
      mapa[pergunta.codigo] = pergunta.respostaPadrao;
    }

    mapa["pontuacao"] = _pontuacaoTotal;
    mapa["resultado"] = resultado;

    return mapa;
  }
}
