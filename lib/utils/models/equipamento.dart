import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/usuario.dart';
import 'package:sono/utils/services/firebase.dart';

class Equipamento {
  late final Map<String, dynamic> infoMap;
  late final String nome;
  late final String id;
  late final String fabricante;
  late final TipoEquipamento tipo;
  late final String hospital;
  late final String informacoesTecnicas;
  late final String? higieneECuidadosPaciente;
  late final String? alteradoPor;
  late final String? descricao;
  late final String? observacao;
  late final String? manualPdf;
  late final String? videoInstrucional;
  late StatusDoEquipamento status;
  late String? idPacienteResponsavel;
  late final String? urlFotoDePerfil;
  late final String? idStatus;
  late final String? tamanho;
  late final String? numeroSerie;
  late final DateTime? dataDeExpedicao;
  late final DateTime? dataDeDevolucao;

/*   DateTime? get dataDeExpedicao {
    return (infoMap["data_de_expedicao"] as Timestamp?)?.toDate();
  } */

  String? get dataDeExpedicaoEmStringFormatada {
    return dataDeExpedicao != null ? _formatarData(dataDeExpedicao) : null;
  }

  DateTime? get calcularDataDeDevolucao {
    return dataDeExpedicao?.add(
      const Duration(days: 30),
    );
  }

  String get dataDeExpedicaoEmString {
    return dataDeExpedicao != null
        ? DateFormat('dd/MM/yyyy kk:mm:ss').format(dataDeExpedicao!)
        : '-';
  }

  String? get dataDeDevolucaoEmStringFormatada {
    return dataDeExpedicao != null
        ? _formatarData(calcularDataDeDevolucao)
        : null;
  }

  Map<String, dynamic> _setInfoMap() => {
        'nome': nome,
        "id": id,
        "status": status,
        "tipo": tipo,
        "hospital": hospital,
        "fabricante": fabricante,
        "url_foto": urlFotoDePerfil,
        "informacoes_tecnicas": informacoesTecnicas,
        "higiene_e_cuidados_paciente": higieneECuidadosPaciente,
        "paciente_responsavel": idPacienteResponsavel,
        "alterado_por": alteradoPor,
        "video_instrucional": videoInstrucional,
        "manual": manualPdf,
        "descrição": descricao,
        "tamanho": tamanho,
        "numero_serie": numeroSerie,
        "observação": observacao,
        "data_de_expedicao": dataDeExpedicaoEmString,
        "data_de_devolucao": dataDeDevolucaoEmStringFormatada
      };

  Equipamento(
    this.nome,
    this.id,
    this.status, {
    this.urlFotoDePerfil,
  });

  Equipamento.porMap(equipamentoInfoMap) {
    nome = equipamentoInfoMap["nome"];
    id = equipamentoInfoMap["id"];
    idPacienteResponsavel = equipamentoInfoMap["paciente_responsavel"];
    urlFotoDePerfil = equipamentoInfoMap["url_foto"];
    descricao = equipamentoInfoMap["descrição"];
    tipo = _lerTipoDeEquipamentoDoBancoDeDados(equipamentoInfoMap["tipo"])!;
    hospital = equipamentoInfoMap["hospital"];
    informacoesTecnicas = equipamentoInfoMap["informacoes_tecnicas"] ?? '';
    higieneECuidadosPaciente =
        equipamentoInfoMap["higiene_e_cuidados_paciente"] ?? null;
    fabricante = equipamentoInfoMap["fabricante"];
    alteradoPor = equipamentoInfoMap["alterado_por"];
    manualPdf = equipamentoInfoMap["manual"];
    videoInstrucional = equipamentoInfoMap["video_instrucional"];
    status = _lerStatusDoEquipamentoDoBancoDeDados(
      equipamentoInfoMap["status"] ?? "disponível",
    )!;

    tamanho = equipamentoInfoMap["tamanho"];
    numeroSerie = equipamentoInfoMap["numero_serie"];
    dataDeExpedicao = equipamentoInfoMap["data_de_expedicao"] != null
        ? (equipamentoInfoMap["data_de_expedicao"] as Timestamp).toDate()
        : null;
    dataDeDevolucao = equipamentoInfoMap["data_de_devolucao"];
    observacao = equipamentoInfoMap["observacao"];

    infoMap = equipamentoInfoMap;
  }

  String? _formatarData(DateTime? data) => DateFormat("dd/MM/yy").format(data!);

  StatusDoEquipamento? _lerStatusDoEquipamentoDoBancoDeDados(
    String status,
  ) {
    switch (status) {
      case "em empréstimo":
        return StatusDoEquipamento.emprestado;
      case "disponível":
        return StatusDoEquipamento.disponivel;
      case "em reparo":
        return StatusDoEquipamento.manutencao;
      case "em desinfecção":
        return StatusDoEquipamento.desinfeccao;
      case "concedido":
        return StatusDoEquipamento.concedido;
    }

    return null;
  }

  TipoEquipamento? _lerTipoDeEquipamentoDoBancoDeDados(String tipo) {
    switch (tipo) {
      case "cpap":
        return TipoEquipamento.cpap;
      case 'bipap':
        return TipoEquipamento.bipap;
      case 'autocpap':
        return TipoEquipamento.autocpap;
      case 'avaps':
        return TipoEquipamento.avap;
      case "almofada":
        return TipoEquipamento.almofada;
      case "traqueia":
        return TipoEquipamento.traqueia;
      case "mascara_nasal":
        return TipoEquipamento.nasal;
      case "fixador":
        return TipoEquipamento.fixador;
      case "mascara_oronasal":
        return TipoEquipamento.oronasal;
      case "mascara_pillow":
        return TipoEquipamento.pillow;
      case "mascara_facial":
        return TipoEquipamento.facial;
      case "filtro":
        return TipoEquipamento.filtro;
    }

    return null;
  }

  Future<void> emprestarPara(Paciente paciente) async =>
      await FirebaseService().emprestarEquipamento(this, paciente);

  Future<void> solicitarDelecao(Usuario usuario, String justificativa) async {
    await FirebaseService()
        .solicitarDelecaoEquipamento(this, usuario, justificativa);
  }

  Future<void> solicitarEmprestimo(Paciente paciente, Usuario usuario) async =>
      await FirebaseService()
          .solicitarEmprestimoEquipamento(this, paciente, usuario);

  Future<void> solicitarDevolucao(
          Paciente paciente, Usuario usuario, String justificativa) async =>
      await FirebaseService().solicitarDevolucaoEquipamento(
          this, paciente, usuario, justificativa);

  Future<void> devolver() async =>
      await FirebaseService().devolverEquipamento(this);

  Future<void> desinfectar(Usuario usuario) async {
    await FirebaseService().desinfectarEquipamento(this, usuario);
  }

  Future<void> manutencao(Usuario usuario) async {
    await FirebaseService().repararEquipamento(this, usuario);
  }

  Future<void> disponibilizar() async {
    await FirebaseService().disponibilizarEquipamento(this);
  }

  Future<void> conceder(Paciente paciente, Usuario usuario) async {
    await FirebaseService().concederEquipamento(this, paciente, usuario);
  }
}

enum TipoEquipamento {
  nasal,
  oronasal,
  pillow,
  facial,
  traqueia,
  fixador,
  almofada,
  cpap,
  bipap,
  avap,
  autocpap,
  filtro
}

extension ExtensaoTipoEquipamento on TipoEquipamento {
  String get emString {
    switch (this) {
      case TipoEquipamento.almofada:
        return "Almofada";
      case TipoEquipamento.traqueia:
        return "Traqueia";
      case TipoEquipamento.fixador:
        return "Fixador";
      case TipoEquipamento.nasal:
        return "Máscara Nasal";
      case TipoEquipamento.pillow:
        return "Máscara Pillow";
      case TipoEquipamento.facial:
        return "Máscara Facial";
      case TipoEquipamento.oronasal:
        return "Máscara Oronasal";
      case TipoEquipamento.cpap:
        return "CPAP";
      case TipoEquipamento.bipap:
        return 'BiPAP';
      case TipoEquipamento.autocpap:
        return 'AutoCPAP';
      case TipoEquipamento.avap:
        return 'AVAPS';
      case TipoEquipamento.filtro:
        return 'Filtro';
    }
  }

  String get emStringSnakeCase {
    switch (this) {
      case TipoEquipamento.almofada:
        return "almofada";
      case TipoEquipamento.traqueia:
        return "traqueia";
      case TipoEquipamento.fixador:
        return "fixador";
      case TipoEquipamento.nasal:
        return "mascara_nasal";
      case TipoEquipamento.pillow:
        return "mascara_pillow";
      case TipoEquipamento.facial:
        return "mascara_facial";
      case TipoEquipamento.oronasal:
        return "mascara_oronasal";
      case TipoEquipamento.cpap:
        return "cpap";
      case TipoEquipamento.bipap:
        return 'bipap';
      case TipoEquipamento.autocpap:
        return 'autocpap';
      case TipoEquipamento.avap:
        return 'avaps';
      case TipoEquipamento.filtro:
        return 'filtro';
    }
  }

  String get imagens {
    switch (this) {
      case TipoEquipamento.nasal:
        return 'assets/imagens/mascara_nasal.jpg';
      case TipoEquipamento.oronasal:
        return 'assets/imagens/mascara_oronasal.jpg';
      case TipoEquipamento.pillow:
        return 'assets/imagens/mascara_pillow.jpg';
      case TipoEquipamento.facial:
        return 'assets/imagens/mascara_facial.jpg';
      case TipoEquipamento.traqueia:
        return 'assets/imagens/traqueia.jpg';
      case TipoEquipamento.fixador:
        return 'assets/imagens/fixador.jpg';
      case TipoEquipamento.almofada:
        return 'assets/imagens/almofada.jpg';
      case TipoEquipamento.cpap:
        return 'assets/imagens/cpap.png';
      case TipoEquipamento.autocpap:
        return 'assets/imagens/autocpap.jpg';
      case TipoEquipamento.bipap:
        return 'assets/imagens/bipap.jpg';
      case TipoEquipamento.avap:
        return 'assets/imagens/avap.jpg';
      case TipoEquipamento.filtro:
        return 'assets/imagens/filtro.jpg';
    }
  }
}

enum StatusDoEquipamento {
  disponivel,
  emprestado,
  manutencao,
  desinfeccao,
  concedido
}

extension ExtensaoStatusDoEquipamento on StatusDoEquipamento {
  String get emString {
    switch (this) {
      case StatusDoEquipamento.emprestado:
        return "em empréstimo";
      case StatusDoEquipamento.disponivel:
        return "disponível";
      case StatusDoEquipamento.manutencao:
        return "em reparo";
      case StatusDoEquipamento.desinfeccao:
        return "em desinfecção";
      case StatusDoEquipamento.concedido:
        return "concedido";
    }
  }

  String get emStringMaiuscula {
    switch (this) {
      case StatusDoEquipamento.emprestado:
        return "Emprestado";
      case StatusDoEquipamento.disponivel:
        return "Disponível";
      case StatusDoEquipamento.manutencao:
        return "Manutenção";
      case StatusDoEquipamento.desinfeccao:
        return "Desinfecção";
      case StatusDoEquipamento.concedido:
        return "Concedido";
    }
  }

  String get emStringPlural {
    switch (this) {
      case StatusDoEquipamento.emprestado:
        return "Empréstimos";
      case StatusDoEquipamento.disponivel:
        return "Disponíveis";
      case StatusDoEquipamento.manutencao:
        return "Reparos";
      case StatusDoEquipamento.desinfeccao:
        return "Desinfecção";
      case StatusDoEquipamento.concedido:
        return "Concedidos";
    }
  }

  IconData get icone {
    switch (this) {
      case StatusDoEquipamento.disponivel:
        return Icons.check_circle;
      case StatusDoEquipamento.emprestado:
        return Icons.people_sharp;
      case StatusDoEquipamento.manutencao:
        return Icons.build_circle_rounded;
      case StatusDoEquipamento.desinfeccao:
        return Icons.clean_hands_sharp;
      case StatusDoEquipamento.concedido:
        return Icons.assignment_ind;
    }
  }

  IconData get icone2 {
    switch (this) {
      case StatusDoEquipamento.disponivel:
        return Icons.check;
      case StatusDoEquipamento.emprestado:
        return Icons.people_sharp;
      case StatusDoEquipamento.manutencao:
        return Icons.build_rounded;
      case StatusDoEquipamento.desinfeccao:
        return Icons.clean_hands_sharp;
      case StatusDoEquipamento.concedido:
        return Icons.assignment_ind;
    }
  }

  Color get cor {
    switch (this) {
      case StatusDoEquipamento.disponivel:
        return const Color.fromARGB(255, 51, 255, 58);
      case StatusDoEquipamento.emprestado:
        return Colors.yellow;
      case StatusDoEquipamento.manutencao:
        return Colors.red;
      case StatusDoEquipamento.desinfeccao:
        return const Color.fromARGB(255, 0, 225, 255);
      case StatusDoEquipamento.concedido:
        return const Color.fromARGB(255, 236, 98, 0);
    }
  }
}
