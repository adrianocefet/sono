import 'dart:io';
import 'package:sono/pages/questionarios/whodas/questionario/whodas_controller.dart';

class Pergunta {
  dynamic enunciado = '';
  TipoPergunta tipo = TipoPergunta.afirmativa;
  WHODASController? whodas;
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

  Pergunta.pelaBase(base) {
    enunciado = base['enunciado'];
    tipo = base['tipo'];
    pesos = base['pesos'] ?? <int>[];
    dominio = base['dominio'];
    codigo = base['codigo'];
    validador = base['validador'];
    opcoes = tipo == TipoPergunta.marcar
        ? [
            "1 - Nenhuma",
            "2 - Leve",
            "3 - Moderada",
            "4 - Grave",
            "5 - Extrema ou não consegue fazer",
            "6 - Não se aplica"
          ]
        : base['opcoes'];
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
