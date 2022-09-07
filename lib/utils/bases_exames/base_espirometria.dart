import 'package:sono/utils/models/pergunta.dart';

List<Map<String, dynamic>> baseEspirometria = [
  {
    'enunciado': "CVF",
    'tipo': TipoPergunta.numericaCadastros,
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
    'tipo': TipoPergunta.numericaCadastros,
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
    'tipo': TipoPergunta.numericaCadastros,
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
    'tipo': TipoPergunta.numericaCadastros,
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
    'tipo': TipoPergunta.numericaCadastros,
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
