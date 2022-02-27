import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:sono/utils/models/paciente/paciente.dart';
import 'package:sono/utils/services/firebase.dart';

class Equipamento {
  late final Map<String, dynamic> infoMap;
  late final String nome;
  late final String id;
  late final String? descricao;
  late final TipoEquipamento tipo;
  late StatusDoEquipamento status;
  late String? idPacienteResponsavel;
  late final String? urlFotoDePerfil;
  late final String? idStatus;

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
        "equipamento": tipo,
        "status": status,
        "foto_de_perfil": urlFotoDePerfil,
        "data_de_expedicao": dataDeExpedicaoEmStringFormatada,
        "paciente_responsavel": idPacienteResponsavel,
        "descricao": descricao,
      };

  Equipamento(
    this.nome,
    this.id,
    this.tipo,
    this.status, {
    this.urlFotoDePerfil,
  });

  Equipamento.porMap(equipamentoInfoMap) {
    nome = equipamentoInfoMap["Nome"] ?? equipamentoInfoMap["nome"];
    id = equipamentoInfoMap["id"];
    idPacienteResponsavel = equipamentoInfoMap["paciente_responsavel"];
    urlFotoDePerfil =
        equipamentoInfoMap["foto_de_perfil"] ?? equipamentoInfoMap["Foto"];
    descricao =
        equipamentoInfoMap["descricao"] ?? equipamentoInfoMap["Descrição"];

    tipo = _lerTipoDeEquipamentoDoBancoDeDados(
      equipamentoInfoMap["tipo"] ?? equipamentoInfoMap["Equipamento"],
    )!;

    status = _lerStatusDoEquipamentoDoBancoDeDados(
      equipamentoInfoMap["status"] ??
          equipamentoInfoMap["Status"] ??
          "Disponível",
    )!;

    infoMap = equipamentoInfoMap;
  }

  String? _formatarData(DateTime? data) =>
      DateFormat("dd/MM/yy").format(data!);

  StatusDoEquipamento? _lerStatusDoEquipamentoDoBancoDeDados(
    String status,
  ) {
    switch (status) {
      case "Emprestado":
        return StatusDoEquipamento.emprestado;
      case "Disponível":
        return StatusDoEquipamento.disponivel;
      case "Manutenção":
        return StatusDoEquipamento.manutencao;
      case "Desinfecção":
        return StatusDoEquipamento.desinfeccao;
    }

    return null;
  }

  TipoEquipamento? _lerTipoDeEquipamentoDoBancoDeDados(String tipo) {
    switch (tipo) {
      case "Almofadas":
        return TipoEquipamento.almofada;
      case "CPAPs":
        return TipoEquipamento.cpap;
      case "Traqueias":
        return TipoEquipamento.traqueia;
      case "Interfaces":
        return TipoEquipamento.interface;
      case "Fixadores":
        return TipoEquipamento.fixador;
      case "Filtros":
        return TipoEquipamento.filtro;
    }

    return null;
  }

  Future<void> emprestarPara(Paciente paciente) async =>
      await FirebaseService().emprestarEquipamento(this, paciente);

  Future<void> devolver() async =>
      await FirebaseService().devolverEquipamento(this);
}

enum TipoEquipamento {
  interface,
  almofada,
  fixador,
  traqueia,
  filtro,
  cpap,
}

extension ExtensaoTipoEquipamento on TipoEquipamento {
  String get emString {
    switch (this) {
      case TipoEquipamento.almofada:
        return "Almofadas";
      case TipoEquipamento.cpap:
        return "CPAPs";
      case TipoEquipamento.traqueia:
        return "Traqueias";
      case TipoEquipamento.interface:
        return "Interfaces";
      case TipoEquipamento.fixador:
        return "Fixadores";
      case TipoEquipamento.filtro:
        return "Filtros";
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
        return "Emprestado";
      case StatusDoEquipamento.disponivel:
        return "Disponível";
      case StatusDoEquipamento.manutencao:
        return "Manutenção";
      case StatusDoEquipamento.desinfeccao:
        return "Desinfecção";
    }
  }
}
