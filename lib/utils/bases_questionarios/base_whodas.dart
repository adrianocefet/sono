import 'package:sono/utils/models/pergunta.dart';

List<String> enunciadosDominios = [
  'Nos últimos 30 dias, quanta dificuldade você teve em:',
  'Por causa de sua condição de saúde, nos últimos 30 dias, quanta dificuldade você teve em:'
];

List<Map<String, dynamic>> baseWHODAS = [
  {
    'enunciado': 'Nome do entrevistado',
    'tipo': TipoPergunta.extenso,
    'pesos': <int>[],
    'dominio': '',
    'codigo': '',
    'validador': (value) {},
  },
  {
    'enunciado': 'F1 - Número da identidade do entrevistado (opcional)',
    'tipo': TipoPergunta.extenso,
    'pesos': <int>[],
    'dominio': '',
    'codigo': 'F1',
    'validador': (value) {},
  },
  {
    'enunciado': 'F2 - Número da identidade do entrevistador (opcional)',
    'tipo': TipoPergunta.extenso,
    'pesos': <int>[],
    'dominio': '',
    'codigo': 'F2',
    'validador': (value) {},
  },
  {
    'enunciado': 'F3 - Número da Avaliação (opcional)',
    'tipo': TipoPergunta.extenso,
    'pesos': <int>[],
    'dominio': '',
    'codigo': 'F3',
  },
  {
    'enunciado': 'F4 - Data da Entrevista',
    'tipo': TipoPergunta.extenso,
    'pesos': <int>[],
    'dominio': '',
    'codigo': 'F4',
  },
  {
    'enunciado': 'F5 - Condição em que vive no momento da entrevista',
    'tipo': TipoPergunta.multipla,
    'pesos': <int>[],
    'dominio': '',
    'codigo': 'F5',
    'opcoes': [
      'Independente na comunidade',
      'Vive com assistência',
      'Hospitalizado'
    ]
  },
  {
    'enunciado': 'A1 - Anote o sexo da pessoa conforme observado', //ESSA
    'tipo': TipoPergunta.extenso,
    'pesos': <int>[],
    'dominio': '',
    'codigo': 'A1',
  },
  {
    'enunciado': 'A2 - Qual a sua idade?', //ESSA
    'tipo': TipoPergunta.extenso,
    'pesos': <int>[],
    'dominio': '',
    'codigo': 'A2',
  },
  {
    'enunciado':
        'A3 - Quantos anos no total você passou estudando em escola, faculdade ou universidade?',
    'tipo': TipoPergunta.extenso,
    'pesos': <int>[],
    'codigo': 'A3',
    'dominio': '',
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': 'A4 - Qual é o seu estado civil atual?',
    'tipo': TipoPergunta.multipla,
    'pesos': <int>[],
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
    'pesos': <int>[],
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
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'codigo': 'D1.1',
    'dominio': 'dom_1',
  },
  {
    'enunciado': 'D1.2 - Lembrar-se de fazer coisas importantes?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_1',
    'codigo': 'D1.2',
  },
  {
    'enunciado':
        'D1.3 - Analisar e encontrar soluções para problemas do dia-a-dia?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'codigo': 'D1.3',
    'dominio': 'dom_1',
  },
  {
    'enunciado':
        'D1.4 - Aprender uma nova tarefa, por exemplo, como chegar a um lugar desconhecido?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'codigo': 'D1.4',
    'dominio': 'dom_1',
  },
  {
    'enunciado': 'D1.5 - Compreender de forma geral o que as pessoas dizem?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_1',
    'codigo': 'D1.5',
  },
  {
    'enunciado': 'D1.6 - Começar e manter uma conversa?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_1',
    'codigo': 'D1.6',
  },
  {
    'enunciado': 'D2.1 - Ficar em pé por longos períodos como 30 minutos?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_2',
    'codigo': 'D2.1',
  },
  {
    'enunciado': 'D2.2 - Levantar-se a partir da posição sentada?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_2',
    'codigo': 'D2.2',
  },
  {
    'enunciado': 'D2.3 - Movimentar-se dentro de sua casa?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_2',
    'codigo': 'D2.3',
  },
  {
    'enunciado': 'D2.4 - Sair da sua casa?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_2',
    'codigo': 'D2.4',
  },
  {
    'enunciado': 'D2.5 - Andar por longas distâncias como por 1 quilômetro?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_2',
    'codigo': 'D2.5',
  },
  {
    'enunciado': 'D3.1 - Lavar seu corpo inteiro?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_3',
    'codigo': 'D3.1',
  },
  {
    'enunciado': 'D3.2 - Vestir-se?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_3',
    'codigo': 'D3.2',
  },
  {
    'enunciado': 'D3.3 - Comer?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_3',
    'codigo': 'D3.3',
  },
  {
    'enunciado':
        'D3.4 - Ficar sozinho sem a ajuda de outras pessoas por alguns dias?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'codigo': 'D3.4',
    'dominio': 'dom_3',
  },
  {
    'enunciado': 'D4.1 - Lidar com pessoas que você não conhece?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_4',
    'codigo': 'D4.1',
  },
  {
    'enunciado': 'D4.2 - Manter uma amizade?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_4',
    'codigo': 'D4.2',
  },
  {
    'enunciado': 'D4.3 - Relacionar-se com pessoas que são próximas a você?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_4',
    'codigo': 'D4.3',
  },
  {
    'enunciado': 'D4.4 - Fazer novas amizades?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_4',
    'codigo': 'D4.4',
  },
  {
    'enunciado': 'D4.5 - Ter atividades sexuais?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_4',
    'codigo': 'D4.5',
  },
  {
    'enunciado': 'D5.1 - Cuidar das suas responsabilidades domésticas?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_51',
    'codigo': 'D5.1',
  },
  {
    'enunciado':
        'D5.2 - Fazer bem as suas tarefas domésticas mais importantes?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'codigo': 'D5.2',
    'dominio': 'dom_51',
  },
  {
    'enunciado': 'D5.3 - Fazer todas as tarefas domésticas que você precisava?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_51',
    'codigo': 'D5.3',
  },
  {
    'enunciado': 'D5.4 - Fazer as tarefas domésticas na velocidade necessária?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_51',
    'codigo': 'D5.4',
  },
  {
    'enunciado':
        'D5.01 - Nos últimos 30 dias, quantos dias você reduziu ou deixou de fazer as tarefas domésticas por causa da sua condição de saúde?',
    'tipo': TipoPergunta.extensoNumerico,
    'codigo': 'D5.01',
    'pesos': <int>[],
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
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'dominio': 'dom_52',
    'codigo': 'D5.5',
  },
  {
    'enunciado':
        'D5.6 - Realizar bem as atividades mais importantes do trabalho/escola?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'codigo': 'D5.6',
    'dominio': 'dom_52',
  },
  {
    'enunciado': 'D5.7 - Fazer todo o trabalho que você precisava?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_52',
    'codigo': 'D5.7',
  },
  {
    'enunciado': 'D5.8 - Fazer todo o trabalho na velocidade necessária?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'dominio': 'dom_52',
    'codigo': 'D5.8',
  },
  {
    'enunciado':
        'D5.9 - Você já teve que reduzir a intensidade do trabalho por causa de uma condição de saúde?',
    'tipo': TipoPergunta.afirmativa,
    'pesos': <int>[],
    'codigo': 'D5.9',
    'dominio': 'dom_52',
  },
  {
    'enunciado':
        "D5.10 - Você ja ganhou menos dinheiro como resultado de uma condição de saúde?",
    'tipo': TipoPergunta.afirmativa,
    'pesos': <int>[],
    'codigo': 'D5.10',
    'dominio': 'dom_52',
  },
  {
    'enunciado':
        'D5.02 - Nos últimos 30 dias, por quantos dias você deixou de trabalhar por meio dia ou mais por causa da sua condição de saúde?',
    'tipo': TipoPergunta.extensoNumerico,
    'codigo': 'D5.02',
    'pesos': <int>[],
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
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'codigo': 'D6.1',
    'dominio': 'dom_6',
  },
  {
    'enunciado':
        'D6.2 - Quanta dificuldade você teve por causa de barreiras ou obstáculos no mundo à sua volta?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'codigo': 'D6.2',
    'dominio': 'dom_6',
  },
  {
    'enunciado':
        'D6.3 - Quanta dificuldade você teve para viver com dignidade por causa das atitudes e ações de outros?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'codigo': 'D6.3',
    'dominio': 'dom_6',
  },
  {
    'enunciado':
        'D6.4 - Quanto tempo você gastou com sua condição de saúde ou suas consequências?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'codigo': 'D6.4',
    'dominio': 'dom_6',
  },
  {
    'enunciado':
        'D6.5 - Quanto você tem sido emocionalmente afetado por sua condição de saúde?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'codigo': 'D6.5',
    'dominio': 'dom_6',
  },
  {
    'enunciado':
        'D6.6 - Quanto a sua saúde tem prejudicado financeiramente você ou sua família?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'codigo': 'D6.6',
    'dominio': 'dom_6',
  },
  {
    'enunciado':
        'D6.7 - Quanta dificuldade sua família teve por causa da sua condição de saúde?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 2, 3, 4, 0],
    'codigo': 'D6.7',
    'dominio': 'dom_6',
  },
  {
    'enunciado':
        'D6.8 - Quanta dificuldade você teve para fazer as coisas por si mesmo(a) para relaxamento ou lazer?',
    'tipo': TipoPergunta.marcar,
    'pesos': <int>[0, 1, 1, 2, 2, 0],
    'codigo': 'D6.8',
    'dominio': 'dom_6',
  },
  {
    'enunciado':
        'H1 - Em geral, nos últimos 30 dias, por quantos dias essas dificuldades estiveram presentes?',
    'tipo': TipoPergunta.extenso,
    'pesos': <int>[],
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
    'pesos': <int>[],
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
    'pesos': <int>[],
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
