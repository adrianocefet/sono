import 'package:cloud_firestore/cloud_firestore.dart';

class Paciente {
  late final Map<String, dynamic> infoMap;
  late final String nome;
  late final String hospital;
  late final String? id;
  late final String? urlFotoDePerfil;
  late final List<String> equipamentosEmprestados;
  late final DateTime? dataDeNascimento;
  late final DateTime? dataDeCadastro;
  late final int? genero;
  late final String? endereco;
  late final String? telefone;
  late final String? escolaridade;
  late final String? profissao;
  late final double? peso;
  late final int? altura;
  late final double? circunferenciaDoPescoco;
  late final int? malampatti;
  late final bool? usaSmartphone;
  late final String? sintomas;
  late final String? dadosPolissonograficos;

  Paciente(this.infoMap) {
    nome = infoMap["Nome"] ?? infoMap["nome"];
    hospital = infoMap["Hospital"] ?? infoMap["hospital"];
    urlFotoDePerfil = infoMap["Foto"] ?? infoMap["foto"];
    id = infoMap["id"];
    equipamentosEmprestados = infoMap["equipamentos"];
  }

  Paciente.porDocumentSnapshot(DocumentSnapshot document) {
    infoMap = document.data() as Map<String, dynamic>;
    id = document.id;
    nome = infoMap["Nome"] ?? infoMap["nome"];
    hospital = infoMap["Hospital"] ?? infoMap["hospital"];
    urlFotoDePerfil = infoMap["Foto"] ?? infoMap["foto"];

    dataDeCadastro = (infoMap["data_de_cadastro"] as Timestamp?)?.toDate();
    genero = infoMap["genero"];
    endereco = infoMap["endereco"];
    telefone = infoMap["telefone"];
    escolaridade = infoMap["escolaridade"];
    profissao = infoMap["profissao"];
    altura = int.parse(infoMap["altura"]);
    peso = double.parse(infoMap["peso"]);
    circunferenciaDoPescoco =
        double.parse(infoMap["circunferencia_do_pescoco"]);
    malampatti = infoMap["malampatti"];
    usaSmartphone = infoMap["usa_smartphone"] == 1 ? true : false;
    sintomas = infoMap["sintomas"];
    dadosPolissonograficos = infoMap["dados_polissonograficos"];

    equipamentosEmprestados =
        List<String>.from((infoMap["equipamentos"] as List?) ?? <String>[]);
  }
}
