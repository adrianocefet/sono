import 'package:sono/utils/models/pergunta.dart';

List<Map<String, dynamic>> baseActigrafia = [
  {
    'enunciado': "Tempo total de cama (TTC) ",
    'tipo': TipoPergunta.numerica,
    'codigo': 'TTC',
    'unidade': 'minutos',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "Tempo total de sono (TTS) ",
    'tipo': TipoPergunta.numerica,
    'codigo': 'TTS',
    'unidade': 'minutos',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "Latência para o sono",
    'tipo': TipoPergunta.numerica,
    'codigo': 'latencia_para_o_sono',
    'unidade': 'minutos',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "Eficiência do sono (TTS/TTC)",
    'tipo': TipoPergunta.numerica,
    'codigo': 'eficiencia_do_sono',
    'unidade': '%',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "WASO (tempo em vigília após início do sono)",
    'tipo': TipoPergunta.numerica,
    'codigo': 'WASO',
    'unidade': 'minutos',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta < 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
];
