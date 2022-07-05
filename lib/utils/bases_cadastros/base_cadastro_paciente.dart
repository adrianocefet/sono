import 'package:sono/utils/models/pergunta.dart';

List<Map<String, dynamic>> baseCadastroPaciente = [
  {
    "enunciado": "Foto de perfil",
    'tipo': TipoPergunta.foto,
    'dominio': '1',
    'codigo': 'foto_de_perfil',
  },
  {
    "enunciado": "Nome completo *",
    'tipo': TipoPergunta.extensoCadastros,
    'dominio': '1',
    'codigo': 'nome_completo',
    'validador': (value) {
      final caracteresValidos = RegExp(r'^[A-zÀ-ú\w ]');
      return value != ''
          ? caracteresValidos.hasMatch(value!)
              ? null
              : 'Insira um nome válido.'
          : 'Dado obrigatório.';
    },
  },
  {
    'enunciado': "Endereço *",
    'tipo': TipoPergunta.extensoCadastros,
    'dominio': '1',
    'codigo': 'endereço',
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': "CPF",
    'tipo': TipoPergunta.extensoNumericoCadastros,
    'dominio': '1',
    'codigo': 'cpf',
  },
  {
    'enunciado': "Data de Nascimento *",
    'tipo': TipoPergunta.data,
    'dominio': '1',
    'codigo': 'data_de_nascimento',
  },
  {
    'enunciado': "Telefone *",
    'tipo': TipoPergunta.extensoNumericoCadastros,
    'dominio': '1',
    'codigo': 'telefone',
    'validador': (value) {
      if (value == '' || value == null) return 'Dado obrigatório.';
      if (value.length < 11) return 'Número inválido.';
    },
  },
  {
    'enunciado': "Escolaridade",
    'tipo': TipoPergunta.dropdownCadastros,
    'opcoes': <String>[
      "Educação infantil",
      "Fundamental",
      "Médio",
      "Superior (Graduação)",
      "Pós-graduação",
      "Mestrado",
      "Doutorado",
      "Escola",
    ],
    'dominio': '2',
    'codigo': 'escolaridade',
  },
  {
    'enunciado': "Profissão",
    'tipo': TipoPergunta.extensoCadastros,
    'dominio': '2',
    'codigo': 'profissao',
  },
  {
    'enunciado': "Nome da mãe",
    'tipo': TipoPergunta.extensoCadastros,
    'dominio': '2',
    'codigo': 'nome_da_mae',
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': "Hospital *",
    'tipo': TipoPergunta.extensoNumericoCadastros,
    'dominio': '2',
    'codigo': 'hospital',
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': "Sexo *",
    'tipo': TipoPergunta.extensoNumericoCadastros,
    'dominio': '2',
    'codigo': 'sexo',
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': "Altura (cm) *",
    'tipo': TipoPergunta.extensoNumericoCadastros,
    'dominio': '2',
    'codigo': 'altura',
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': "Peso (kg) *",
    'tipo': TipoPergunta.extensoNumericoCadastros,
    'dominio': '2',
    'codigo': 'altura',
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': "Número do prontuário *",
    'tipo': TipoPergunta.extensoNumericoCadastros,
    'dominio': '3',
    'codigo': 'numero_prontuario',
  },
  {
    'enunciado': "Tem acesso a internet? *",
    'tipo': TipoPergunta.afirmativaCadastros,
    'dominio': '3',
    'codigo': 'acesso_a_internet',
  },
  {
    'enunciado': "O sinal telefônico em sua residência é estável?",
    'tipo': TipoPergunta.afirmativaCadastros,
    'dominio': '3',
    'codigo': 'sinal_telefonico_estavel',
  },
  {
    'enunciado': "Tem Whatsapp? *",
    'tipo': TipoPergunta.afirmativaCadastros,
    'dominio': '3',
    'codigo': 'tem_whatsapp',
  },
  {
    'enunciado': "Usa Smartphone? *",
    'tipo': TipoPergunta.afirmativaCadastros,
    'dominio': '3',
    'codigo': 'usa_smartphone',
  },
  {
    'enunciado': "Comorbidades *",
    'tipo': TipoPergunta.comorbidades,
    'dominio': '3',
    'codigo': 'comorbidades',
    'opcoes': [
      'Infarto no Miocárdio',
      'ICC',
      'AVC',
      'Demência',
      'Diabetes',
      'Hemiplegia',
      'Leucemia',
      'Doença Renal',
      'Linfoma',
      'AIDS',
      'Mestástase',
      'DPOC'
    ]
  },
];
