
import 'package:sono/utils/models/pergunta.dart';

List<Map<String, dynamic>> baseRegistroPaciente = [
  {
    'enunciado': 'Foto do Paciente (opcional)',
    'codigo': 'foto_perfil',
    'tipo': TipoPergunta.foto,
    'validador': (value) {},
  },
  {
    'enunciado': 'Nome Completo',
    'codigo': 'nome_completo',
    'tipo': TipoPergunta.extenso,
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
    'enunciado': 'Data de Nascimento',
    'codigo': 'data_de_nascimento',
    'tipo': TipoPergunta.data,
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': 'Telefone',
    'codigo': 'telefone',
    'tipo': TipoPergunta.extensoNumerico,
    'validador': (value) {
      if (value == '' || value == null) return 'Dado obrigatório.';
      if (value.length < 11) return 'Número inválido.';
    },
  },
  {
    'enunciado': 'Email',
    'codigo': 'email',
    'tipo': TipoPergunta.extenso,
    'validador': (value) => value != ''
        ? (value as String).contains('@') &&
                value.length >= 3 &&
                value.contains(' ') == false
            ? null
            : "Insira um email válido"
        : 'Dado obrigatório.',
  },
  {
    'enunciado': 'Sexo',
    'codigo': 'sexo',
    'tipo': TipoPergunta.dropdown,
    'opcoes': ['Masculino', 'Feminino', 'Outro'],
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
];
