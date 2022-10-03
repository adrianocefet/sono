import 'package:sono/utils/models/pergunta.dart';

List<Map<String, dynamic>> baseCadastroUsuario = [
  {
    "enunciado": "Foto de perfil",
    'tipo': TipoPergunta.foto,
    'dominio': 'conversa',
    'codigo': 'url_foto_de_perfil',
  },
  {
    "enunciado": "Nome completo *",
    'tipo': TipoPergunta.extensoCadastros,
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
    'enunciado': "Instituição *",
    'tipo': TipoPergunta.dropdownCadastros,
    'codigo': 'instituicao',
    'opcoes': [
      'HGCC',
      'HGF',
      'HUWC',
      "HM",
    ],
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': "Perfil *",
    'tipo': TipoPergunta.dropdownCadastros,
    'codigo': 'perfil',
    'opcoes': [
      "Clínico",
      "Dispensação",
      "Gestão",
      "Vigilância",
    ],
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': "Profissão *",
    'tipo': TipoPergunta.dropdownCadastros,
    'codigo': 'profissao',
    'opcoes': [
      "Médico",
      "Fisioterapeuta",
    ],
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': "CPF *",
    'tipo': TipoPergunta.extensoNumericoCadastros,
    'dominio': 'conversa',
    'codigo': 'cpf',
    'validador': (value) => value != ''
        ? int.tryParse(value) == null
            ? 'Insira apenas números.'
            : null
        : 'Dado obrigatório.',
  },
];
