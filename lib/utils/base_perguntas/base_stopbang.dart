import 'package:sono/utils/models/pergunta.dart';

List<Map<String, dynamic>> baseWHODAS = [
  {
    'enunciado': """*Roncos?*
Você ronca alto (alto o suficiente que pode ser ouvido através de portas fechadas ou seu companheiro cutuca você à noite para parar de roncar)?""",
    'tipo': TipoPergunta.afirmativa,
    'pesos': <int>[],
    'dominio': '',
    'codigo': '',
    'validador': (value) {},
  },
  {
    'enunciado': """*Cansado?*
Você frequentemente se sente cansado, exausto ou sonolento durante o dia (como, por exemplo, adormecer enquanto dirige)? """,
    'tipo': TipoPergunta.afirmativa,
    'pesos': <int>[],
    'dominio': '',
    'codigo': '',
    'validador': (value) {},
  },
  {
    'enunciado': """*Observou?*
Alguém observou que você para de respirar ou engasga/fica ofegante durante o seu sono?""",
    'tipo': TipoPergunta.afirmativa,
    'pesos': <int>[],
    'dominio': '',
    'codigo': '',
    'validador': (value) {},
  },
  {
    'enunciado': """*Pressão?*
    Você tem ou está sendo tratado para pressão sanguínea alta?""",
    'tipo': TipoPergunta.afirmativa,
    'pesos': <int>[],
    'dominio': '',
    'codigo': '',
    'validador': (value) {},
  },
  {
    'enunciado': "*Índice de massa corporal maior que 35 kg/m2?*",
    'tipo': TipoPergunta.afirmativa,
    'pesos': <int>[],
    'dominio': '',
    'codigo': '',
    'validador': (value) {},
  },
  {
    'enunciado': "*Idade acima de 50 anos?*",
    'tipo': TipoPergunta.afirmativa,
    'pesos': <int>[],
    'dominio': '',
    'codigo': 'F1',
    'validador': (value) {},
  },
  {
    'enunciado': """*O pescoço é grosso? (Medida em volta do pomo de Adão)*
Para homens, o colarinho da sua camisa é de 43 cm ou mais?
Para mulheres, o colarinho da sua camisa é de 41 cm ou mais?""",
    'tipo': TipoPergunta.afirmativa,
    'pesos': <int>[],
    'dominio': '',
    'codigo': "",
    'validador': (value) {},
  },
  {
    'enunciado': "*Sexo = Masculino?*",
    'tipo': TipoPergunta.afirmativa,
    'pesos': <int>[],
    'dominio': '',
    'codigo': 'F1',
    'validador': (value) {},
  },
];
