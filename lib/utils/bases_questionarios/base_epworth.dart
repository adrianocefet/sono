import '../models/pergunta.dart';

List<Map<String, dynamic>> baseEpworth = [
  {
    "enunciado": "Sentar e ler",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma chance de cochilar",
      "Leve chance de cochilar",
      "Chance moderada de cochilar",
      "Alta chance de cochilar"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '1',
    'codigo': 'sentar_e_ler',
  },
  {
    'enunciado': "Assistir à TV",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma chance de cochilar",
      "Leve chance de cochilar",
      "Chance moderada de cochilar",
      "Alta chance de cochilar"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '2',
    'codigo': 'assistir_tv',
  },
  {
    'enunciado': "Ficar sentado, sem fazer nada, em um local público",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma chance de cochilar",
      "Leve chance de cochilar",
      "Chance moderada de cochilar",
      "Alta chance de cochilar"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '3',
    'codigo': 'sentado_lugar_publico',
  },
  {
    'enunciado': "Ficar sentado, por uma hora, como passageiro em um carro",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma chance de cochilar",
      "Leve chance de cochilar",
      "Chance moderada de cochilar",
      "Alta chance de cochilar"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '4',
    'codigo': 'passageiro_carro',
  },
  {
    'enunciado': "Deitar à tarde para descansar",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma chance de cochilar",
      "Leve chance de cochilar",
      "Chance moderada de cochilar",
      "Alta chance de cochilar"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '5',
    'codigo': 'deitar_a_tarde',
  },
  {
    'enunciado': "Sentar e conversar com outra pessoa",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma chance de cochilar",
      "Leve chance de cochilar",
      "Chance moderada de cochilar",
      "Alta chance de cochilar"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '6',
    'codigo': 'sentar_e_conversar',
  },
  {
    'enunciado':
        "Sentar, em silêncio, depois do almoço (sem ingestão de álcool)",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma chance de cochilar",
      "Leve chance de cochilar",
      "Chance moderada de cochilar",
      "Alta chance de cochilar"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '7',
    'codigo': 'sentar_apos_almoco',
  },
  {
    'enunciado':
        "Sentado em um carro, parado por alguns minutos por causa de trânsito",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma chance de cochilar",
      "Leve chance de cochilar",
      "Chance moderada de cochilar",
      "Alta chance de cochilar"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '8',
    'codigo': 'carro_parado_transito',
  },
];
