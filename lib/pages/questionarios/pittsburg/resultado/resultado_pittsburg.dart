import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../utils/models/pergunta.dart';

class ResultadoPittsburg {
  final List<Pergunta> perguntas;
  late final String resultado;
  late final int pontuacao;
  late final int indiceResultado;

  ResultadoPittsburg(this.perguntas) {
    pontuacao = _obterPontuacaoGeral;
    resultado = _obterResultado;
  }

  int get _obterPontuacaoGeral {
    List<int> pontuacoesComponentes = List.filled(7, 0);

    pontuacoesComponentes[0] = _pontuacaoComponente1;
    pontuacoesComponentes[1] = _pontuacaoComponente2;
    pontuacoesComponentes[2] = _pontuacaoComponente3;
    pontuacoesComponentes[3] = _pontuacaoComponente4;
    pontuacoesComponentes[4] = _pontuacaoComponente5;
    pontuacoesComponentes[5] = _pontuacaoComponente6;
    pontuacoesComponentes[6] = _pontuacaoComponente7;

    return pontuacoesComponentes.reduce((a, b) => a + b);
  }

  String get _obterResultado {
    if (pontuacao <= 4) {
      indiceResultado = 1;
      return "Boa";
    } else if (pontuacao <= 10) {
      indiceResultado = 2;
      return "Ruim";
    } else {
      indiceResultado = 3;
      return "Presença de distúrbio do sono";
    }
  }

  int get _pontuacaoComponente1 =>
      perguntas.firstWhere((pergunta) => pergunta.codigo == "6").resposta!;

  int get _pontuacaoComponente2 {
    Pergunta q2 = perguntas.firstWhere((element) => element.codigo == "2");
    Pergunta q5A = perguntas.firstWhere((element) => element.codigo == "5A");
    int pontuacaoQ2 = 0;
    int respostaQ2 = int.parse(q2.respostaExtenso!);

    if (respostaQ2 <= 15) {
      pontuacaoQ2 = 0;
    } else if (respostaQ2 <= 30) {
      pontuacaoQ2 = 1;
    } else if (respostaQ2 <= 60) {
      pontuacaoQ2 = 2;
    } else {
      pontuacaoQ2 = 3;
    }

    int soma = q5A.resposta! + pontuacaoQ2;

    if (soma == 0) {
      return 0;
    } else if (soma <= 2) {
      return 1;
    } else if (soma <= 4) {
      return 2;
    } else {
      return 3;
    }
  }

  int get _pontuacaoComponente3 {
    double respostaQ4 = double.parse(
      perguntas.firstWhere((element) => element.codigo == "4").respostaExtenso!,
    );

    if (respostaQ4 < 5) {
      return 3;
    } else if (respostaQ4 <= 6) {
      return 2;
    } else if (respostaQ4 <= 7) {
      return 1;
    } else {
      return 0;
    }
  }

  int get _pontuacaoComponente4 {
    double horarioParaDouble(TimeOfDay horario) =>
        horario.hour + horario.minute / 60;

    double respostaQ1 = horarioParaDouble(
      TimeOfDay.fromDateTime(
        DateFormat("hh:mm").parse(
          perguntas
              .firstWhere((element) => element.codigo == "1")
              .respostaExtenso!,
        ),
      ),
    );

    double respostaQ3 = horarioParaDouble(
      TimeOfDay.fromDateTime(
        DateFormat("hh:mm").parse(
          perguntas
              .firstWhere((element) => element.codigo == "3")
              .respostaExtenso!,
        ),
      ),
    );

    double respostaQ4 = double.parse(
      perguntas.firstWhere((element) => element.codigo == "4").respostaExtenso!,
    );

    double horasNoLeito = respostaQ3 - respostaQ1;
    double eficienciaNoSono = (respostaQ4 / horasNoLeito) * 100;

    if (eficienciaNoSono < 65) {
      return 3;
    } else if (eficienciaNoSono <= 74) {
      return 2;
    } else if (eficienciaNoSono <= 84) {
      return 1;
    } else {
      return 0;
    }
  }

  int get _pontuacaoComponente5 {
    int soma5Ba5J = 0;

    for (Pergunta pergunta in perguntas
        .where((element) => element.dominio == "5" && element.codigo != "5A")) {
      soma5Ba5J += pergunta.resposta ?? 0;
    }

    if (soma5Ba5J == 0) {
      return 0;
    } else if (soma5Ba5J <= 9) {
      return 1;
    } else if (soma5Ba5J <= 18) {
      return 2;
    } else {
      return 3;
    }
  }

  int get _pontuacaoComponente6 =>
      perguntas.firstWhere((pergunta) => pergunta.codigo == "7").resposta!;

  int get _pontuacaoComponente7 {
    int respostaq8 =
        perguntas.firstWhere((element) => element.codigo == "8").resposta!;
    int respostaq9 =
        perguntas.firstWhere((element) => element.codigo == "9").resposta!;
    int soma = respostaq8 + respostaq9;

    if (soma == 0) {
      return 0;
    } else if (soma <= 2) {
      return 1;
    } else if (soma <= 4) {
      return 2;
    } else {
      return 3;
    }
  }
}
