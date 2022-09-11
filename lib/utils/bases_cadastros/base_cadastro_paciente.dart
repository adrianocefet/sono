import 'package:sono/utils/models/pergunta.dart';

List<Map<String, dynamic>> baseCadastroPaciente = [
  {
    "enunciado": "Foto de perfil",
    'tipo': TipoPergunta.foto,
    'dominio': 'conversa',
    'codigo': 'url_foto_de_perfil',
  },
  {
    "enunciado": "Nome completo *",
    'tipo': TipoPergunta.extensoCadastros,
    'dominio': 'conversa',
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
    'dominio': 'conversa',
    'codigo': 'data_de_nascimento',
  },
  {
    'enunciado': "Sexo *",
    'tipo': TipoPergunta.dropdownCadastros,
    'dominio': 'conversa',
    'codigo': 'sexo',
    'opcoes': ['Masculino', 'Feminino'],
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': "Número do prontuário *",
    'tipo': TipoPergunta.extensoCadastros,
    'dominio': 'conversa',
    'codigo': 'numero_prontuario',
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': "Endereço *",
    'tipo': TipoPergunta.extensoCadastros,
    'dominio': 'conversa',
    'codigo': 'endereco',
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': "Nome da mãe",
    'tipo': TipoPergunta.extensoCadastros,
    'dominio': 'conversa',
    'codigo': 'nome_da_mae',
  },
  {
    'enunciado': "CPF",
    'tipo': TipoPergunta.numericaCadastros,
    'dominio': 'conversa',
    'codigo': 'cpf',
  },
  {
    'enunciado': "E-mail",
    'tipo': TipoPergunta.extensoCadastros,
    'dominio': 'conversa',
    'codigo': 'email',
  },
  {
    'enunciado': "Telefone principal",
    'tipo': TipoPergunta.numericaCadastros,
    'dominio': 'conversa',
    'codigo': 'telefone_principal',
  },
  {
    'enunciado': "Telefone secundário",
    'tipo': TipoPergunta.numericaCadastros,
    'dominio': 'conversa',
    'codigo': 'telefone_secundario',
  },
  {
    'enunciado': "Escolaridade",
    'tipo': TipoPergunta.dropdownCadastros,
    'opcoes': <String>[
      "Analfabeto",
      "Ensino fundamento incompleto",
      "Ensino fundamental completo",
      "Ensino superior incompleto",
      "Ensino medio completo",
      "Pós-graduação",
      "Mestrado/Doutorado"
    ],
    'dominio': 'conversa',
    'codigo': 'escolaridade',
  },
  {
    'enunciado': "Profissão",
    'tipo': TipoPergunta.extensoCadastros,
    'dominio': 'conversa',
    'codigo': 'profissao',
  },
  {
    'enunciado': "O sinal telefônico em sua residência é estável? *",
    'tipo': TipoPergunta.afirmativaCadastros,
    'dominio': 'conversa',
    'codigo': 'sinal_telefonico_estavel',
  },
  {
    'enunciado': "Tem acesso à internet? *",
    'tipo': TipoPergunta.afirmativaCadastros,
    'dominio': 'conversa',
    'codigo': 'acesso_a_internet',
  },
  {
    'enunciado': "Usa smartphone? *",
    'tipo': TipoPergunta.afirmativaCadastros,
    'dominio': 'conversa',
    'codigo': 'usa_smartphone',
  },
  {
    'enunciado': "Tem Whatsapp? *",
    'tipo': TipoPergunta.afirmativaCadastros,
    'dominio': 'conversa',
    'codigo': 'tem_whatsapp',
  },
  {
    'enunciado': "É trabalhador de turno? *",
    'tipo': TipoPergunta.afirmativaCadastros,
    'dominio': 'conversa',
    'codigo': 'trabalhador_de_turno',
  },
  {
    'enunciado': "Altura (m) *",
    'tipo': TipoPergunta.numericaCadastros,
    'dominio': 'exame fisico',
    'codigo': 'altura',
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': "Peso (kg) *",
    'tipo': TipoPergunta.numericaCadastros,
    'dominio': 'exame fisico',
    'codigo': 'peso',
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': "Circunferencia do pescoço (cm) *",
    'tipo': TipoPergunta.numericaCadastros,
    'dominio': 'exame fisico',
    'codigo': 'circunferencia_do_pescoco',
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': "Mallampati *",
    'tipo': TipoPergunta.mallampati,
    'dominio': 'exame fisico',
    'codigo': 'mallampati',
    'validador': (value) => value != '' ? null : 'Dado obrigatório.',
  },
  {
    'enunciado': "Comorbidades *",
    'tipo': TipoPergunta.comorbidades,
    'dominio': 'exame fisico',
    'codigo': 'comorbidades',
    'opcoes': [
      'Nenhuma',
      "Acidente Vascular Cerebral",
      "Anemia",
      "Arritmias",
      "Asma",
      "Bronquite",
      "Cefaleia",
      "Cirurgia otorrinolaringológica prévia",
      "Desvio de septo",
      "Demência",
      "Diabetes",
      "Dislipidemia",
      "Doença hepática",
      "Doença do Refluxo Gastroesofágico",
      "Doença vascular periférica",
      "DPOC",
      "Depressão",
      "Epilepsia",
      "Etilismo",
      "HAS",
      "Hipertensão arterial sistêmica",
      "Hipotireoidismo",
      "Hipotensão arterial sistêmica",
      "Impotência sexual",
      "Infarto Agudo do Miocárdio",
      "Insônia",
      "Insuficiência Cardíaca Congestiva",
      "Insuficiência Hepática",
      "Insuficiência Renal Crônica",
      "Leucemia",
      "Policitemia",
      "Rinite alérgica",
      "SIDA",
      "Sinusite",
      "Tabagismo",
      "Transplante",
      "Transtorno de Ansiedade",
      "Tumor metastático",
      "Tumor não metastático",
      "Úlcera péptica",
    ]
  },
];
