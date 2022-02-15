import 'package:sono/utils/models/paciente/paciente.dart';
import 'package:sono/utils/services/firebase.dart';

class Equipamento {
  late final Map<String, dynamic> infoMap;
  late final String nome;
  late final String id;
  late final TipoEquipamento tipo;
  late final StatusDoEquipamento status;
  late final String? urlFotoDePerfil;
  late final String? descricao;
  late final String? idStatus;

  Equipamento(this.nome, this.id, this.tipo, this.status,
      {this.urlFotoDePerfil}) {
    infoMap = {
      'nome': nome,
      "id": id,
      "tipo": tipo,
      "status": status,
      "urlFotoDePerfil": urlFotoDePerfil,
    };
  }

  Equipamento.fromMap(this.infoMap) {
    nome = infoMap["nome"];
    id = infoMap["id"];
    tipo = infoMap["tipo"];
    status = infoMap["status"];
    urlFotoDePerfil = infoMap["urlFotoDePerfil"];
  }

  Future<void> emprestarPara(Paciente paciente) async =>
      FirebaseService().emprestarEquipamento(this, paciente);
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
  comPaciente,
  emDeposito,
  naManutencao,
  naLimpeza,
}

extension ExtensaoStatusDoEquipamento on StatusDoEquipamento {
  String get emString {
    switch (this) {
      case StatusDoEquipamento.comPaciente:
        return "Com paciente";
      case StatusDoEquipamento.emDeposito:
        return "Em deposito";
      case StatusDoEquipamento.naLimpeza:
        return "Na limpeza";
      case StatusDoEquipamento.naManutencao:
        return "Na manutencao";
    }
  }
}
