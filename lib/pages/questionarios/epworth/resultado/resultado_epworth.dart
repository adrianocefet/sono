import '../../../../utils/models/pergunta.dart';

class ResultadoEpworth {
  final List<Pergunta> perguntas;
  late final int pontuacao;
  late final String resultado;
  late final int indiceResultado;

  ResultadoEpworth(this.perguntas) {
    pontuacao = _obterPontuacao;
    resultado = _obterResultado;
  }

  int get _obterPontuacao {
    int pontuacao = 0;
    for (Pergunta pergunta in perguntas) {
      pontuacao += pergunta.resposta!;
    }

    return pontuacao;
  }

  String get _obterResultado {
    if (pontuacao <= 6) {
      indiceResultado = 1;
      return "Sono normal";
    } else if (pontuacao <= 8) {
      indiceResultado = 2;
      return "Média de sonolência";
    } else {
      indiceResultado = 3;
      return "Sonolência anormal";
    }
  }
}
