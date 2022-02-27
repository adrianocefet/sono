import 'package:cloud_firestore/cloud_firestore.dart';

class Paciente {
  late final Map<String, dynamic> infoMap;
  late final String nome;
  late final String hospital;
  late final String? id;
  late final String? urlFotoDePerfil;
  late final List<String> equipamentosEmprestados;

  Paciente(this.infoMap) {
    nome = infoMap["Nome"];
    hospital = infoMap["Hospital"];
    urlFotoDePerfil = infoMap["Foto"];
    id = infoMap["id"];
    equipamentosEmprestados = infoMap["equipamentos"];
  }

  Paciente.porDocumentSnapshot(DocumentSnapshot document) {
    id = document.id;
    infoMap = document.data() as Map<String, dynamic>;
    nome = infoMap["Nome"];
    hospital = infoMap["Hospital"];
    urlFotoDePerfil = infoMap["Foto"];
    equipamentosEmprestados =
        List<String>.from((infoMap["equipamentos"] as List?) ?? <String>[]);
  }
}
