import '../models/pergunta.dart';

List<Map<String, dynamic>> baseGOAL = [
  {
    "enunciado": "Gênero masculino?",
    'tipo': TipoPergunta.afirmativa,
    'dominio': '1',
    'codigo': 'genero',
  },
  {
    'enunciado':
        "Obesidade? Indice de Massa Corporal maior ou igual a 30kg/m²?",
    'tipo': TipoPergunta.afirmativa,
    'dominio': '2',
    'codigo': 'imc',
  },
  {
    'enunciado': "Idade maior ou igual a 50 anos?",
    'tipo': TipoPergunta.afirmativa,
    'dominio': '3',
    'codigo': 'idade',
  },
  {
    'enunciado': "Ronco alto?",
    'tipo': TipoPergunta.afirmativa,
    'dominio': '4',
    'codigo': 'ronco_alto',
  },
];
