import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sono/pages/avaliacao/avaliacao_controller.dart';
import 'package:sono/utils/models/avaliacao.dart';
import 'package:sono/utils/models/exame.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/solicitacao.dart';
import '../models/equipamento.dart';
import '../models/usuario.dart';

class FirebaseService {
  static final FirebaseService _firebaseService = FirebaseService._internal();

  factory FirebaseService() {
    return _firebaseService;
  }

  FirebaseService._internal();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _strPacientes = 'pacientes';
  static const String _strUsuarios = 'usuarios';
  static const String _stringEquipamento = "equipamentos";
  static const String _stringQuestionarios = "questionarios";
  static const String _stringSolicitacoes = "solicitacoes";
  static const String _stringAvaliacoes = 'avaliacoes';
  static const String _stringExames = 'exames';
  static const String _stringTermos = 'termos';

  static const Map _tipos = {
    'polissonografia': TipoExame.polissonografia,
    'dados_complementares': TipoExame.dadosComplementares,
    'espirometria': TipoExame.espirometria,
    'actigrafia': TipoExame.actigrafia,
    'listagem_de_sintomas': TipoExame.listagemDeSintomas,
    'listagem_de_sintomas_pap': TipoExame.listagemDeSintomasDoUsoDoCPAP,
    'manuvacuometria': TipoExame.manuvacuometria,
    'questionarios': TipoExame.questionario,
    'conclusao': TipoExame.conclusao,
    'berlin': TipoQuestionario.berlin,
    'epworth': TipoQuestionario.epworth,
    'goal': TipoQuestionario.goal,
    'pittsburg': TipoQuestionario.pittsburg,
    'sacs_br': TipoQuestionario.sacsBR,
    'stop_bang': TipoQuestionario.stopBang,
    'whodas': TipoQuestionario.whodas,
  };

  String? get idUsuario {
    return _auth.currentUser?.uid;
  }

  bool get usuarioEstaLogado {
    return _auth.currentUser != null;
  }

  Future<void> deslogarUsuario() async {
    await _auth.signOut();
  }

  Future<void> cadastrarUsuarioComEmailESenha(
      String email, String senha) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: senha);
  }

  Future<void> logarComEmailESenha(String email, String senha) async {
    await _auth.signInWithEmailAndPassword(email: email, password: senha);
  }

  Future<void> enviarEmailDeRedefinicaoDeSenha(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<Paciente> obterPacientePorID(String idPaciente,
      {bool comAvaliacoes = false,
      bool comUltimaAvaliacao = false,
      bool comEquipamentos = false}) async {
    List<Avaliacao>? avaliacoes;
    List<Equipamento>? equipamentos = [];
    Equipamento? equipamentoObtido;

    if (comAvaliacoes) {
      avaliacoes = await obterAvaliacoesDoPaciente(idPaciente);
    }
    if (comUltimaAvaliacao && !comAvaliacoes) {
      avaliacoes = [await obterUltimaAvaliacaoDoPaciente(idPaciente)];
    }

    return await _db.collection(_strPacientes).doc(idPaciente).get().then(
      (document) async {
        for (String idEquipamento in document.data()![_stringEquipamento]) {
          equipamentoObtido = await obterEquipamentoPorID(idEquipamento);
          if (equipamentoObtido != null) {
            equipamentos.add(equipamentoObtido!);
          }
        }

        return Paciente.porDocumentSnapshot(
          document,
          avaliacoes: avaliacoes,
          equipamentos: equipamentos,
        );
      },
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamUsuarios() {
    return _db
        .collection(_strUsuarios)
        .where('instituicao', isNull: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamPacientesPorHospital(
      String hospital) {
    return _db
        .collection(_strPacientes)
        .where("hospitais_vinculados", arrayContains: hospital)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamInfoPacientePorID(
      String idPaciente) {
    return _db.collection(_strPacientes).doc(idPaciente).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamInfoUsuarioPorID(
      String idUsuario) {
    return _db.collection(_strUsuarios).doc(idUsuario).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAvaliacoesPorIdDoPaciente(
      String idPaciente) {
    return _db
        .collection(_strPacientes)
        .doc(idPaciente)
        .collection(_stringAvaliacoes)
        .snapshots();
  }

  Future<Usuario> obterProfissionalPorID(String id) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _db.collection(_strUsuarios).doc(id).get();

    return Usuario.porDocumentSnapshot(snap);
  }

  Future<Avaliacao> obterAvaliacaoPorID(
      String idPaciente, String idAvaliacao) async {
    Map<String, dynamic> dadosBasicos = (await _db
            .collection(_strPacientes)
            .doc(idPaciente)
            .collection(_stringAvaliacoes)
            .doc(idAvaliacao)
            .get())
        .data()!;

    List<Exame> examesComplexos = (await _db
            .collection(_strPacientes)
            .doc(idPaciente)
            .collection(_stringAvaliacoes)
            .doc(idAvaliacao)
            .collection(_stringExames)
            .get())
        .docs
        .map((e) {
      Map<String, dynamic> exame = e.data();
      return Exame(_tipos[exame['codigo'] ?? exame['tipo']],
          respostas: exame, urlPdf: exame['url_pdf']);
    }).toList();

    List<Exame> questionarios = (await _db
            .collection(_strPacientes)
            .doc(idPaciente)
            .collection(_stringAvaliacoes)
            .doc(idAvaliacao)
            .collection(_stringQuestionarios)
            .get())
        .docs
        .map((e) {
      Map<String, dynamic> exame = e.data();
      return Exame(
        TipoExame.questionario,
        tipoQuestionario: _tipos[exame['codigo'] ?? exame['tipo']],
        respostas: exame,
      );
    }).toList();

    List<Exame> examesSimples = dadosBasicos.entries
        .where((element) => [
              'conclusao',
              'dados_complementares',
              'listagem_de_sintomas',
              'listagem_de_sintomas_pap'
            ].contains(element.key))
        .map((exame) {
      return Exame(_tipos[exame.key], respostas: Map.fromEntries([exame]));
    }).toList();

    return Avaliacao(
      examesRealizados: examesSimples + examesComplexos + questionarios,
      id: idAvaliacao,
      idAvaliador: dadosBasicos['id_avaliador'],
      dataDaAvaliacao: dadosBasicos['data_de_realizacao'],
    );
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
    await FirebaseFirestore.instance
        .collection(_stringSolicitacoes)
        .doc(solicitacaoAtualizada.id)
        .update(
          solicitacaoAtualizada.infoMap,
        );
  }

  Future<void> salvarTermoDaSolicitacao(Solicitacao solicitacao,
      Paciente paciente, Equipamento equipamento, File pdf) async {
    solicitacao.infoMap['url_pdf'] = await salvarPDFDaSolicitacao(
        solicitacao, equipamento.id, paciente.id, pdf);
    await atualizarSolicitacao(solicitacao);
  }

  Future<String> salvarPDFDaSolicitacao(Solicitacao solicitacao,
      String idEquipamento, String idPaciente, File pdf) async {
    Reference db = FirebaseStorage.instance
        .ref("$_stringTermos/$idEquipamento/$idPaciente/${solicitacao.id}.pdf");
    await db.putFile(File(pdf.path));
    return await db.getDownloadURL();
  }

  Future<void> updateDadosDoEquipamento(
      Map<String, dynamic> data, String idEquipamento,
      {File? fotoDePerfil}) async {
    String? urlImagem;

    if (fotoDePerfil != null) {
      await deletarImagemEquipamentoDoFirebaseStorage(idEquipamento);

      urlImagem =
          await FirebaseService().adicionarImagemDoEquipamentoAoFirebaseStorage(
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

    if (fotoDePerfil != null) {
      urlImagem =
          await FirebaseService().adicionarImagemDoEquipamentoAoFirebaseStorage(
        imageFile: fotoDePerfil,
        idEquipamento: idEquipamento,
      );
    }
    if (urlImagem.isNotEmpty) dadosDoEquipamento['url_foto'] = urlImagem;

    await _db.collection(_stringEquipamento).doc().set(dadosDoEquipamento);

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
      String idSolicitacao) {
    return FirebaseFirestore.instance
        .collection(_stringSolicitacoes)
        .doc(idSolicitacao)
        .snapshots();
  }

  Future<void> solicitarDevolucaoEquipamento(Equipamento equipamento,
      Paciente paciente, Usuario usuario, String justificativa) async {
    await _db.collection(_stringSolicitacoes).doc().set(
      {
        "tipo": "devolucao",
        "equipamento": equipamento.id,
        "paciente": paciente.id,
        "solicitante": usuario.id,
        "data_da_solicitacao": FieldValue.serverTimestamp(),
        "confirmacao": "pendente",
        "hospital": equipamento.hospital,
        "justificativa_devolucao": justificativa
      },
    );
  }

  Future<void> solicitarEmprestimoEquipamento(
    Equipamento equipamento,
    Paciente paciente,
    Usuario usuario,
  ) async {
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
  }

  Future<void> emprestarEquipamento(
    Equipamento equipamento,
    Paciente paciente,
  ) async {
    await _db.collection(_stringEquipamento).doc(equipamento.id).update(
      {
        "status": StatusDoEquipamento.emprestado.emString,
        "paciente_responsavel": paciente.id,
        "data_de_expedicao": FieldValue.serverTimestamp(),
      },
    );

    await _db.collection(_strPacientes).doc(paciente.id).update(
      {
        "equipamentos": FieldValue.arrayUnion([equipamento.id])
      },
    );
  }

  Future<void> concederEquipamento(
      Equipamento equipamento, Paciente paciente, Usuario usuario) async {
    if (equipamento.status == StatusDoEquipamento.emprestado) {
      await _db
          .collection(_strPacientes)
          .doc(equipamento.idPacienteResponsavel)
          .update(
        {
          "equipamentos": FieldValue.arrayRemove([equipamento.id]),
        },
      );
    }
    final FieldValue horaAtual = FieldValue.serverTimestamp();
    await _db.collection(_stringSolicitacoes).doc().set(
      {
        "tipo": TipoSolicitacao.concessao.emStringSemAcentos,
        "equipamento": equipamento.id,
        "paciente": paciente.id,
        "solicitante": usuario.id,
        "data_da_solicitacao": horaAtual,
        "data_de_resposta": horaAtual,
        "confirmacao": "confirmado",
        "hospital": equipamento.hospital,
      },
    );
    await _db.collection(_stringEquipamento).doc(equipamento.id).update(
      {
        "status": StatusDoEquipamento.concedido.emString,
        "paciente_responsavel": paciente.id,
        "data_de_expedicao": horaAtual,
        "alterado_por": usuario.id,
      },
    );

    await _db.collection(_strPacientes).doc(paciente.id).update(
      {
        "equipamentos_concedidos": FieldValue.arrayUnion([equipamento.id])
      },
    );
  }

  Future<void> devolverEquipamento(
    Equipamento equipamento,
  ) async {
    await _db.collection(_stringEquipamento).doc(equipamento.id).update(
      {
        "status": StatusDoEquipamento.disponivel.emString,
        "paciente_responsavel": FieldValue.delete(),
        "alterado_por": FieldValue.delete(),
        "data_de_expedicao": FieldValue.delete(),
      },
    );
    equipamento.status == StatusDoEquipamento.emprestado
        ? await _db
            .collection(_strPacientes)
            .doc(equipamento.idPacienteResponsavel)
            .update(
            {
              "equipamentos": FieldValue.arrayRemove([equipamento.id]),
            },
          )
        : await _db
            .collection(_strPacientes)
            .doc(equipamento.idPacienteResponsavel)
            .update({
            "equipamentos_concedidos": FieldValue.arrayRemove([equipamento.id]),
          });
  }

  Future<void> desinfectarEquipamento(
      Equipamento equipamento, Usuario usuario) async {
    await _db.collection(_stringEquipamento).doc(equipamento.id).update(
      {
        "status": StatusDoEquipamento.desinfeccao.emString,
        "alterado_por": usuario.id,
        "data_de_expedicao": FieldValue.serverTimestamp()
      },
    );
  }

  Future<void> repararEquipamento(
      Equipamento equipamento, Usuario usuario) async {
    await _db.collection(_stringEquipamento).doc(equipamento.id).update(
      {
        "status": StatusDoEquipamento.manutencao.emString,
        "alterado_por": usuario.id,
        "data_de_expedicao": FieldValue.serverTimestamp()
      },
    );
  }

  Future<void> disponibilizarEquipamento(Equipamento equipamento) async {
    await _db.collection(_stringEquipamento).doc(equipamento.id).update(
      {
        "status": StatusDoEquipamento.disponivel.emString,
        "alterado_por": FieldValue.delete(),
        "data_de_expedicao": FieldValue.delete()
      },
    );
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
    if (info["status"] == StatusDoEquipamento.emprestado.emString ||
        info["status"] == StatusDoEquipamento.concedido.emString) {
      Map<String, dynamic> dadosEquipamento = info.data()!;
      dadosEquipamento["id"] = info.id;

      await devolverEquipamento(
        Equipamento.porMap(
          dadosEquipamento,
        ),
      );
    }
    try {
      await deletarImagemEquipamentoDoFirebaseStorage(idEquipamento);
      // ignore: empty_catches
    } on Exception {}
    await _db.collection(_stringEquipamento).doc(idEquipamento).delete();
  }

  Future removerPaciente(String idPaciente) async {
    await _db.collection(_strPacientes).doc(idPaciente).delete();
    try {
      await deletarImagemDoFirebaseStorage(idPaciente);
    } on Exception {}
  }

  Future<String?> procurarUsuarioNoBancoDeDados(
      Map<String, dynamic> data) async {
    String? idUsuario;

    QuerySnapshot query = await _db
        .collection(_strUsuarios)
        .where("email", isEqualTo: data["email"])
        .get();

    if (query.docs.isNotEmpty) idUsuario = query.docs[0].id;

    return idUsuario;
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

  Future<String> uploadDadosDoUsuario(Map<String, dynamic> data,
      {File? fotoDePerfil}) async {
    String idUsuario =
        _auth.currentUser!.uid; //_db.collection(_strUsuarios).doc().id;
    String urlImagem = '';

    if (fotoDePerfil != null) {
      urlImagem =
          await FirebaseService().adicionarImagemDoUsuarioAoFirebaseStorage(
        imageFile: fotoDePerfil,
        idUsuario: idUsuario,
      );
    }
    if (urlImagem.isNotEmpty) data['url_foto_de_perfil'] = urlImagem;

    await _db.collection(_strUsuarios).doc(idUsuario).set(data);

    return idUsuario;
  }

  Future<String> uploadDadosDoPaciente(Map<String, dynamic> data,
      {File? fotoDePerfil}) async {
    String idPaciente = _db.collection(_strPacientes).doc().id;
    String urlImagem = '';

    if (fotoDePerfil != null) {
      urlImagem =
          await FirebaseService().adicionarImagemDoPacienteAoFirebaseStorage(
        imageFile: fotoDePerfil,
        idPaciente: idPaciente,
      );
    }
    if (urlImagem.isNotEmpty) data['url_foto_de_perfil'] = urlImagem;

    await _db.collection(_strPacientes).doc(idPaciente).set(data);

    return idPaciente;
  }

  Future<String> atualizarDadosDoPaciente(
      Map<String, dynamic> data, String idPaciente,
      {File? fotoDePerfil}) async {
    String? urlImagem;

    if (fotoDePerfil != null) {
      await deletarImagemDoFirebaseStorage(idPaciente);

      urlImagem =
          await FirebaseService().adicionarImagemDoPacienteAoFirebaseStorage(
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

  Future<String> atualizarDadosDoUsuario(
      Map<String, dynamic> data, String idUsuario,
      {File? fotoDePerfil, bool fotoDePerfilJaCadastrada = false}) async {
    String? urlImagem;

    if (fotoDePerfil != null) {
      await deletarImagemDoFirebaseStorage(idUsuario);

      urlImagem =
          await FirebaseService().adicionarImagemDoUsuarioAoFirebaseStorage(
        idUsuario: idUsuario,
        imageFile: fotoDePerfil,
      );
    } else {
      await deletarImagemDoUsuarioDoFirebaseStorage(idUsuario);
    }

    data['url_foto_de_perfil'] = urlImagem;
    await _db.collection(_strUsuarios).doc(idUsuario).update(data);

    return idUsuario;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamQuestionarios(
      String idPaciente) {
    return _db
        .collection(_strPacientes)
        .doc(idPaciente)
        .collection(_stringQuestionarios)
        .snapshots();
  }

  Future<String> adicionarImagemDoPacienteAoFirebaseStorage({
    required File imageFile,
    String? idPaciente,
  }) async {
    Reference ref = _storage.ref(
      '$_strPacientes/perfil_$idPaciente',
    );
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<String> adicionarImagemDoUsuarioAoFirebaseStorage({
    required File imageFile,
    String? idUsuario,
  }) async {
    Reference ref = _storage.ref(
      '$_strUsuarios/perfil_$idUsuario',
    );
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future deletarImagemDoUsuarioDoFirebaseStorage(String idElemento) async {
    Reference ref = _storage.ref(
      "$_strUsuarios/perfil_$idElemento",
    );

    try {
      await ref.delete();
    } on Exception {}
  }

  Future<File?> obterImagemDoFirebaseStorage(String urlImagem) async {
    try {
      Uint8List? rawPath = await _storage.refFromURL(urlImagem).getData();

      final Directory tempDir = await getTemporaryDirectory();
      final String fullPath = "${tempDir.path}/tempFotoDePerfil";

      final File imagem = File(fullPath);
      if (await imagem.exists()) await imagem.delete();
      if (rawPath != null) await imagem.writeAsBytes(rawPath);
      return rawPath != null ? imagem : null;
    } catch (e) {
      return null;
    }
  }

  Future<String> adicionarImagemDoEquipamentoAoFirebaseStorage({
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

    await _db.collection(_stringEquipamento).doc(idEquipamento).update({
      "url_foto_de_perfil": imagem,
    });
  }

  Future<String> uparArquivoPaciente(XFile imagem, String idPaciente) async {
    Reference db =
        FirebaseStorage.instance.ref("$_strPacientes/perfil_$idPaciente");
    await db.putFile(File(imagem.path));
    return await db.getDownloadURL();
  }

  Future<void> atualizarFotoPaciente(String idPaciente, String imagem) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    await _db.collection(_strPacientes).doc(idPaciente).update({
      "url_foto_de_perfil": imagem,
    });
  }

  Future<String> salvarPDFDoExame(
      Exame exame, String idAvaliacao, String idPaciente) async {
    Reference db = FirebaseStorage.instance
        .ref("$_stringAvaliacoes/$idPaciente/$idAvaliacao/${exame.codigo}.pdf");
    await db.putFile(File(exame.pdf!.path));
    return await db.getDownloadURL();
  }

  Future<void> salvarAvaliacao(ControllerAvaliacao avaliacao) async {
    final List<Exame> examesSimples = avaliacao.listaDeExamesRealizados
        .where((exame) => [
              TipoExame.dadosComplementares,
              TipoExame.conclusao,
              TipoExame.listagemDeSintomas,
              TipoExame.listagemDeSintomasDoUsoDoCPAP
            ].contains(exame.tipo))
        .toList();

    final List<Exame> examesQuestionarios = avaliacao.listaDeExamesRealizados
        .where((exame) => exame.tipo == TipoExame.questionario)
        .toList();

    final List<Exame> examesComplexos = avaliacao.listaDeExamesRealizados
        .where((exame) =>
            exame.tipo != TipoExame.questionario &&
            examesSimples.contains(exame) == false)
        .toList();

    Map<String, dynamic> dadosSimples = {
      'nome_avaliador': avaliacao.avaliador.nomeCompleto,
      'id_avaliador': avaliacao.avaliador.id,
      'data_de_realizacao': avaliacao.dataDaAvaliacao,
    };

    for (Exame exame in examesSimples) {
      dadosSimples.addAll(exame.respostas);
    }

    //gerando doc da avaliação
    DocumentReference<Map<String, dynamic>> ref = await _db
        .collection(_strPacientes)
        .doc(avaliacao.paciente.id)
        .collection(_stringAvaliacoes)
        .add(dadosSimples);

    //adicionando exames
    for (Exame exame in examesComplexos) {
      exame.respostas['codigo'] = exame.codigo;
      if (exame.pdf != null) {
        exame.respostas['url_pdf'] =
            await salvarPDFDoExame(exame, ref.id, avaliacao.paciente.id);
      }
      await ref.collection('exames').doc().set(exame.respostas);
    }

    //adicionando questionários
    for (Exame exame in examesQuestionarios) {
      exame.respostas['codigo'] = exame.codigo;
      await ref.collection('questionarios').doc().set(exame.respostas);
    }

    //atualizando data da última avaliação e adicionando resumo dos exames realizados
    List<Exame> todosOsExames =
        examesSimples + examesComplexos + examesQuestionarios;

    Map<String, Timestamp> datasUltimosExames = {};

    for (Exame exame in todosOsExames) {
      datasUltimosExames[exame.codigo] = avaliacao.dataDaAvaliacao;
    }

    if (examesQuestionarios.isNotEmpty) {
      datasUltimosExames['questionarios'] = avaliacao.dataDaAvaliacao;
    }

    await _db.collection(_strPacientes).doc(avaliacao.paciente.id).update({
      'data_da_ultima_avaliacao': avaliacao.dataDaAvaliacao,
      'datas_ultimos_exames': datasUltimosExames,
      'codigos_exames': todosOsExames.map((e) => e.codigo).toList(),
    });
  }

  Future<List<Avaliacao>> obterAvaliacoesDoPaciente(String idPaciente) async {
    QuerySnapshot<Map<String, dynamic>> docsAvaliacoes = await _db
        .collection(_strPacientes)
        .doc(idPaciente)
        .collection(_stringAvaliacoes)
        .orderBy('data_de_realizacao')
        .get();

    List<Avaliacao> avaliacoes = [
      for (QueryDocumentSnapshot<Map<String, dynamic>> snap
          in docsAvaliacoes.docs)
        await obterAvaliacaoPorID(idPaciente, snap.id)
    ];

    return avaliacoes;
  }

  Future<Avaliacao> obterUltimaAvaliacaoDoPaciente(String idPaciente) async {
    QuerySnapshot<Map<String, dynamic>> docsAvaliacoes = await _db
        .collection(_strPacientes)
        .doc(idPaciente)
        .collection(_stringAvaliacoes)
        .orderBy('data_de_realizacao')
        .get();

    Avaliacao ultimaAvaliacao =
        await obterAvaliacaoPorID(idPaciente, docsAvaliacoes.docs.first.id);

    return ultimaAvaliacao;
  }
}
