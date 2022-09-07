import '../models/pergunta.dart';

List<Map<String, dynamic>> baseSacsBR = [
  {
    "enunciado":
        "O(a) senhor(a) é portador(a) de hipertensão arterial ou algum médico(a) recomendou que o(a) senhor(a) usasse alguma medicação para controlar a pressão?",
    'tipo': TipoPergunta.afirmativa,
    'dominio': '1',
    'codigo': 'hipertensao',
  },
  {
    'enunciado':
        "“Meu parceiro diz que ronco”.\n Escolha a melhor resposta sobre a frequência do seu ronco:",
    'tipo': TipoPergunta.multipla,
    'dominio': '2',
    "pesos": [0, 0, 1, 1, 1, 1, 1],
    'opcoes': [
      "Não sei dizer",
      "Nunca",
      "Raramente (1-2 vezes por ano)",
      "Ocasionalmente (4-8 vezes ao ano)",
      "Algumas vezes (1-2 vezes por mês)",
      "Frequentemente (3-5 vezes por semana)",
      "Sempre (todas as noites)"
    ],
    'codigo': 'freq_ronco',
  },
  {
    'enunciado':
        "“Meu parceiro diz que engasgo ou fico sufocado enquanto durmo”.\n Escolha a melhor resposta sobre a frequência desses sintomas:",
    'tipo': TipoPergunta.multipla,
    'dominio': '3',
    "pesos": [0, 0, 1, 1, 1, 1, 1],
    'opcoes': [
      "Não sei dizer",
      "Nunca",
      "Raramente (1-2 vezes por ano)",
      "Ocasionalmente (4-8 vezes ao ano)",
      "Algumas vezes (1-2 vezes por mês)",
      "Frequentemente (3-5 vezes por semana)",
      "Sempre (todas as noites)"
    ],
    'codigo': 'freq_engasgo_ou_sufoco',
  },
  {
    "enunciado": "Insira a circunferência do pescoço do paciente (cm)",
    "tipo": TipoPergunta.extensoNumerico,
    "dominio": "4",
    "codigo": "circunferencia_pescoco",
    "validador": (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || resposta < 0
            ? "Insira uma circunferência válida"
            : null;
      } catch (e) {
        return "Insira uma circunferência válida";
      }
    }
  }
];

const List<List<int>> previsaoDeSAOSSemHAS = [
  [0, 0, 1],
  [0, 0, 1],
  [0, 1, 2],
  [1, 2, 3],
  [1, 3, 5],
  [2, 4, 7],
  [3, 6, 10],
  [5, 8, 14],
  [7, 12, 20],
  [10, 16, 28],
  [14, 23, 38],
  [19, 32, 53],
];

const List<List<int>> previsaoDeSAOSComHAS = [
  [0, 1, 2],
  [1, 2, 4],
  [1, 3, 5],
  [2, 4, 8],
  [4, 6, 11],
  [5, 9, 16],
  [8, 13, 22],
  [11, 18, 30],
  [15, 25, 42],
  [21, 35, 58],
  [29, 48, 80],
  [40, 66, 110],
];
