import 'package:intl/intl.dart';
import 'package:sono/utils/models/pergunta.dart';

const List<String> enunciadosDominios = [
  'Nos últimos 30 dias, quanta dificuldade você teve em:',
  'Por causa de sua condição de saúde, nos últimos 30 dias, quanta dificuldade você teve em:'
];

const List<String> titulosSecoes = [
  "*Seção 1*\n\nFolha de rosto",
  "*Seção 2*\n\nInformações gerais e demográficas",
  "*Seção 3*\n\nIntrodução",
  "*Seção 4*\n\nRevisão dos domínios",
];

const List<String> enunciadosDominiosParte1 = [
  'Nos últimos _30 dias_, quanta _dificuldade_ você teve em:',
  'Por causa de sua condição de saúde, nos últimos 30 dias, quanta dificuldade você teve em:',
  "Nos últimos 30 dias:"
];

const Map<String, String> enunciadosDominiosParte2 = {
  'dom_1':
      "Eu vou fazer agora algumas perguntas sobre _compreensão e comunicação._",
  'dom_2':
      "Agora vou perguntar para você sobre dificuldades de locomoção e ou movimentação.",
  'dom_3':
      "Agora eu vou perguntar a você sobre as dificuldades em cuidar de você mesmo(a).",
  'dom_4':
      """Agora eu vou perguntar a você sobre dificuldades nas _relações interpessoais_. 

Por favor, lembre-se que eu vou perguntar somente sobre as dificuldades decorrentes de problemas de saúde.

Por problemas de saúde eu quero dizer doenças, enfermidades, lesões, problemas emocionais ou mentais e problemas com álcool ou drogas.""",
  'dom_51':
      """Eu vou perguntar agora sobre atividades envolvidas na manutenção do seu lar e do cuidado com as pessoas com as quais você vive ou que são próximas a você. 

Essas atividades incluem cozinhar, limpar, fazer compras, cuidar de outras pessoas e cuidar dos seus pertences.""",
  'dom_52':
      "Agora eu farei algumas perguntas sobre suas atividades escolares ou do trabalho.",
  'dom_6':
      """Agora, eu vou perguntar a você sobre _sua participação social_ e o _impacto dos seus problemas de saúde_ sobre _você e sua família_. 

Algumas dessas perguntas podem envolver problemas que ultrapassam 30 dias, entretanto, ao responder, por favor, foque nos últimos 30 dias. 

De novo, quero lembrar-lhe de responder essas perguntas pensando em problemas de saúde: físico, mental ou emocional, relacionados a álcool ou drogas.""",
};

const List<String> enunciadosSecoes = [
  "*{color:black}Complete os itens F1-F5 antes de iniciar cada entrevista*",
  """Esta entrevista foi desenvolvida pela Organização Mundial da Saúde (OMS) para melhor compreender as dificuldades que as pessoas podem ter em decorrência de sua condição de saúde. 
As informações que você fornecer nessa entrevista são confidenciais e serão usadas exclusivamente para pesquisa. A entrevista terá duração de 15-20 minutos.

*{color:black}Para respondentes da população em geral (não a população clínica) diga:*

Mesmo se você for saudável e não tiver dificuldades, eu preciso fazer todas as perguntas do questionário para completar a entrevista.

Eu vou começar com algumas perguntas gerais.
""",
  """*{color:black}Diga ao(à) respondente:*

A entrevista é sobre as dificuldades que as pessoas têm por causa de suas condições de
saúde.

*{color:black}Dê o cartão resposta nº1 ao(à) respondente e diga:*

Por condições de saúde quero dizer doenças ou enfermidades, ou outros problemas de saúde
que podem ser de curta ou longa duração; lesões; problemas mentais ou emocionais; e
problemas com álcool ou drogas.

Lembre-se de considerar todos os seus problemas de saúde enquanto responde às questões.

Quando eu perguntar sobre a dificuldade em fazer uma atividade pense em ...

*{color:black}Aponte para o cartão resposta nº1 e explique que a “dificuldade em fazer uma atividade”
significa:*

• Esforço aumentado
• Desconforto ou dor
• Lentidão
• Alterações no modo de você fazer a atividade.

*{color:black}Diga ao(à) respondente*:

Quando responder, gostaria que você pensasse nos últimos 30 dias. Eu gostaria ainda que
você respondesse essas perguntas pensando em quanta dificuldade você teve, em média,
nos últimos 30 dias, enquanto você fazia suas atividades como você costuma fazer.

*{color:black}Dê o cartão resposta nº2 ao(à) respondente e diga:*

Use essa escala ao responder.

*{color:black}Leia a escala em voz alta:*

Nenhuma, leve, moderada, grave, extrema ou não consegue fazer.

*{color:black}Certifique-se de que o(a) respondente possa ver facilmente os cartões resposta nº1 e nº2 durante toda a entrevista.*
"""
];

List<Map<String, dynamic>> baseWHODAS = [
  {
    'enunciado': 'F1 - Número da identidade do entrevistado (opcional)',
    'tipo': TipoPergunta.extenso,
    'dominio': '',
    'codigo': 'F1',
    'validador': (value) {},
  },
  {
    'enunciado': 'F2 - Número da identidade do entrevistador (opcional)',
    'tipo': TipoPergunta.extenso,
    'dominio': '',
    'codigo': 'F2',
    'validador': (value) {},
  },
  {
    'enunciado': 'F3 - Número da Avaliação (opcional)',
    'tipo': TipoPergunta.extenso,
    'dominio': '',
    'codigo': 'F3',
  },
  {
    'enunciado': 'F4 - Data da Entrevista',
    'tipo': TipoPergunta.extenso,
    'dominio': '',
    'codigo': 'F4',
    'validador': (value) {
      try {
        DateFormat("dd/MM/yyyy").parse(value);
        return null;
      } catch (e) {
        return "Insira uma data válida";
      }
    },
  },
  {
    'enunciado': 'F5 - Condição em que vive no momento da entrevista',
    'tipo': TipoPergunta.multipla,
    'dominio': '',
    'codigo': 'F5',
    'opcoes': [
      'Independente na comunidade',
      'Vive com assistência',
      'Hospitalizado'
    ]
  },
  {
    'enunciado': 'A1 - Anote o sexo da pessoa conforme observado',
    'tipo': TipoPergunta.multipla,
    'opcoes': [
      "Feminino",
      "Masculino",
    ],
    'dominio': '',
    'codigo': 'A1',
  },
  {
    'enunciado': 'A2 - Qual a sua idade?',
    'tipo': TipoPergunta.extensoNumerico,
    'dominio': '',
    'codigo': 'A2',
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
    'enunciado':
        'A3 - Quantos anos no total você passou estudando em escola, faculdade ou universidade?',
    'tipo': TipoPergunta.extensoNumerico,
    'codigo': 'A3',
    'dominio': '',
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
    'enunciado': 'A4 - Qual é o seu estado civil atual?',
    'tipo': TipoPergunta.multipla,
    'dominio': '',
    'codigo': 'A4',
    'opcoes': [
      'Nunca se casou',
      'Atualmente casado(a)',
      'Separado(a)',
      'Divorciado(a)',
      'Viúvo(a)',
      'Mora junto',
    ],
  },
  {
    'enunciado':
        'A5 - Qual opção descreve melhor a situação da sua principal atividade de trabalho?',
    'tipo': TipoPergunta.multipla,
    'codigo': 'A5',
    'dominio': '',
    'opcoes': [
      'Trabalho remunerado',
      'Autônomo(a), por exemplo, é dono do próprio negócio ou trabalha na própria terra',
      'Trabalho não remunerado, como trabalho voluntário ou caridade',
      'Estudante',
      'Dona de casa',
      'Aposentado(a)',
      'Desempregado(a) (por problemas de saúde)',
      'Desempregado(a) (outras razões)',
      'Outros (especifique)'
    ],
  },
  {
    'enunciado':
        'D1.1 - Concentrar-se para fazer alguma coisa durante dez minutos?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'codigo': 'D1.1',
    'dominio': 'dom_1',
  },
  {
    'enunciado': 'D1.2 - Lembrar-se de fazer coisas importantes?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_1',
    'codigo': 'D1.2',
  },
  {
    'enunciado':
        'D1.3 - Analisar e encontrar soluções para problemas do dia-a-dia?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'codigo': 'D1.3',
    'dominio': 'dom_1',
  },
  {
    'enunciado':
        'D1.4 - Aprender uma nova tarefa, por exemplo, como chegar a um lugar desconhecido?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'codigo': 'D1.4',
    'dominio': 'dom_1',
  },
  {
    'enunciado': 'D1.5 - Compreender de forma geral o que as pessoas dizem?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_1',
    'codigo': 'D1.5',
  },
  {
    'enunciado': 'D1.6 - Começar e manter uma conversa?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_1',
    'codigo': 'D1.6',
  },
  {
    'enunciado': 'D2.1 - Ficar em pé por longos períodos como 30 minutos?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_2',
    'codigo': 'D2.1',
  },
  {
    'enunciado': 'D2.2 - Levantar-se a partir da posição sentada?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_2',
    'codigo': 'D2.2',
  },
  {
    'enunciado': 'D2.3 - Movimentar-se dentro de sua casa?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_2',
    'codigo': 'D2.3',
  },
  {
    'enunciado': 'D2.4 - Sair da sua casa?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_2',
    'codigo': 'D2.4',
  },
  {
    'enunciado': 'D2.5 - Andar por longas distâncias como por 1 quilômetro?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_2',
    'codigo': 'D2.5',
  },
  {
    'enunciado': 'D3.1 - Lavar seu corpo inteiro?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_3',
    'codigo': 'D3.1',
  },
  {
    'enunciado': 'D3.2 - Vestir-se?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_3',
    'codigo': 'D3.2',
  },
  {
    'enunciado': 'D3.3 - Comer?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_3',
    'codigo': 'D3.3',
  },
  {
    'enunciado':
        'D3.4 - Ficar sozinho sem a ajuda de outras pessoas por alguns dias?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'codigo': 'D3.4',
    'dominio': 'dom_3',
  },
  {
    'enunciado': 'D4.1 - Lidar com pessoas que você não conhece?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_4',
    'codigo': 'D4.1',
  },
  {
    'enunciado': 'D4.2 - Manter uma amizade?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_4',
    'codigo': 'D4.2',
  },
  {
    'enunciado': 'D4.3 - Relacionar-se com pessoas que são próximas a você?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_4',
    'codigo': 'D4.3',
  },
  {
    'enunciado': 'D4.4 - Fazer novas amizades?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_4',
    'codigo': 'D4.4',
  },
  {
    'enunciado': 'D4.5 - Ter atividades sexuais?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_4',
    'codigo': 'D4.5',
  },
  {
    'enunciado': 'D5.1 - Cuidar das suas responsabilidades domésticas?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_51',
    'codigo': 'D5.1',
  },
  {
    'enunciado':
        'D5.2 - Fazer bem as suas tarefas domésticas mais importantes?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'codigo': 'D5.2',
    'dominio': 'dom_51',
  },
  {
    'enunciado': 'D5.3 - Fazer todas as tarefas domésticas que você precisava?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_51',
    'codigo': 'D5.3',
  },
  {
    'enunciado': 'D5.4 - Fazer as tarefas domésticas na velocidade necessária?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_51',
    'codigo': 'D5.4',
  },
  {
    'enunciado':
        'D5.01 - Nos últimos 30 dias, quantos dias você reduziu ou deixou de fazer as tarefas domésticas por causa da sua condição de saúde?',
    'tipo': TipoPergunta.extensoNumerico,
    'codigo': 'D5.01',
    'dominio': 'dom_51',
    'validador': (value) {
      var caracteresValidos = RegExp(r'[0-9]');
      return value != ''
          ? int.parse(value) > 30 || caracteresValidos.hasMatch(value) == false
              ? 'Insira um número válido'
              : null
          : 'Dado obrigatório.';
    }
  },
  {
    'enunciado': 'D5.5 - Suas atividades diárias do trabalho/escola?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_52',
    'codigo': 'D5.5',
  },
  {
    'enunciado':
        'D5.6 - Realizar bem as atividades mais importantes do trabalho/escola?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'codigo': 'D5.6',
    'dominio': 'dom_52',
  },
  {
    'enunciado': 'D5.7 - Fazer todo o trabalho que você precisava?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_52',
    'codigo': 'D5.7',
  },
  {
    'enunciado': 'D5.8 - Fazer todo o trabalho na velocidade necessária?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_52',
    'codigo': 'D5.8',
  },
  {
    'enunciado':
        'D5.9 - Você já teve que reduzir a intensidade do trabalho por causa de uma condição de saúde?',
    'tipo': TipoPergunta.afirmativa,
    'codigo': 'D5.9',
    'dominio': 'dom_52',
  },
  {
    'enunciado':
        "D5.10 - Você ja ganhou menos dinheiro como resultado de uma condição de saúde?",
    'tipo': TipoPergunta.afirmativa,
    'codigo': 'D5.10',
    'dominio': 'dom_52',
  },
  {
    'enunciado':
        'D5.02 - Nos últimos 30 dias, por quantos dias você deixou de trabalhar por meio dia ou mais por causa da sua condição de saúde?',
    'tipo': TipoPergunta.extensoNumerico,
    'codigo': 'D5.02',
    'dominio': 'dom_52',
    'validador': (value) {
      var caracteresValidos = RegExp(r'[0-9]');
      return value != ''
          ? int.parse(value) > 30 || caracteresValidos.hasMatch(value) == false
              ? 'Insira um número válido'
              : null
          : 'Dado obrigatório.';
    }
  },
  {
    'enunciado':
        'D6.1 - Quanta dificuldade você teve ao participar em atividades comunitárias (por exemplo, festividades,  atividades religiosas ou outra atividade) do mesmo modo que qualquer outra pessoa?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'codigo': 'D6.1',
    'dominio': 'dom_6',
  },
  {
    'enunciado':
        'D6.2 - Quanta dificuldade você teve por causa de barreiras ou obstáculos no mundo à sua volta?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'codigo': 'D6.2',
    'dominio': 'dom_6',
  },
  {
    'enunciado':
        'D6.3 - Quanta dificuldade você teve para viver com dignidade por causa das atitudes e ações de outros?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'codigo': 'D6.3',
    'dominio': 'dom_6',
  },
  {
    'enunciado':
        'D6.4 - Quanto tempo você gastou com sua condição de saúde ou suas consequências?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'codigo': 'D6.4',
    'dominio': 'dom_6',
  },
  {
    'enunciado':
        'D6.5 - Quanto você tem sido emocionalmente afetado por sua condição de saúde?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'codigo': 'D6.5',
    'dominio': 'dom_6',
  },
  {
    'enunciado':
        'D6.6 - Quanto a sua saúde tem prejudicado financeiramente você ou sua família?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'codigo': 'D6.6',
    'dominio': 'dom_6',
  },
  {
    'enunciado':
        'D6.7 - Quanta dificuldade sua família teve por causa da sua condição de saúde?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'codigo': 'D6.7',
    'dominio': 'dom_6',
  },
  {
    'enunciado':
        'D6.8 - Quanta dificuldade você teve para fazer as coisas por si mesmo(a) para relaxamento ou lazer?',
    'tipo': TipoPergunta.multiplaWHODAS,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'codigo': 'D6.8',
    'dominio': 'dom_6',
  },
  {
    'enunciado':
        'H1 - Em geral, nos últimos 30 dias, por quantos dias essas dificuldades estiveram presentes?',
    'tipo': TipoPergunta.extensoNumerico,
    'codigo': 'H1',
    'dominio': '',
    'validador': (value) {
      var caracteresValidos = RegExp(r'[0-9]');
      return value != ''
          ? int.parse(value) > 30 || caracteresValidos.hasMatch(value) == false
              ? 'Insira um número válido'
              : null
          : 'Dado obrigatório.';
    }
  },
  {
    'enunciado':
        'H2 - Nos últimos 30 dias, por quantos dias você esteve completamente incapaz de executar suas atividades usuais ou de trabalho por causa da sua condição de saúde?',
    'tipo': TipoPergunta.extensoNumerico,
    'codigo': 'H2',
    'dominio': '',
    'validador': (value) {
      var caracteresValidos = RegExp(r'[0-9]');
      return value != ''
          ? int.parse(value) > 30 || caracteresValidos.hasMatch(value) == false
              ? 'Insira um número válido'
              : null
          : 'Dado obrigatório.';
    }
  },
  {
    'enunciado':
        'H3 - Nos últimos 30 dias, sem contar os dias que você esteve totalmente incapaz, por quantos dias você diminuiu ou reduziu suas atividades usuais ou de trabalho por causa da sua condição de saúde?',
    'tipo': TipoPergunta.extensoNumerico,
    'codigo': 'H3',
    'dominio': '',
    'validador': (value) {
      var caracteresValidos = RegExp(r'[0-9]');
      return value != ''
          ? int.parse(value) > 30 || caracteresValidos.hasMatch(value) == false
              ? 'Insira um número válido'
              : null
          : 'Dado obrigatório.';
    }
  },
];
