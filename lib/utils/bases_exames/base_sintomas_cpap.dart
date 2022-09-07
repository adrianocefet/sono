import 'package:sono/utils/models/pergunta.dart';

List<Map<String, dynamic>> baseSintomasCPAP = [
  {
    'enunciado': 'Preencha os sintomas conforme relatado',
    'tipo': TipoPergunta.multiplaCadastrosComExtensoESeletor,
    'codigo': 'sintomas_cpap',
    'opcoes': [
      'Ressecamento da boca',
      'Ressecamento do nariz',
      'Irritação na pele',
      'Irritação nos olhos',
      'Congestão nasal',
      'Aumento de flatulência',
      'Falta de ar durante o uso',
      'Diminuição de rendimento (estudos/laboral)',
      'Claustrofobia',
      'Insônia',
    ],
  }
];
