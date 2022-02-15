import 'package:flutter/cupertino.dart';
import 'package:sono/utils/models/pergunta.dart';

abstract class Questionario {
  static final List<Pergunta> _perguntas = [];
  static dynamic _resultado;

  get listaDePerguntas => _perguntas;
  get resultado => _resultado;

  dynamic _gerarResultadoDoQuestionario() {}

  validarFormulario(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      _gerarResultadoDoQuestionario();
    }
  }
}
