import 'package:sono/utils/bases_questionarios/base_stopbang.dart';
import 'package:sono/utils/models/pergunta.dart';

class ResultadoStopBang {
  late final List<Pergunta> perguntas;
  late int pontuacao;
  late final ResultadoStopBangEnum resultado;

  ResultadoStopBang(this.perguntas) {
    resultado = _gerarResultadoDoQuestionario();
  }

  ResultadoStopBang.porMapa(Map<String, dynamic> mapa) {
    perguntas = baseStopBang.map((e) => Pergunta.pelaBase(e)).toList();

    for (Pergunta pergunta in perguntas) {
      pergunta.respostaPadrao = mapa[pergunta.codigo];
    }

    pontuacao = mapa["pontuacao"];
    resultado = _gerarResultadoDoQuestionario();
  }

  String get resultadoEmString {
    switch (resultado) {
      case ResultadoStopBangEnum.altoRiscoDeAOS:
        return "Alto Risco de AOS!";
      case ResultadoStopBangEnum.riscoIntermediarioDeAOS:
        return "Risco Intermediário de AOS!";
      default:
        return "Risco Baixo de AOS!";
    }
  }

  ResultadoStopBangEnum _gerarResultadoDoQuestionario() {
    int pontuacaoDasPerguntasIniciais = 0;
    pontuacao = 0;
    Map mapaDeRepostas = {};

    for (Pergunta pergunta in perguntas) {
      int? resposta = pergunta.respostaNumerica?.toInt();

      mapaDeRepostas[pergunta.codigo] = pergunta.respostaPadrao;

      if (perguntas.indexOf(pergunta) <= 3) {
        pontuacaoDasPerguntasIniciais += resposta!;
      }

      pontuacao += resposta!;
    }

    if (pontuacaoDasPerguntasIniciais >= 2) {
      for (Pergunta pergunta in perguntas.where(
        (pergunta) => ['imc', 'pescoco_grosso', 'sexo_masculino']
            .contains(pergunta.codigo),
      )) {
        if (pergunta.respostaNumerica == 1) {
          return ResultadoStopBangEnum.altoRiscoDeAOS;
        } else {
          continue;
        }
      }
    }

    if (pontuacao <= 2) {
      return ResultadoStopBangEnum.riscoBaixoDeAOS;
    } else if ([3, 4].contains(pontuacao)) {
      return ResultadoStopBangEnum.riscoIntermediarioDeAOS;
    } else {
      return ResultadoStopBangEnum.altoRiscoDeAOS;
    }
  }

  Map<String, dynamic> get mapaDeRespostasEPontuacao {
    Map<String, dynamic> mapa = {};

    for (Pergunta pergunta in perguntas) {
      mapa[pergunta.codigo] = pergunta.respostaPadrao;
    }

    mapa["pontuacao"] = pontuacao;

    return mapa;
  }
}

enum ResultadoStopBangEnum {
  altoRiscoDeAOS,
  riscoIntermediarioDeAOS,
  riscoBaixoDeAOS
}
