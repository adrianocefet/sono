import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sono/pages/avaliacao/avaliacao_controller.dart';
import 'package:sono/utils/models/avaliacao.dart';
import 'package:sono/utils/models/exame.dart';
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
  static const String _stringAvaliacoes = 'avaliacoes';
  static const String _stringExames = 'exames';

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

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamInfoPacientePorID(
      String idPaciente) {
    return _db.collection(_strPacientes).doc(idPaciente).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAvaliacoesPorIdDoPaciente(
      String idPaciente) {
    return _db
        .collection(_strPacientes)
        .doc(idPaciente)
        .collection(_stringAvaliacoes)
        .snapshots();
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
    solicitacaoAtualizada.infoMap['data_de_resposta'] =
        FieldValue.serverTimestamp();

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

    if (fotoDePerfil != null) {
      urlImagem =
          await FirebaseService().adicionarImageDoEquipamentoAoFirebaseStorage(
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
      Paciente paciente, UserModel usuario, String justificativa) async {
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
    UserModel usuario,
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
      Equipamento equipamento, Paciente paciente, UserModel usuario) async {
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
    await _db.collection(_stringEquipamento).doc(equipamento.id).update(
      {
        "status": StatusDoEquipamento.concedido.emString,
        "paciente_responsavel": paciente.id,
        "data_de_expedicao": FieldValue.serverTimestamp(),
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
      Equipamento equipamento, UserModel usuario) async {
    await _db.collection(_stringEquipamento).doc(equipamento.id).update(
      {
        "status": StatusDoEquipamento.desinfeccao.emString,
        "alterado_por": usuario.id,
        "data_de_expedicao": FieldValue.serverTimestamp()
      },
    );
  }

  Future<void> repararEquipamento(
      Equipamento equipamento, UserModel usuario) async {
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

    if (fotoDePerfil != null) {
      urlImagem =
          await FirebaseService().adicionarImageDoPacienteAoFirebaseStorage(
        imageFile: fotoDePerfil,
        idPaciente: idPaciente,
      );
    }
    if (urlImagem.isNotEmpty) data['url_foto_de_perfil'] = urlImagem;

    await _db.collection(_strPacientes).doc(idPaciente).set(data);

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
      'id_avaliador': avaliacao.idAvaliador,
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
