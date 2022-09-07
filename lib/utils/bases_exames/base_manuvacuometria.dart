import 'package:sono/utils/models/pergunta.dart';

List<Map<String, dynamic>> baseManuvacuometria = [
  {
    'enunciado': "PImax",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'PImax',
    'unidade': 'cmH₂O',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta > 0)
            ? "Insira um valor válido"
            : null;
      } catch (e) {
        return "Insira um valor válido";
      }
    },
  },
  {
    'enunciado': "PEmax",
    'tipo': TipoPergunta.numericaCadastros,
    'codigo': 'PEmax',
    'unidade': 'cmH₂O',
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
