
import 'package:sono/utils/models/pergunta.dart';

List<Map<String, dynamic>> basePolissonografia = [
  {
    'enunciado': "PImax (cmH₂O)",
    'tipo': TipoPergunta.numerica,
    'codigo': 'PImax',
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
    'enunciado': "PEmax (cmH₂O)",
    'tipo': TipoPergunta.numerica,
    'codigo': 'PEmax',
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