import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:sono/globais/global.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/tamanho_equipamento.dart';
import 'package:sono/utils/services/firebase.dart';

class Equipamento {
  late final Map<String, dynamic> infoMap;
  late final String nome;
  late final String id;
  late final String fabricante;
  late final TipoEquipamento tipo;
  late final String? idEmpresaResponsavel;
  late final String? descricao;
  late final String? observacao;
  late final String? manualPdf;
  late final String? videoInstrucional;
  late StatusDoEquipamento status;
  late String? idPacienteResponsavel;
  late final String? urlFotoDePerfil;
  late final String? idStatus;
  late final String? tamanho;

  DateTime? get dataDeExpedicao {
    return (infoMap["data_de_expedicao"] as Timestamp?)?.toDate();
  }

  String? get dataDeExpedicaoEmStringFormatada {
    return dataDeExpedicao != null ? _formatarData(dataDeExpedicao) : null;
  }

  DateTime? get dataDeDevolucao {
    return dataDeExpedicao?.add(
      const Duration(days: 30),
    );
  }

  String? get dataDeDevolucaoEmStringFormatada {
    return dataDeExpedicao != null ? _formatarData(dataDeDevolucao) : null;
  }

  Map<String, dynamic> _setInfoMap() => {
        'nome': nome,
        "id": id,
        "status": status,
        "tipo": tipo,
        "fabricante":fabricante,
        "url_foto": urlFotoDePerfil,
        "data_de_expedicao": dataDeExpedicaoEmStringFormatada,
        "paciente_responsavel": idPacienteResponsavel,
        "empresa_responsavel": idEmpresaResponsavel,
        "video_instrucional": videoInstrucional,
        "manual": manualPdf,
        "descrição": descricao,
        "tamanho": tamanho,
        "observação": observacao,
      };

  Equipamento(
    this.nome,
    this.id,
    this.status,{
    this.urlFotoDePerfil,
  });

  Equipamento.porMap(equipamentoInfoMap) {
    nome = equipamentoInfoMap["nome"] ?? equipamentoInfoMap["Nome"];
    id = equipamentoInfoMap["id"];
    idPacienteResponsavel = equipamentoInfoMap["paciente_responsavel"];
    urlFotoDePerfil =
        equipamentoInfoMap["url_foto"] ?? equipamentoInfoMap["Foto"];
    descricao =
        equipamentoInfoMap["descrição"] ?? equipamentoInfoMap["Descrição"];
    tipo = _lerTipoDeEquipamentoDoBancoDeDados(equipamentoInfoMap["tipo"]??equipamentoInfoMap["Tipo"])!;
    fabricante =
        equipamentoInfoMap["fabricante"];
    idEmpresaResponsavel =
        equipamentoInfoMap["empresa_responsavel"];
    manualPdf =
        equipamentoInfoMap["manual"] ?? equipamentoInfoMap["Manual"];
    videoInstrucional =
        equipamentoInfoMap["video_instrucional"] ?? equipamentoInfoMap["Video_instrucional"];
     status = _lerStatusDoEquipamentoDoBancoDeDados(
      equipamentoInfoMap["status"] ??
          equipamentoInfoMap["Status"] ??
          "disponível",
    )!;
     
     tamanho= equipamentoInfoMap["tamanho"] ?? equipamentoInfoMap["Tamanho"];

     observacao = equipamentoInfoMap["observação"];

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
    }

    return null;
  }

  TipoEquipamento? _lerTipoDeEquipamentoDoBancoDeDados(String tipo) {
    switch (tipo) {
      case "almofada":
        return TipoEquipamento.almofada;
      case "aparelho_pap":
        return TipoEquipamento.pap;
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
    }

    return null;
  }

  Future<void> emprestarPara(Paciente paciente) async =>
      await FirebaseService().emprestarEquipamento(this, paciente);

  Future<void> devolver() async =>
      await FirebaseService().devolverEquipamento(this);

  Future<void> desinfectar() async {
    await FirebaseService().desinfectarEquipamento(this);
  }

  Future<void> manutencao() async {
    await FirebaseService().repararEquipamento(this);
  }

  Future<void> disponibilizar() async {
    await FirebaseService().disponibilizarEquipamento(this);
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
  pap,
}

extension ExtensaoTipoEquipamento on TipoEquipamento {
  String get emString {
    switch (this) {
      case TipoEquipamento.almofada:
        return "Almofada";
      case TipoEquipamento.pap:
        return "Aparelho PAP";
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
    }
  }
}

enum StatusDoEquipamento {
  emprestado,
  disponivel,
  manutencao,
  desinfeccao,
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
    }
  }
}

