import 'package:sono/utils/models/pergunta.dart';

List<Map<String, dynamic>> baseBerlin = [
  {
    'enunciado': "Altura (em metros):",
    'tipo': TipoPergunta.extensoNumerico,
    'dominio': 'inicial',
    'codigo': 'altura',
    'validador': (value) {
      try {
        double resposta = double.parse(value.replaceAll(",", "."));
        return value.trim().isEmpty || (resposta > 3 || resposta < 0)
            ? "Insira uma altura válida"
            : null;
      } catch (e) {
        return "Insira uma altura válida";
      }
    },
  },
  {
    'enunciado': "Idade:",
    'tipo': TipoPergunta.extensoNumerico,
    'dominio': 'inicial',
    'codigo': 'idade',
    'validador': (value) {
      try {
        return value.trim().isEmpty || int.parse(value) < 0
            ? "Insira uma idade válida"
            : null;
      } catch (e) {
        return "Insira uma idade válida";
      }
    },
  },
  {
    'enunciado': "Peso (em quilogramas):",
    'tipo': TipoPergunta.extensoNumerico,
    'dominio': 'inicial',
    'codigo': 'peso',
    'validador': (value) {
      try {
        return value.trim().isEmpty ||
                double.parse(value.replaceAll(",", ".")) < 0
            ? "Insira um peso válido"
            : null;
      } on Exception {
        return "Insira um peso válido";
      }
    },
  },
  {
    'enunciado': "Sexo:",
    'tipo': TipoPergunta.multipla,
    'dominio': 'inicial',
    'opcoes': ["Masculino", "Feminino"],
    'pesos': [0, 0],
    'codigo': 'sexo',
    'validador': (value) => value.trim().isEmpty ? "Selecione uma opção" : null,
  },
  {
    'enunciado': "Você ronca?",
    'tipo': TipoPergunta.multipla,
    'dominio': 'categoria_1',
    "pesos": [1, 0, 0],
    'opcoes': ["Sim", "Não", "Não sei"],
    'codigo': 'voce_ronca',
  },
  {
    'enunciado': "Seu ronco é?",
    'tipo': TipoPergunta.multipla,
    'dominio': 'categoria_1',
    "pesos": [0, 0, 1, 1],
    'opcoes': [
      "Pouco mais alto que respirando",
      "Tão alto quanto falando",
      "Mais alto que falando",
      " Muito alto que pode ser ouvido nos quartos próximos"
    ],
    'codigo': 'seu_ronco',
  },
  {
    'enunciado': "Com que freqüência você ronca?",
    'tipo': TipoPergunta.multipla,
    'dominio': 'categoria_1',
    "pesos": [1, 1, 0, 0, 0, 0],
    'opcoes': [
      "Praticamente todos os dias",
      "3-4 vezes por semana",
      "1-2 vezes por semana",
      "1-2 vezes por mês",
      "Nunca ou praticamente nunca"
    ],
    'codigo': 'frequencia_ronco',
  },
  {
    'enunciado': "O seu ronco alguma vez já incomodou alguém?",
    'tipo': TipoPergunta.multipla,
    'dominio': 'categoria_1',
    "pesos": [1, 0],
    'opcoes': ["Sim", "Não"],
    'codigo': 'incomodou',
  },
  {
    'enunciado': "Alguém notou que você pára de respirar enquanto dorme?",
    'tipo': TipoPergunta.multipla,
    'dominio': 'categoria_1',
    "pesos": [1, 1, 0, 0, 0, 0],
    'opcoes': [
      "Praticamente todos os dias",
      "3-4 vezes por semana",
      "1-2 vezes por semana",
      " 1-2 vezes por mês",
      "Nunca ou praticamente nunca"
    ],
    'codigo': 'para_de_respirar',
  },
  {
    'enunciado':
        "Quantas vezes você se sente cansado ou com fadiga depois de acordar?",
    'tipo': TipoPergunta.multipla,
    'dominio': 'categoria_2',
    "pesos": [1, 1, 0, 0, 0, 0],
    'opcoes': [
      "Praticamente todos os dias",
      "3-4 vezes por semana",
      "1-2 vezes por semana",
      "1-2 vezes por mês",
      "Nunca ou praticamente nunca"
    ],
    'codigo': 'fadiga_depois_de_acordar',
  },
  {
    'enunciado':
        "Quando você está acordado, você se sente cansado, fadigado ou não se sente bem?",
    'tipo': TipoPergunta.multipla,
    'dominio': 'categoria_2',
    "pesos": [1, 1, 0, 0, 0, 0],
    'opcoes': [
      "Praticamente todos os dias",
      "3-4 vezes por semana",
      "1-2 vezes por semana",
      "1-2 vezes por mês",
      "Nunca ou praticamente nunca"
    ],
    'codigo': 'se_sente_cansado',
  },
  {
    'enunciado': "Alguma vez você cochilou ou caiu no sono enquanto dirigia?",
    'tipo': TipoPergunta.multiplaCondicionalBerlin,
    'dominio': 'categoria_2',
    "pesos": [0, 0, 1, 1, 0, 0, 0, 0],
    'opcoes': [
      "Sim",
      "Não",
      "Praticamente todos os dias",
      "3-4 vezes por semana",
      "1-2 vezes por semana",
      "1-2 vezes por mês",
      "Nunca ou praticamente nunca"
    ],
    'codigo': 'cochilou_enquanto_dirigia',
  },
  {
    'enunciado': "Você tem pressão alta?",
    'tipo': TipoPergunta.multipla,
    'dominio': 'categoria_3',
    "pesos": [1, 0, 0],
    'opcoes': ["Sim", "Não", "Não sei"],
    'codigo': 'pressao_alta',
  },
];
