import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/user_model.dart';
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
    return dataDeExpedicao!=null?
    DateFormat('dd/MM/yyyy kk:mm:ss').format(dataDeExpedicao!):'-';
    
  }

  String? get dataDeDevolucaoEmStringFormatada {
    return dataDeExpedicao != null ? _formatarData(calcularDataDeDevolucao) : null;
  }

  Map<String, dynamic> _setInfoMap() => {
        'nome': nome,
        "id": id,
        "status": status,
        "tipo": tipo,
        "hospital": hospital,
        "fabricante":fabricante,
        "url_foto": urlFotoDePerfil,
        "informacoes_tecnicas":informacoesTecnicas,
        "higiene_e_cuidados_paciente": higieneECuidadosPaciente,
        "paciente_responsavel": idPacienteResponsavel,
        "alterado_por": alteradoPor,
        "video_instrucional": videoInstrucional,
        "manual": manualPdf,
        "descrição": descricao,
        "tamanho": tamanho,
        "observação": observacao,
        "data_de_expedicao": dataDeExpedicaoEmString,
        "data_de_devolucao": dataDeDevolucaoEmStringFormatada 
      };

  Equipamento(
    this.nome,
    this.id,
    this.status,{
    this.urlFotoDePerfil,
  });

  Equipamento.porMap(equipamentoInfoMap) {
    nome = equipamentoInfoMap["nome"];
    id = equipamentoInfoMap["id"];
    idPacienteResponsavel = equipamentoInfoMap["paciente_responsavel"];
    urlFotoDePerfil =
        equipamentoInfoMap["url_foto"];
    descricao =
        equipamentoInfoMap["descrição"];
    tipo = _lerTipoDeEquipamentoDoBancoDeDados(equipamentoInfoMap["tipo"])!;
    hospital=equipamentoInfoMap["hospital"];
    equipamentoInfoMap["informacoes_tecnicas"]!=null?
    informacoesTecnicas = equipamentoInfoMap["informacoes_tecnicas"]:informacoesTecnicas='';
    equipamentoInfoMap["higiene_e_cuidados_paciente"]!=null?
    higieneECuidadosPaciente = equipamentoInfoMap["higiene_e_cuidados_paciente"]:higieneECuidadosPaciente=null;
    fabricante =
        equipamentoInfoMap["fabricante"];
    alteradoPor =
        equipamentoInfoMap["alterado_por"];
    manualPdf =
        equipamentoInfoMap["manual"];
    videoInstrucional =
        equipamentoInfoMap["video_instrucional"];
     status = _lerStatusDoEquipamentoDoBancoDeDados(
      equipamentoInfoMap["status"] ??
          "disponível",
    )!;
     
     tamanho= equipamentoInfoMap["tamanho"] ?? equipamentoInfoMap["Tamanho"];
     equipamentoInfoMap["data_de_expedicao"]!=null?
     dataDeExpedicao = (equipamentoInfoMap["data_de_expedicao"] as Timestamp).toDate():dataDeExpedicao=null;
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
      case 'bilevel':  
        return TipoEquipamento.bilevel;
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
    }

    return null;
  }

  Future<void> emprestarPara(Paciente paciente) async =>
      await FirebaseService().emprestarEquipamento(this, paciente);

  Future<void> solicitarEmprestimo(Paciente paciente, UserModel usuario) async =>
      await FirebaseService().solicitarEmprestimoEquipamento(this, paciente, usuario);

  Future<void> solicitarDevolucao(Paciente paciente, UserModel usuario, String justificativa) async =>
      await FirebaseService().solicitarDevolucaoEquipamento(this, paciente, usuario, justificativa);

  Future<void> devolver() async =>
      await FirebaseService().devolverEquipamento(this);

  Future<void> desinfectar(UserModel usuario) async {
    await FirebaseService().desinfectarEquipamento(this, usuario);
  }

  Future<void> manutencao(UserModel usuario) async {
    await FirebaseService().repararEquipamento(this,usuario);
  }

  Future<void> disponibilizar() async {
    await FirebaseService().disponibilizarEquipamento(this);
  }

  Future<void> conceder(Paciente paciente, UserModel usuario) async {
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
  bilevel,
  avap,
  autocpap
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
      case TipoEquipamento.bilevel:
        return 'BiLevel';
      case TipoEquipamento.autocpap:
        return 'AutoCPAP';
      case TipoEquipamento.avap:
        return 'AVAPS';
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
      case TipoEquipamento.bilevel:
        return 'bilevel';
      case TipoEquipamento.autocpap:
        return 'autocpap';
      case TipoEquipamento.avap:
        return 'avaps';
    }
  }
  String get imagens{
  switch(this){
    case TipoEquipamento.nasal:
      return 'https://www.cpapmed.com.br/media/W1siZiIsIjIwMTQvMDYvMTgvMTVfMDZfMjhfOTk2X1RydWVCbHVlXzEuanBnIl1d/TrueBlue-1.jpg';
    case TipoEquipamento.oronasal:
      return 'https://www.cpapmed.com.br/media/W1siZiIsIjIwMTQvMDYvMTcvMTNfNDNfMDZfODUwX0FtYXJhXzEuanBnIl0sWyJwIiwidGh1bWIiLCI0MDB4NDAwPiJdXQ/Amara-1.jpg';
    case TipoEquipamento.pillow:
      return 'https://a3.vnda.com.br/650x/espacoquallys/2019/09/13/10252-mascara-cpap-pillow-breeze-sefam-5146.jpg?v=1568415183';
    case TipoEquipamento.facial:
      return 'https://www.cpapmed.com.br/media/W1siZiIsIjIwMTMvMDUvMjEvMjFfNDVfMjBfNDk5X0ZpdExpZmUuanBnIl1d/FitLife.jpg';
    case TipoEquipamento.traqueia:
      return 'https://static.cpapfit.com.br/public/cpapfit/imagens/produtos/mini-traqueia-para-mascara-swift-fx-resmed-720.jpg';
    case TipoEquipamento.fixador:
      return 'https://static.cpapfit.com.br/public/cpapfit/imagens/produtos/fixador-para-mascara-facial-fitlife-e-performax-philips-respironics-1042.jpg';
    case TipoEquipamento.almofada:
      return 'https://www.cpapbiancoazure.com.br/upload/produto/imagem/almofada-em-gel-e-aba-em-silicone-p-m-scara-nasal-comfortegel-blue-original-philips-respironics-1.jpg';
    case TipoEquipamento.cpap:
      return 'https://static.cpapfit.com.br/public/cpapfit/imagens/produtos/cpap-basico-airsense-s10-com-umidificador-integrado-resmed-916.png';
    case TipoEquipamento.autocpap:
      return 'https://cdn.awsli.com.br/600x450/49/49309/produto/41467334/7a540efde2.jpg';
    case TipoEquipamento.bilevel:
      return 'https://www.cpapmed.com.br/media/W1siZiIsIjIwMjEvMDMvMDkvMDlfMjBfMzNfODE0X2JpcGFwX3loXzczMF9nYXNsaXZlX3l1d2VsbC5qcGciXSxbInAiLCJ0aHVtYiIsIjQwMHg0MDA%2BIl1d/bipap-yh-730-gaslive-yuwell.jpg';
    case TipoEquipamento.avap:
      return 'https://cdn.awsli.com.br/600x450/437/437629/produto/21439696/6beb7653fe.jpg';
  }  
  }
}

enum StatusDoEquipamento {
  emprestado,
  disponivel,
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
}

