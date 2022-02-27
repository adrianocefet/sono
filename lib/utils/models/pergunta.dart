import 'dart:io';
import 'package:sono/utils/helpers/whodas.dart';

class Pergunta {
  dynamic enunciado = '';
  TipoPergunta tipo = TipoPergunta.afirmativa;
  WHODAS? whodas;
  dynamic codigo = '';
  List<int> pesos = [];
  String dominio = '';
  int? resposta;
  String respostaExtenso = '';
  List<String?>? respostaLocalizacao;
  List<String>? opcoes = [''];
  String? Function(String? value)? validador;
  File? respostaArquivo;

  Pergunta(
    this.enunciado,
    this.tipo,
    this.pesos,
    this.dominio,
    this.codigo, {
    this.whodas,
    this.opcoes,
    this.validador,
  });

  void setRespostaExtenso(String respostaExtenso) =>
      this.respostaExtenso = respostaExtenso;

  void setRespostaArquivo(File? respostaArquivo) =>
      this.respostaArquivo = respostaArquivo;

  void setResposta(int? resposta) {
    if (dominio.contains('dom_51') &&
        ['D5.1', 'D5.5'].contains(codigo) != true) {
      whodas?.condicoesExtraDom51[codigo] =
          [0, 5].contains(resposta) != true ? true : false;
    }

    if (dominio.contains('dom_52') &&
        ['D5.9', 'D5.10'].contains(codigo) != true) {
      whodas?.condicoesExtraDom52[codigo] =
          [0, 5].contains(resposta) != true ? true : false;
    }

    this.resposta = resposta;
  }
}

enum TipoPergunta {
  extenso,
  extensoNumerico,
  marcar,
  afirmativa, //0,1,2
  multipla,
  data,
  dropdown,
  foto,
}
