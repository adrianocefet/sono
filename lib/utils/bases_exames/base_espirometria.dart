import 'package:sono/utils/models/pergunta.dart';

List<Map<String, dynamic>> baseEspirometria = [
  {
    'enunciado': "CVF",
    'tipo': TipoPergunta.numerica,
    'codigo': 'CVF',
    'unidade': '% do previsto',
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
    'enunciado': "VEF₁",
    'tipo': TipoPergunta.numerica,
    'codigo': 'VEF1',
    'unidade': '% do previsto',
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
    'enunciado': "VEF₁/CVF",
    'tipo': TipoPergunta.numerica,
    'codigo': 'VEF1_CVF',
    'unidade': "%",
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
    'enunciado': "FEF₂₅₋₇₅",
    'tipo': TipoPergunta.numerica,
    'codigo': 'FEF25_75',
    'unidade': '% do previsto',
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
    'enunciado': "PFE",
    'tipo': TipoPergunta.numerica,
    'codigo': 'PFE',
    'unidade': '% do previsto',
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
