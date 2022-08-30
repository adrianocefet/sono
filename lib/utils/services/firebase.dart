import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sono/pages/avaliacao/questionarios/berlin/questionario/berlin.dart';
import 'package:sono/pages/avaliacao/questionarios/epworth/questionario/epworth_view.dart';
import 'package:sono/pages/avaliacao/questionarios/goal/questionario/goal.dart';
import 'package:sono/pages/avaliacao/questionarios/pittsburg/questionario/pittsburg_view.dart';
import 'package:sono/pages/avaliacao/questionarios/sacs_br/questionario/sacs_br.dart';
import 'package:sono/pages/avaliacao/questionarios/stop_bang/questionario/stop_bang.dart';
import 'package:sono/pages/avaliacao/questionarios/whodas/questionario/whodas_view.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/solicitacao.dart';
import '../models/equipamento.dart';
import '../models/user_model.dart';

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
  static const String _stringSolicitacoes = "solicitacoes";

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
        .collection(_stringEquipamento)
        .doc(equipamentoAtualizado.id)
        .update(
          equipamentoAtualizado.infoMap,
        );
  }

  static Future<void> atualizarSolicitacao(
    Solicitacao solicitacaoAtualizada) async {
    
    solicitacaoAtualizada.infoMap['data_de_resposta'] = FieldValue.serverTimestamp();

  await FirebaseFirestore.instance
      .collection(_stringSolicitacoes)
      .doc(solicitacaoAtualizada.id)
      .update(
        solicitacaoAtualizada.infoMap,
      );
  }

  Future<void> updateDadosDoEquipamento(
      Map<String, dynamic> data, String idEquipamento,
      {File? fotoDePerfil}) async {
    String? urlImagem;

    if (fotoDePerfil != null) {
      await deletarImagemEquipamentoDoFirebaseStorage(idEquipamento);

      urlImagem =
          await FirebaseService().adicionarImageDoEquipamentoAoFirebaseStorage(
        idEquipamento: idEquipamento,
        imageFile: fotoDePerfil,
      );
    } else {
      urlImagem != null
          ? await deletarImagemEquipamentoDoFirebaseStorage(idEquipamento)
          : null;
    }
    urlImagem != null ? data['url_foto'] = urlImagem : null;

    await _db.collection(_stringEquipamento).doc(idEquipamento).update(data);
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
      if (urlImagem.isNotEmpty) dadosDoEquipamento['url_foto'] = urlImagem;

      await _db.collection(_stringEquipamento).doc().set(dadosDoEquipamento);
    } catch (e) {
      rethrow;
    }

    return idEquipamento;
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> streamEquipamento(
      String idEquipamento) {
    return FirebaseFirestore.instance
        .collection(_stringEquipamento)
        .doc(idEquipamento)
        .snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> streamSolicitacao(
    String idSolicitacao
  ) {
    return FirebaseFirestore.instance
        .collection(_stringSolicitacoes)
        .doc(idSolicitacao)
        .snapshots();
  }

  Future<void> solicitarDevolucaoEquipamento(
    Equipamento equipamento,
    Paciente paciente,
    UserModel usuario,
  )async{
    try {
      await _db.collection(_stringSolicitacoes).doc().set(
        {
          "tipo": "devolucao",
          "equipamento": equipamento.id,
          "paciente": paciente.id,
          "solicitante": usuario.id,
          "data_da_solicitacao": FieldValue.serverTimestamp(),
          "confirmacao": "pendente",
          "hospital": equipamento.hospital
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> solicitarEmprestimoEquipamento(
    Equipamento equipamento,
    Paciente paciente,
    UserModel usuario,
  ) async {
    try {
      await _db.collection(_stringSolicitacoes).doc().set(
        {
          "tipo": "emprestimo",
          "equipamento": equipamento.id,
          "paciente": paciente.id,
          "solicitante": usuario.id,
          "data_da_solicitacao": FieldValue.serverTimestamp(),
          "confirmacao": "pendente",
          "hospital": equipamento.hospital
        },
      );
    } catch (e) {
      rethrow;
    }
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
          "alterado_por": FieldValue.delete(),
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

  Future<void> desinfectarEquipamento(
      Equipamento equipamento, UserModel usuario) async {
    try {
      await _db.collection(_stringEquipamento).doc(equipamento.id).update(
        {
          "status": StatusDoEquipamento.desinfeccao.emString,
          "alterado_por": usuario.id,
          "data_de_expedicao": FieldValue.serverTimestamp()
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> repararEquipamento(
      Equipamento equipamento, UserModel usuario) async {
    try {
      await _db.collection(_stringEquipamento).doc(equipamento.id).update(
        {
          "status": StatusDoEquipamento.manutencao.emString,
          "alterado_por": usuario.id,
          "data_de_expedicao": FieldValue.serverTimestamp()
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
          "alterado_por": FieldValue.delete(),
          "data_de_expedicao": FieldValue.delete()
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
        .collection(_stringEquipamento)
        .where("nome", isEqualTo: data['nome'])
        .where("hospital", isEqualTo: data["hospital"])
        .where("tipo", isEqualTo: data["tipo"])
        .where("status", isEqualTo: data["status"])
        .get();

    if (query.docs.isNotEmpty) idEquipamento = query.docs[0].id;

    return idEquipamento;
  }

  Future removerEquipamento(String idEquipamento) async {
    DocumentSnapshot<Map<String, dynamic>> info =
        await _db.collection(_stringEquipamento).doc(idEquipamento).get();
    if (info["status"] == "em empréstimo") {
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

  Future deletarImagemEquipamentoDoFirebaseStorage(String idElemento) async {
    Reference ref = _storage.ref(
      "$_stringEquipamento/perfil_$idElemento",
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
