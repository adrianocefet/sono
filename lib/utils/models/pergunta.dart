import 'dart:io';

class Pergunta {
  dynamic enunciado;
  TipoPergunta tipo = TipoPergunta.afirmativa;
  dynamic codigo;
  List<int>? pesos;
  String? dominio;
  num? respostaNumerica;
  String? respostaExtenso;
  List respostaLista = [];
  bool? respostaBooleana;
  List<String>? opcoes;
  String? Function(String? value)? validador;
  File? respostaArquivo;
  String? unidade;

  Pergunta(
    this.enunciado,
    this.tipo,
    this.pesos,
    this.dominio,
    this.codigo, {
    this.opcoes,
    this.validador,
    this.unidade,
  });

  Pergunta.pelaBase(base) {
    enunciado = base['enunciado'];
    tipo = base['tipo'];
    pesos = base['pesos'] ?? <int>[];
    dominio = base['dominio'];
    codigo = base['codigo'];
    validador = base['validador'];
    opcoes = tipo == TipoPergunta.multiplaWHODAS
        ? [
            "1 - Nenhuma",
            "2 - Leve",
            "3 - Moderada",
            "4 - Grave",
            "5 - Extrema ou não consegue fazer",
            "6 - Não se aplica"
          ]
        : base['opcoes'];
    unidade = base['unidade'];
  }

  dynamic get respostaPadrao {
    switch (tipo) {
      case TipoPergunta.afirmativa:
      case TipoPergunta.afirmativaCadastros:
        return respostaBooleana;

      case TipoPergunta.multiplaCadastros:
      case TipoPergunta.comorbidades:
        return respostaLista;

      case TipoPergunta.data:
      case TipoPergunta.dropdown:
      case TipoPergunta.dropdownCadastros:
      case TipoPergunta.multipla:
      case TipoPergunta.extensoCadastros:
      case TipoPergunta.extenso:
      case TipoPergunta.extensoNumerico:
        return respostaExtenso;

      case TipoPergunta.numericaCadastros:
      case TipoPergunta.numerica:
      case TipoPergunta.mallampati:
      case TipoPergunta.multiplaWHODAS:
      case TipoPergunta.multiplaCondicionalBerlin:
        return respostaNumerica;

      case TipoPergunta.foto:
        return respostaArquivo;
    }
  }

  void setRespostaExtenso(String? respostaExtenso) =>
      this.respostaExtenso = respostaExtenso;

  void setRespostaArquivo(File? respostaArquivo) =>
      this.respostaArquivo = respostaArquivo;

  void setRespostaLista(List respostaLista) =>
      this.respostaLista = respostaLista;

  void setRespostaBooleana(bool? respostaBooleana) =>
      this.respostaBooleana = respostaBooleana;

  void setRespostaNumerica(num? resposta) => respostaNumerica = resposta;

  void limparRespostas() {
    setRespostaNumerica(null);
    setRespostaArquivo(null);
    setRespostaExtenso(null);
  }
}

enum TipoPergunta {
  extenso,
  extensoNumerico,
  numericaCadastros,
  numerica,
  extensoCadastros,
  afirmativa,
  afirmativaCadastros,
  multipla,
  multiplaCadastros,
  multiplaWHODAS,
  multiplaCondicionalBerlin,
  data,
  dropdown,
  dropdownCadastros,
  foto,
  comorbidades,
  mallampati
}
