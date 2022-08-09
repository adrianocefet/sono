import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sono/pages/questionarios/berlin/questionario/berlin.dart';
import 'package:sono/pages/questionarios/epworth/questionario/epworth_view.dart';
import 'package:sono/pages/questionarios/goal/questionario/goal.dart';
import 'package:sono/pages/questionarios/pittsburg/questionario/pittsburg_view.dart';
import 'package:sono/pages/questionarios/sacs_br/questionario/sacs_br.dart';
import 'package:sono/pages/questionarios/stop_bang/questionario/stop_bang.dart';
import 'package:sono/pages/questionarios/whodas/questionario/whodas_view.dart';
import 'package:sono/utils/models/paciente.dart';
import '../../globais/global.dart';
import '../models/equipamento.dart';

class FirebaseService {
  static final FirebaseService _firebaseService = FirebaseService._internal();

  factory FirebaseService() {
    return _firebaseService;
  }

  FirebaseService._internal();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static const String _strPacientes = 'pacientes';
  static const String _stringEquipamento = "equipamentos";
  static const String _stringQuestionarios = "questionarios";

  Future<Paciente> obterPacientePorID(String idPaciente) async {
    return await _db.collection(_strPacientes).doc(idPaciente).get().then(
          (document) => Paciente.porDocumentSnapshot(
            document,
          ),
        );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamInfoPacientePorID(
      String idPaciente) {
    return _db.collection(_strPacientes).doc(idPaciente).snapshots();
  }

  Future<Equipamento?> obterEquipamentoPorID(String idEquipamento) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection(_stringEquipamento).doc(idEquipamento).get();

    Map<String, dynamic>? dadosEquipamento = snapshot.data();
    dadosEquipamento?["id"] = idEquipamento;

    return dadosEquipamento == null
        ? null
        : Equipamento.porMap(
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

      final Map<String, dynamic> data = {
        'Tamanhos': exportarListaDeTamanhos(),
      };

      await _db.collection(_stringEquipamento).doc(idEquipamento).update(data);
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

      await _db.collection(_strPacientes).doc(paciente.id).update(
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
          .collection(_strPacientes)
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

  Future<void> desinfectarEquipamento(Equipamento equipamento) async {
    try {
      await _db.collection(_stringEquipamento).doc(equipamento.id).update(
        {
          "status": StatusDoEquipamento.desinfeccao.emString,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> repararEquipamento(Equipamento equipamento) async {
    try {
      await _db.collection(_stringEquipamento).doc(equipamento.id).update(
        {
          "status": StatusDoEquipamento.manutencao.emString,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> disponibilizarEquipamento(Equipamento equipamento) async {
    try {
      await _db.collection(_stringEquipamento).doc(equipamento.id).update(
        {
          "status": StatusDoEquipamento.disponivel.emString,
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
        .collection(_strPacientes)
        .where("Nome", isEqualTo: data['Nome'])
        .where("Hospital", isEqualTo: data["Hospital"])
        .get();

    if (query.docs.isNotEmpty) idEquipamento = query.docs[0].id;

    return idEquipamento;
  }

  Future removerEquipamento(String idEquipamento) async {
    DocumentSnapshot<Map<String, dynamic>> info =
        await _db.collection(_stringEquipamento).doc(idEquipamento).get();
    if (info["status"] == "Emprestado") {
      Map<String, dynamic> dadosEquipamento = info.data()!;
      dadosEquipamento["id"] = info.id;

      await devolverEquipamento(
        Equipamento.porMap(
          dadosEquipamento,
        ),
      );
    }

    await _db.collection(_stringEquipamento).doc(idEquipamento).delete();
    try {
      await deletarImagemDoFirebaseStorage(idEquipamento);
      // ignore: empty_catches
    } on Exception {}
  }

  Future removerPaciente(String idPaciente) async {
    await _db.collection(_strPacientes).doc(idPaciente).delete();
    try {
      await deletarImagemDoFirebaseStorage(idPaciente);
    } on Exception {}
  }

  Future<String?> procurarPacienteNoBancoDeDados(
      Map<String, dynamic> data) async {
    String? idPaciente;

    QuerySnapshot query = await _db
        .collection(_strPacientes)
        .where("nome_completo", isEqualTo: data["nome_completo"])
        .get();

    if (query.docs.isNotEmpty) idPaciente = query.docs[0].id;

    return idPaciente;
  }

  Future<String> uploadDadosDoPaciente(Map<String, dynamic> data,
      {File? fotoDePerfil}) async {
    String idPaciente = _db.collection(_strPacientes).doc().id;
    String urlImagem = '';

    try {
      if (fotoDePerfil != null) {
        urlImagem =
            await FirebaseService().adicionarImageDoPacienteAoFirebaseStorage(
          imageFile: fotoDePerfil,
          idPaciente: idPaciente,
        );
      }
      if (urlImagem.isNotEmpty) data['url_foto_de_perfil'] = urlImagem;

      await _db.collection(_strPacientes).doc(idPaciente).set(data);
    } catch (e) {
      rethrow;
    }

    return idPaciente;
  }

  Future<String> updateDadosDoPaciente(
      Map<String, dynamic> data, String idPaciente,
      {File? fotoDePerfil}) async {
    String? urlImagem;

    if (fotoDePerfil != null) {
      await deletarImagemDoFirebaseStorage(idPaciente);

      urlImagem =
          await FirebaseService().adicionarImageDoPacienteAoFirebaseStorage(
        idPaciente: idPaciente,
        imageFile: fotoDePerfil,
      );
    } else {
      await deletarImagemDoFirebaseStorage(idPaciente);
    }

    data['url_foto_de_perfil'] = urlImagem;
    await _db.collection(_strPacientes).doc(idPaciente).update(data);

    return idPaciente;
  }

  Future<void> salvarQuestionarioDoPaciente(Paciente paciente,
      dynamic tipoQuestionario, Map<String, dynamic> resultado) async {
    String nomeDoQuestionario = "";
    switch (tipoQuestionario) {
      case Berlin:
        nomeDoQuestionario = "berlin";
        break;
      case StopBang:
        nomeDoQuestionario = "stopbang";
        break;
      case SacsBR:
        nomeDoQuestionario = "sacsbr";
        break;
      case WHODAS:
        nomeDoQuestionario = "whodas";
        break;
      case GOAL:
        nomeDoQuestionario = "goal";
        break;
      case Pittsburg:
        nomeDoQuestionario = "pittsburg";
        break;
      case Epworth:
        nomeDoQuestionario = "epworth";
        break;
    }

    _db
        .collection(_strPacientes)
        .doc(paciente.id)
        .collection(_stringQuestionarios)
        .doc(nomeDoQuestionario)
        .set(
      {
        DateTime.now().toString(): resultado,
      },
      SetOptions(merge: true),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamQuestionarios(
      String idPaciente) {
    return _db
        .collection(_strPacientes)
        .doc(idPaciente)
        .collection(_stringQuestionarios)
        .snapshots();
  }

  Future<String> adicionarImageDoPacienteAoFirebaseStorage({
    required File imageFile,
    String? idPaciente,
  }) async {
    Reference ref = _storage.ref(
      '$_strPacientes/perfil_$idPaciente',
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
      "$_strPacientes/perfil_$idElemento",
    );

    try {
      await ref.delete();
    } on Exception {}
  }

  Future<XFile?> selecionarArquivoGaleria() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  Future<XFile?> selecionarArquivoCamera() async {
    return await ImagePicker().pickImage(source: ImageSource.camera);
  }

  Future<String> uparArquivoEquipamento(
      XFile imagem, String idEquipamento) async {
    Reference db = FirebaseStorage.instance
        .ref("$_stringEquipamento/perfil_$idEquipamento");
    await db.putFile(File(imagem.path));
    return await db.getDownloadURL();
  }

  Future<void> atualizarFotoEquipamento(
      String idEquipamento, String imagem) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    try {
      await _db.collection(_stringEquipamento).doc(idEquipamento).update({
        "url_foto_de_perfil": imagem,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uparArquivoPaciente(XFile imagem, String idPaciente) async {
    Reference db =
        FirebaseStorage.instance.ref("$_strPacientes/perfil_$idPaciente");
    await db.putFile(File(imagem.path));
    return await db.getDownloadURL();
  }

  Future<void> atualizarFotoPaciente(String idPaciente, String imagem) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    try {
      await _db.collection(_strPacientes).doc(idPaciente).update({
        "url_foto_de_perfil": imagem,
      });
    } catch (e) {
      rethrow;
    }
  }
}
