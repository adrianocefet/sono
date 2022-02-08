import 'package:flutter/material.dart';

abstract class Constants {
  static const Color corPrincipalQuestionarios = Colors.lime;
  static const double fontSizeEnunciados = 15.5;

  static const Color corAzulEscuroPrincipal = Color.fromRGBO(43, 56, 97, 1);
  static const Color corAzulEscuroSecundario = Color.fromRGBO(88, 98, 143, 1);

  static const alturaFotoDePerfil = 140.0;
  static const larguraFotoDePerfil = 140.0;

  static const domTotalColor = Color(0xff023e8a);
  static const dom1Color = Color(0XFF5a189a); //Colors.deepPurpleAccent;
  static const dom2Color = Color(0XFFd90816);
  static const dom3Color = Color(0XFF7f4f24);
  static const dom4Color = Color(0XFF028090);
  static const dom51Color = Color(0XFF386641);
  static const dom52Color = Color(0Xffe05780);
  static const dom6Color = Color(0XFFFF9D00);

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
    'total': Constants.domTotalColor,
    'dom_1': Constants.dom1Color,
    'dom_2': Constants.dom2Color,
    'dom_3': Constants.dom3Color,
    'dom_4': Constants.dom4Color,
    'dom_51': Constants.dom51Color,
    'dom_52': Constants.dom52Color,
    'dom_6': Constants.dom6Color,
  };
}
