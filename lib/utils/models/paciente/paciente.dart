import 'package:cloud_firestore/cloud_firestore.dart';

class Paciente {
  late final Map<String, dynamic> infoMap;
  late final String nome;
  late final String hospital;
  late final String? id;
  late final String? urlFotoDePerfil;

  Paciente(this.infoMap) {
    nome = infoMap["Nome"];
    hospital = infoMap["Hospital"];
    urlFotoDePerfil = infoMap["Foto"];
  }

  Paciente.porDocumentSnapshot(DocumentSnapshot document) {
    id = document.id;
    infoMap = document.data() as Map<String, dynamic>;
    nome = infoMap["Nome"];
    hospital = infoMap["Hospital"];
    urlFotoDePerfil = infoMap["Foto"];
  }
}
