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
  String? respostaExtenso;
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

  Pergunta.pelaBase(e) {
    enunciado = e['enunciado'];
    tipo = e['tipo'];
    pesos = e['pesos'] ?? <int>[];
    dominio = e['dominio'];
    codigo = e['codigo'];
    validador = e['validador'];
    opcoes = e['opcoes'];
  }

  void setRespostaExtenso(String? respostaExtenso) =>
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

  void limparRespostas() {
    setResposta(null);
    setRespostaArquivo(null);
    setRespostaExtenso(null);
  }
}

enum TipoPergunta {
  extenso,
  extensoNumerico,
  extensoNumericoCadastros,
  extensoCadastros,
  marcar,
  afirmativa,
  multipla,
  multiplaCondicionalBerlin,
  data,
  dropdown,
  foto,
}
