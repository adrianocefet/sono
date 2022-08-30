import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Solicitacao{
  late final Map<String, dynamic> infoMap;
  late final String id;
  late final TipoSolicitacao tipo;
  late final String idEquipamento;
  late final String idPaciente;
  late Confirmacao confirmacao;
  late final String idSolicitante;
  late final DateTime dataDaSolicitacao;
  late final String hospital;
  late final String? motivo;
  late final DateTime? dataDeResposta;

  String get dataDaSolicitacaoEmString {
    return DateFormat('dd/MM/yyyy kk:mm:ss').format(dataDaSolicitacao);
  }
  String get dataDeRespostaEmString {
    return dataDeResposta!=null?
    DateFormat('dd/MM/yyyy kk:mm:ss').format(dataDeResposta!):'-';
  }

  Solicitacao(this.infoMap) {
  id = infoMap["id"];
  _setarInfo();
  }

  Solicitacao.porDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    infoMap = document.data() as Map<String, dynamic>;
    id = document.id;
    _setarInfo();
  }

  void _setarInfo(){
    idEquipamento = infoMap['equipamento'];
    idPaciente = infoMap['paciente'];
    idSolicitante = infoMap['solicitante'];
    hospital = infoMap['hospital'];
    confirmacao = _lerConfirmacao(infoMap['confirmacao']??'pendente')!;
    motivo = infoMap['motivo'];
    infoMap["data_da_solicitacao"]!=null?
    dataDaSolicitacao=(infoMap["data_da_solicitacao"] as Timestamp).toDate():dataDeResposta=null;
    tipo = _lerTipo(infoMap['tipo']??'emprestimo')!;
    infoMap["data_de_resposta"]!=null?
    dataDeResposta = (infoMap["data_de_resposta"] as Timestamp).toDate():dataDeResposta=null;
  }

  Confirmacao? _lerConfirmacao(String confirmacao){
    switch(confirmacao){
      case 'pendente':
        return Confirmacao.pendente;
      case 'confirmado':
        return Confirmacao.confirmado;
      case 'negado':
        return Confirmacao.negado;
    }
    return null;
  }

  TipoSolicitacao? _lerTipo(String tipo){
    switch(tipo){
      case 'emprestimo':
        return TipoSolicitacao.emprestimo;
      case 'devolucao':
        return TipoSolicitacao.devolucao;
    }
    return null;
  }

}

extension ExtensaoConfirmacaoSolicitacao on Confirmacao{
  String get emString{
    switch(this){
      case Confirmacao.pendente:
        return 'Pendente';
      case Confirmacao.confirmado:
        return 'Confirmado';
      case Confirmacao.negado:
        return 'Negado';
    }
  }
}

extension ExtensaoTipoSolicitacao on TipoSolicitacao{
  String get emString{
    switch(this){
      case TipoSolicitacao.devolucao:
        return 'Devolução';
      case TipoSolicitacao.emprestimo:
        return 'Empréstimo';
    }
  }
}

enum Confirmacao{
  pendente,
  confirmado,
  negado
}

enum TipoSolicitacao{
  emprestimo,
  devolucao
}