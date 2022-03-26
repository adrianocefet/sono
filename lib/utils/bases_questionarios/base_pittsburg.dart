import '../models/pergunta.dart';

Map<String, String> enunciadosPittsburg = {
  "1": """*Índice da qualidade do sono de Pittsburgh*

As seguintes perguntas são relativas aos seus hábitos de sono _*durante o ultimo mês somente.*_
Suas respostas devem indicar a lembrança mais exata da maioria dos dias e noites do ultimo
mês. 

Por favor, responda a todas as perguntas.""",
  "5A":
      "Durante o último mês, com que frequência você teve dificuldade para dormir porque você:",
  "10E":
      "Se você tem um parceiro ou colega de quarto pergunte a ele com que freqüência, no ultimo mês você apresentou:",
};

List<Map<String, dynamic>> basePittsburg = [
  {
    "enunciado":
        "Durante o último mês, quando você geralmente foi para a cama a noite?",
    'tipo': TipoPergunta.multipla,
    'dominio': '1',
    'codigo': '1',
  },
  {
    "enunciado":
        "Durante o último mês, quanto tempo (em minutos) você geralmente levou para dormir a noite? ",
    'tipo': TipoPergunta.extensoNumerico,
    'dominio': '2',
    'codigo': '2',
    'validador': (value) {
      try {
        return value.trim().isEmpty || int.parse(value) < 0
            ? "Insira um período válido"
            : null;
      } catch (e) {
        return "Insira um período válido";
      }
    },
  },
  {
    "enunciado":
        "Durante o último mês, quando você geralmente levantou de manhã?",
    'tipo': TipoPergunta.multipla,
    'dominio': '3',
    'codigo': '3',
    'validador': (value) {
      try {
        return value.trim().isEmpty || int.parse(value) < 0
            ? "Insira um período válido"
            : null;
      } catch (e) {
        return "Insira um período válido";
      }
    },
  },
  {
    "enunciado":
        "Durante o último mês, quantas horas de sono você teve por noite? (Esta pode ser diferente do número de horas que você ficou na cama)",
    'tipo': TipoPergunta.extensoNumerico,
    'dominio': '4',
    'codigo': '4',
    'validador': (value) {
      try {
        return value.trim().isEmpty || int.parse(value) < 0 || int.parse(value) > 24
            ? "Insira um período válido"
            : null;
      } catch (e) {
        return "Insira um período válido";
      }
    },
  },
  {
    "enunciado": "Não conseguiu adormecer em até 30 minutos",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '5',
    'codigo': '5A',
  },
  {
    "enunciado": "Acordou no meio da noite ou de manhã cedo",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '5',
    'codigo': '5B',
  },
  {
    "enunciado": "Precisou levantar para ir ao banheiro",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '5',
    'codigo': '5C',
  },
  {
    "enunciado": "Não conseguiu respirar confortavelmente",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '5',
    'codigo': '5D',
  },
  {
    "enunciado": "Tossiu ou roncou forte",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '5',
    'codigo': '5E',
  },
  {
    "enunciado": "Sentiu muito frio",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '5',
    'codigo': '5F',
  },
  {
    "enunciado": "Sentiu muito calor",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '5',
    'codigo': '5G',
  },
  {
    "enunciado": "Teve sonhos ruins",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '5',
    'codigo': '5H',
  },
  {
    "enunciado": "Teve dor",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '5',
    'codigo': '5I',
  },
  {
    "enunciado":
        "Outras razões, por favor descreva (caso não hajam, mantenha o campo em branco e pressione avançar):",
    'tipo': TipoPergunta.extenso,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '5',
    'codigo': '5J',
  },
  {
    "enunciado":
        "Durante o último mês como você classificaria a qualidade do seu sono de uma maneira geral:",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Muito boa",
      "Boa",
      "Ruim",
      "Muito ruim",
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '6',
    'codigo': '6',
  },
  {
    "enunciado":
        "Durante o último mês, com que frequencia você tomou medicamento (prescrito ou por conta própria) para lhe ajudar",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '7',
    'codigo': '7',
  },
  {
    "enunciado":
        "No último mês, que frequencia você teve dificuldade para ficar acordado enquanto dirigia, comia ou participava de uma atividade social (festa, reunião de amigos)",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '8',
    'codigo': '8',
  },
  {
    "enunciado":
        "Durante o último mês, quão problemático foi pra você manter o entusiasmo (ânimo) para fazer as coisas (suas atividades habituais)?",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '9',
    'codigo': '9',
  },
  {
    "enunciado": "Você tem um parceiro (a), esposo (a) ou colega de quarto? ",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Não",
      "Parceiro ou colega, mas em outro quarto",
      "Parceiro no mesmo quarto, mas em outra cama",
      "Parceiro na mesma cama",
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '10',
    'codigo': '10',
  },
  {
    "enunciado": "Ronco forte",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '10',
    'codigo': '10E',
  },
  {
    "enunciado": "Longas paradas de respiração enquanto dormia",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '10',
    'codigo': '10F',
  },
  {
    "enunciado": "Contrações ou puxões de pernas enquanto dormia",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '10',
    'codigo': '10G',
  },
  {
    "enunciado": "Episodios de desorientação ou confusão durante o sono",
    'tipo': TipoPergunta.multipla,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '10',
    'codigo': '10H',
  },
  {
    "enunciado":
        "Outras alterações (inquietações) enquanto você dorme, por favor descreva (caso não hajam, mantenha o campo em branco e pressione avançar):",
    'tipo': TipoPergunta.extenso,
    "opcoes": [
      "Nenhuma no último mês ",
      "Menos de uma vez por semana ",
      "Uma ou duas vezes por semana",
      "Três ou mais vezes na semana"
    ],
    "pesos": [0, 1, 2, 3],
    'dominio': '10',
    'codigo': '10I',
  },
];
