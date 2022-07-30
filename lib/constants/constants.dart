import 'package:flutter/material.dart';

abstract class Constantes {
  static const Color corPrincipalQuestionarios =
      Color.fromARGB(255, 137, 206, 123);
  static const Color corSecundariaQuestionarios =
      Color.fromARGB(221, 18, 63, 9);

  static const double fontSizeEnunciados = 15.5;

  static const Color corAzulEscuroPrincipal = Color.fromRGBO(65, 69, 171, 1);
  static const Color corAzulEscuroSecundario = Color.fromRGBO(165, 166, 246, 1);
  static const Color corVerdeClaroPrincipal = Color.fromRGBO(206, 253, 178, 1);
  static const Color corCinzaPrincipal = Color.fromRGBO(196, 196, 196, 1);

  static const alturaFotoDePerfil = 140.0;
  static const larguraFotoDePerfil = 140.0;

  static const domTotalColor = Color(0xff023e8a);
  static const dom1Color = Color(0XFF5a189a);
  static const dom2Color = Color(0XFFd90816);
  static const dom3Color = Color(0XFF7f4f24);
  static const dom4Color = Color(0XFF028090);
  static const dom51Color = Color(0XFF386641);
  static const dom52Color = Color(0Xffe05780);
  static const dom6Color = Color(0XFFFF9D00);

  static const nomesQuestionarios = [
    "Berlin",
    "Stop-Bang",
    "SACS-BR",
    "WHODAS",
    "GOAL",
    "Pittsburg",
    "Epworth"
  ];

  static const codigosQuestionarios = [
    "berlin",
    "stopbang",
    "sacsbr",
    "whodas",
    "goal",
    "pittsburg",
    "epworth"
  ];

  static const codigosDominiosWHODAS = [
    'total',
    'dom_1',
    'dom_2',
    'dom_3',
    'dom_4',
    'dom_51',
    'dom_52',
    'dom_6'
  ];

  static const sexos = [
    "Masculino",
    "Feminino",
    "Outro",
  ];

  static const List<String> titulosAtributosPacientes = [
    'Nome',
    'Modo',
    'Pressão definida',
    'EPR',
    'Utilização',
    'Fuga mediana',
    'Fuga %95',
    'Fuga máxima',
    'IAH',
    'IA',
    'IH',
    'Índice de apneia central',
    'Índice de apneia obstrutiva',
    'Índice de apneia desconhecida',
    'RERA',
    'Respiração de Cheyne-Stockes',
  ];

  static const List<String> titulosAtributosEquipamentos = [
    'Nome',
    'Descrição',
    'Equipamento',
    'Status',
  ];

  static const Map<String, String> nomesDominiosWHODASMap = {
    'dom_1': 'Cognição',
    'dom_2': 'Mobilidade',
    'dom_3': 'Auto-cuidado',
    'dom_4': 'Relações interpessoais',
    'dom_51': 'Atividades domésticas',
    'dom_52': 'Atividades escolares ou trabalho',
    'dom_6': 'Participação'
  };

  static const Map<String, String> titulosDominiosWHODASMap = {
    'dom_1': 'Domínio 1',
    'dom_2': 'Domínio 2',
    'dom_3': 'Domínio 3',
    'dom_4': 'Domínio 4',
    'dom_51': 'Domínio 5.1',
    'dom_52': 'Domínio 5.2',
    'dom_6': 'Domínio 6'
  };

  static const Map coresDominiosWHODASMap = {
    'total': Constantes.domTotalColor,
    'dom_1': Constantes.dom1Color,
    'dom_2': Constantes.dom2Color,
    'dom_3': Constantes.dom3Color,
    'dom_4': Constantes.dom4Color,
    'dom_51': Constantes.dom51Color,
    'dom_52': Constantes.dom52Color,
    'dom_6': Constantes.dom6Color,
  };
  static const List<String> status = [
    'Disponível',
    'Empréstimos',
    'Reparos',
    'Desinfecção'
  ];
  static const List<String> status2 = [
    'Disponível',
    'Emprestado',
    'Manutenção',
    'Desinfecção'
  ];
  static const List<String> status3 = [
    'disponível',
    'em empréstimo',
    'em reparo',
    'em desinfecção'
  ];
  static const List<Color> cor=[
    Color.fromARGB(255, 51, 255, 58),Colors.yellow,Colors.red,Color.fromARGB(255, 0, 225, 255)
  ];
  static const List<IconData> icone=[
    Icons.check,Icons.people_sharp,Icons.build_rounded,Icons.clean_hands_sharp
  ];
  static const List<String> tipo=[
    'Máscara Nasal','Máscara Oronasal','Máscara Pillow','Máscara Facial','Aparelho PAP','Almofada','Fixador','Traqueia'
  ];
}
