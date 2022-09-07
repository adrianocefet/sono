import 'dart:io';

class Pergunta {
  dynamic enunciado;
  TipoPergunta tipo = TipoPergunta.afirmativa;
  dynamic codigo;
  List<int>? pesos;
  String? dominio;
  num? respostaNumerica;
  int? resposta;
  String? textoAjuda;
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
    this.textoAjuda,
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

    textoAjuda = base['texto_ajuda'];
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

      case TipoPergunta.multiplaCadastrosComExtensoESeletor:
      case TipoPergunta.comorbidades:
        return respostaLista;

      case TipoPergunta.data:
      case TipoPergunta.dropdown:
      case TipoPergunta.dropdownCadastros:
      case TipoPergunta.multipla:
      case TipoPergunta.extensoCadastros:
      case TipoPergunta.extenso:
      case TipoPergunta.extensoNumerico:
      case TipoPergunta.extensoNumericoCadastros:
      case TipoPergunta.multiLinhasCadastros:
      case TipoPergunta.multiplaWHODAS:
      case TipoPergunta.multiplaCondicionalBerlin:
        return respostaExtenso;

      case TipoPergunta.numericaCadastros:
      case TipoPergunta.numerica:
      case TipoPergunta.mallampati:
        return respostaNumerica;

      case TipoPergunta.foto:
        return respostaArquivo;
    }
  }

  set respostaPadrao(resposta) {
    switch (tipo) {
      case TipoPergunta.afirmativa:
      case TipoPergunta.afirmativaCadastros:
        if(resposta == null) break;
        respostaExtenso = resposta ? 'Sim' : 'Não';
        respostaNumerica = resposta ? 1 : 0;
        respostaBooleana = resposta;
        break;

      case TipoPergunta.multiplaCadastrosComExtensoESeletor:
      case TipoPergunta.comorbidades:
        respostaLista = resposta;
        break;

      case TipoPergunta.data:
      case TipoPergunta.dropdown:
      case TipoPergunta.dropdownCadastros:
      case TipoPergunta.multipla:
      case TipoPergunta.extensoCadastros:
      case TipoPergunta.extenso:
      case TipoPergunta.extensoNumerico:
      case TipoPergunta.extensoNumericoCadastros:
      case TipoPergunta.multiLinhasCadastros:
      case TipoPergunta.multiplaCondicionalBerlin:
      case TipoPergunta.multiplaWHODAS:
        if (opcoes != null) respostaNumerica = opcoes!.indexOf(resposta ?? '');
        respostaExtenso = resposta;
        break;

      
      case TipoPergunta.numericaCadastros:
      case TipoPergunta.numerica:
      case TipoPergunta.mallampati:
        if (opcoes != null) respostaExtenso = opcoes![resposta];
        respostaNumerica = resposta;
        respostaExtenso = resposta.toString();
        break;

      case TipoPergunta.foto:
        respostaArquivo = resposta;
        break;
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
  extensoNumericoCadastros,
  multiLinhasCadastros,
  afirmativa,
  afirmativaCadastros,
  multipla,
  multiplaCadastrosComExtensoESeletor,
  multiplaWHODAS,
  multiplaCondicionalBerlin,
  data,
  dropdown,
  dropdownCadastros,
  foto,
  comorbidades,
  mallampati
}
