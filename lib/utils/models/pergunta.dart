import 'dart:io';

class Pergunta {
  dynamic enunciado = '';
  TipoPergunta tipo = TipoPergunta.afirmativa;
  dynamic codigo = '';
  List<int> pesos = [];
  String dominio = '';
  int? resposta;
  String? respostaExtenso;
  List respostaLista = [];
  bool? respostaBooleana;
  List<String>? opcoes = [''];
  String? Function(String? value)? validador;
  File? respostaArquivo;

  Pergunta(
    this.enunciado,
    this.tipo,
    this.pesos,
    this.dominio,
    this.codigo, {
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

  void setRespostaLista(List respostaLista) =>
      this.respostaLista = respostaLista;

  void setRespostaBooleana(bool? respostaBooleana) =>
      respostaBooleana = respostaBooleana;

  void setResposta(int? resposta) {
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
  afirmativaCadastros,
  multipla,
  multiplaCondicionalBerlin,
  data,
  dropdown,
  dropdownCadastros,
  foto,
  comorbidades,
  mallampati
}
