import 'package:sono/utils/bases_questionarios/base_epworth.dart';
import '../../../../utils/models/pergunta.dart';

class ResultadoEpworth {
  late final List<Pergunta> perguntas;
  late final int pontuacao;
  late final String resultado;
  late final int indiceResultado;

  ResultadoEpworth(this.perguntas) {
    pontuacao = _obterPontuacao;
    resultado = _obterResultado;
  }

  ResultadoEpworth.porMapa(Map<String, dynamic> mapa) {
    perguntas = baseEpworth.map((e) => Pergunta.pelaBase(e)).toList();

    for (Pergunta pergunta in perguntas) {
      if ([int, null].contains(mapa[pergunta.codigo].runtimeType)) {
        pergunta.resposta = mapa[pergunta.codigo];
      }
      pergunta.respostaExtenso = mapa[pergunta.codigo].runtimeType == String
          ? mapa[pergunta.codigo]
          : null;
    }

    pontuacao = mapa["pontuacao"];
    resultado = mapa["resultado"];
  }

  String get resultadoEmString => resultado;

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

  Map<String, dynamic> get mapaDeRespostasEPontuacao {
    Map<String, dynamic> mapa = {};

    for (Pergunta pergunta in perguntas) {
      mapa[pergunta.codigo] = pergunta.respostaExtenso ?? pergunta.resposta;
    }

    mapa["pontuacao"] = pontuacao;
    mapa["resultado"] = resultado;

    return mapa;
  }
}
