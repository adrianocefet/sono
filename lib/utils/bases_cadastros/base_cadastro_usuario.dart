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
    'enunciado': "Data de Nascimento *",
    'tipo': TipoPergunta.data,
    'codigo': 'data_de_cadastro',
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
    'dominio': 'conversa',
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
    'enunciado': "CPF *",
    'tipo': TipoPergunta.extensoNumericoCadastros,
    'dominio': 'conversa',
    'codigo': 'cpf',
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
];
