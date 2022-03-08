import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sono/utils/models/paciente.dart';

import '../models/equipamento.dart';

class FirebaseService {
  static final FirebaseService _firebaseService = FirebaseService._internal();

  factory FirebaseService() {
    return _firebaseService;
  }

  FirebaseService._internal();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static const String _stringPaciente = 'Paciente';
  static const String _stringEquipamento = "Equipamento";

  Future<Paciente> obterPacientePorID(String idPaciente) async {
    return await _db.collection(_stringPaciente).doc(idPaciente).get().then(
          (document) => Paciente.porDocumentSnapshot(
            document,
          ),
        );
  }

  Future<Equipamento> obterEquipamentoPorID(String idEquipamento) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection(_stringEquipamento).doc(idEquipamento).get();

    Map<String, dynamic> dadosEquipamento = snapshot.data()!;
    dadosEquipamento["id"] = idEquipamento;

    return Equipamento.porMap(
      dadosEquipamento,
    );
  }

  static Future<void> atualizarEquipamento(
      Equipamento equipamentoAtualizado) async {
    Map<String, dynamic> dadosAtualizados = equipamentoAtualizado.infoMap;
    dadosAtualizados.remove("id");

    await FirebaseFirestore.instance
        .collection('Equipamento')
        .doc(equipamentoAtualizado.id)
        .update(
          equipamentoAtualizado.infoMap,
        );
  }

  Future<String> adicionarEquipamentoAoBancoDeDados(
      Map<String, dynamic> dadosDoEquipamento,
      {File? fotoDePerfil}) async {
    String idEquipamento = _db.collection(_stringEquipamento).doc().id;
    String urlImagem = '';

    try {
      if (fotoDePerfil != null) {
        urlImagem = await FirebaseService()
            .adicionarImageDoEquipamentoAoFirebaseStorage(
          imageFile: fotoDePerfil,
          idEquipamento: idEquipamento,
        );
      }
      if (urlImagem.isNotEmpty) dadosDoEquipamento['Foto'] = urlImagem;

      await _db
          .collection(_stringEquipamento)
          .doc(idEquipamento)
          .set(dadosDoEquipamento);
    } catch (e) {
      rethrow;
    }

    return idEquipamento;
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> streamEquipamento(
    String idEquipamento,
  ) {
    return FirebaseFirestore.instance
        .collection('Equipamento')
        .doc(idEquipamento)
        .snapshots();
  }

  Future<void> emprestarEquipamento(
    Equipamento equipamento,
    Paciente paciente,
  ) async {
    try {
      await _db.collection(_stringEquipamento).doc(equipamento.id).update(
        {
          "status": equipamento.status.emString,
          "paciente_responsavel": paciente.id,
          "data_de_expedicao": FieldValue.serverTimestamp(),
        },
      );

      await _db.collection(_stringPaciente).doc(paciente.id).update(
        {
          "equipamentos": FieldValue.arrayUnion([equipamento.id])
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> devolverEquipamento(
    Equipamento equipamento,
  ) async {
    try {
      await _db.collection(_stringEquipamento).doc(equipamento.id).update(
        {
          "status": StatusDoEquipamento.disponivel.emString,
          "paciente_responsavel": FieldValue.delete(),
          "data_de_expedicao": FieldValue.delete(),
        },
      );

      await _db
          .collection(_stringPaciente)
          .doc(equipamento.idPacienteResponsavel)
          .update(
        {
          "equipamentos": FieldValue.arrayRemove([equipamento.id]),
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> procurarEquipamentoNoBancoDeDados(
      Map<String, dynamic> data) async {
    String? idEquipamento;

    QuerySnapshot query = await _db
        .collection(_stringPaciente)
        .where("Nome", isEqualTo: data['Nome'])
        .where("Hospital", isEqualTo: data["Hospital"])
        .get();

    if (query.docs.isNotEmpty) idEquipamento = query.docs[0].id;

    return idEquipamento;
  }

  Future removerPaciente(String idPaciente) async {
    await _db.collection(_stringPaciente).doc(idPaciente).delete();
    try {
      await deletarImagemDoFirebaseStorage(idPaciente);
    } on Exception {}
  }

  Future<String?> procurarPacienteNoBancoDeDados(
      Map<String, dynamic> data) async {
    String? idPaciente;

    QuerySnapshot query = await _db
        .collection(_stringPaciente)
        .where("Nome", isEqualTo: data['Nome'])
        .where("Hospital", isEqualTo: data["Hospital"])
        .get();

    if (query.docs.isNotEmpty) idPaciente = query.docs[0].id;

    return idPaciente;
  }

  Future removerEquipamento(String idEquipamento) async {
    await _db.collection(_stringPaciente).doc(idEquipamento).delete();
    try {
      await deletarImagemDoFirebaseStorage(idEquipamento);
      // ignore: empty_catches
    } on Exception {}
  }

  Future<String> uploadDadosDoPaciente(Map<String, dynamic> data,
      {File? fotoDePerfil}) async {
    String idPaciente = _db.collection(_stringPaciente).doc().id;
    String urlImagem = '';

    try {
      if (fotoDePerfil != null) {
        urlImagem =
            await FirebaseService().adicionarImageDoPacienteAoFirebaseStorage(
          imageFile: fotoDePerfil,
          idPaciente: idPaciente,
        );
      }
      if (urlImagem.isNotEmpty) data['Foto'] = urlImagem;

      await _db.collection(_stringPaciente).doc(idPaciente).set(data);
    } catch (e) {
      rethrow;
    }

    return idPaciente;
  }

  Future<String> updateDadosDoPaciente(
      Map<String, dynamic> data, String idPaciente) async {
    try {
      await _db.collection(_stringPaciente).doc(idPaciente).update(data);
    } catch (e) {
      rethrow;
    }

    return idPaciente;
  }

  Future<String> adicionarImageDoPacienteAoFirebaseStorage({
    required File imageFile,
    String? idPaciente,
  }) async {
    Reference ref = _storage.ref(
      '$_stringPaciente/perfil_$idPaciente',
    );
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<String> adicionarImageDoEquipamentoAoFirebaseStorage({
    required File imageFile,
    String? idEquipamento,
  }) async {
    Reference ref = _storage.ref(
      '$_stringEquipamento/perfil_$idEquipamento',
    );
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future deletarImagemDoFirebaseStorage(String idElemento) async {
    Reference ref = _storage.ref(
      "fotos_de_perfil/perfil_$idElemento",
    );

    await ref.delete();
  }
}
