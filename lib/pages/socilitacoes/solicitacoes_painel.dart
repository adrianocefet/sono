import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/solicitacao.dart';
import 'package:sono/utils/services/firebase.dart';

import '../../constants/constants.dart';
import '../../utils/dialogs/error_message.dart';
import '../../utils/models/paciente.dart';
import '../../utils/models/user_model.dart';
import 'dialog/negar_solicitacao.dart';

class SolicitacoesPainel extends StatefulWidget {
  final String idSolicitacao;
  const SolicitacoesPainel({Key? key,required this.idSolicitacao}) : super(key: key);

  @override
  State<SolicitacoesPainel> createState() => _SolicitacoesPainelState();
}

class _SolicitacoesPainelState extends State<SolicitacoesPainel> {
  @override
  Widget build(BuildContext context) {
    late Paciente pacienteSolicitado;
    late Equipamento equipamentoSolicitado;
    bool estaDisponivel;
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) => 
       StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
        stream: FirebaseService.streamSolicitacao(widget.idSolicitacao),
        builder: (context, snapshot) {
          final Color corStatus;
          if(snapshot.hasData){
          Solicitacao solicitacao = Solicitacao.porDocumentSnapshot(snapshot.data!);
          switch(solicitacao.confirmacao){
            case Confirmacao.pendente:
              corStatus=Constantes.dom6Color;
              break;
            case Confirmacao.confirmado:
              corStatus=Constantes.dom51Color;
              break;
            case Confirmacao.negado:
              corStatus = Constantes.dom2Color;
              break;
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
            child: Container(
                decoration: BoxDecoration(
                border: Border.all(width: 2,color: Constantes.corAzulEscuroPrincipal),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.white
            ),
              child: ExpansionTile(
                childrenPadding: const EdgeInsets.all(10),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                expandedAlignment: Alignment.topLeft,
                textColor: Constantes.corAzulEscuroPrincipal,
                collapsedTextColor: Colors.black,
                iconColor: Constantes.corAzulEscuroPrincipal,
                collapsedIconColor: corStatus,
                leading: const Icon(Icons.people),
                title: Text("${solicitacao.tipo.emString}\n${solicitacao.dataDaSolicitacaoEmString}",style: const TextStyle(fontWeight: FontWeight.w300),),
                subtitle: Text(solicitacao.confirmacao.emString,style: TextStyle(color: corStatus,fontWeight: FontWeight.bold),),
                children: [
                      Visibility(
                        visible: solicitacao.confirmacao==Confirmacao.negado,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Padding(
                              padding: EdgeInsets.only(top:8.0,left: 15),
                              child: 
                                Text('Motivo',
                                  style: TextStyle(color: corStatus,fontSize: 15,fontWeight: FontWeight.bold),),
                            ),
                            Divider(color: corStatus,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                              child: Text(solicitacao.motivo??'Sem motivo definido!'),
                            ),
                          ],
                        )
                        
                        ),
                      Visibility(
                        visible: solicitacao.confirmacao!=Confirmacao.pendente,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Padding(
                              padding: EdgeInsets.only(top:8.0,left: 15),
                              child: 
                                Text('Data de resposta',
                                  style: TextStyle(color: corStatus,fontSize: 15,fontWeight: FontWeight.bold),),
                            ),
                            Divider(color: corStatus,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                              child: Text(solicitacao.dataDeRespostaEmString),
                            ),
                          ],
                        )
                        
                        ),
                      const Padding(
                        padding: EdgeInsets.only(top:8.0,left: 15),
                        child: 
                          Text('Solicitante',
                            style: TextStyle(color: Color.fromARGB(221, 171, 171, 171),fontSize: 15,fontWeight: FontWeight.bold),),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                        child: Text(solicitacao.idSolicitante),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top:8.0,left: 15),
                        child: 
                          Text('Data da solicitação',
                            style: TextStyle(color: Color.fromARGB(221, 171, 171, 171),fontSize: 15,fontWeight: FontWeight.bold),),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                        child: Text(solicitacao.dataDaSolicitacaoEmString),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top:8.0,left: 15),
                        child: 
                          Text('Equipamento',
                            style: TextStyle(color: Color.fromARGB(221, 171, 171, 171),fontSize: 15,fontWeight: FontWeight.bold),),
                      ),
                      const Divider(),
                      StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
                        stream: FirebaseService.streamEquipamento(solicitacao.idEquipamento),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            default:
                          Map<String, dynamic> dadosEquipamento = snapshot.data!.data()!;
                          dadosEquipamento["id"] = snapshot.data!.id;
                          equipamentoSolicitado = Equipamento.porMap(dadosEquipamento);
                          equipamentoSolicitado.status!=StatusDoEquipamento.disponivel? estaDisponivel = false : estaDisponivel=true;
                          return Column(
                            children: [
                              ListTile(
                                title: equipamentoSolicitado.tamanho==null?Text(equipamentoSolicitado.nome):Text("${equipamentoSolicitado.nome}\n(Tamanho:${equipamentoSolicitado.tamanho})"),
                                subtitle: Text(equipamentoSolicitado.tipo.emString),
                                leading: Image.network( equipamentoSolicitado.urlFotoDePerfil??model.semimagem,height: 50,width: 50,fit: BoxFit.cover,),
                              ),
                            ],
                          );
                        }}
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top:8.0,left: 15),
                        child: Text('Paciente',
                          style: TextStyle(color: Color.fromARGB(221, 171, 171, 171),fontSize: 15,fontWeight: FontWeight.bold),),
                      ),
                      const Divider(),
                      StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
                        stream: FirebaseService().streamInfoPacientePorID(solicitacao.idPaciente),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            default:
                          pacienteSolicitado = Paciente.porDocumentSnapshot(snapshot.data!);
                          return ListTile(
                            title: Text(pacienteSolicitado.nomeCompleto),
                            subtitle: Text("Prontuário: ${pacienteSolicitado.numeroProntuario}"),
                            leading: Image.network(pacienteSolicitado.urlFotoDePerfil??model.semimagem,height: 50,width: 50,fit: BoxFit.cover,),
                          );
                        }}
                      ),
                      Visibility(
                        visible: solicitacao.confirmacao==Confirmacao.pendente,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical:8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () async{
                                  negarSolicitacao(context,solicitacao);
                                }, 
                                child: const Text('Negar',style: TextStyle(color: Colors.black),),
                                style: ElevatedButton.styleFrom(
                                  primary: const Color.fromRGBO(97, 253, 125, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(18.0),
                                  )),
                                ),
                              ElevatedButton(
                                onPressed: () async {
                                  if(solicitacao.tipo==TipoSolicitacao.emprestimo){
                                        if(equipamentoSolicitado.status==StatusDoEquipamento.disponivel){
                                          try {
                                            equipamentoSolicitado.status =
                                                StatusDoEquipamento
                                                    .emprestado;
                                            await equipamentoSolicitado
                                                .emprestarPara(
                                                    pacienteSolicitado);
                                            solicitacao.infoMap['confirmacao']='confirmado';
                                            FirebaseService.atualizarSolicitacao(solicitacao);
                                          } catch (erro) {
                                            equipamentoSolicitado.status =
                                                StatusDoEquipamento
                                                    .disponivel;
                                            mostrarMensagemErro(
                                                context,
                                                erro.toString());
                                          }
                                        }
                                        else{
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Constantes.corAzulEscuroPrincipal,
                                              content: Text(
                                                "Esse equipamento não está disponível!"
                                              ),
                                            ),
                                          );
                                        }
                                      }else{
                                        if(equipamentoSolicitado.status==StatusDoEquipamento.emprestado){
                                          try {
                                          equipamentoSolicitado.status =
                                              StatusDoEquipamento
                                                  .disponivel;
                                          await equipamentoSolicitado
                                              .devolver();
                                          solicitacao.infoMap['confirmacao']='confirmado';
                                          FirebaseService.atualizarSolicitacao(solicitacao);
                                        } catch (erro) {
                                          equipamentoSolicitado.status =
                                              StatusDoEquipamento
                                                  .emprestado;
                                          mostrarMensagemErro(
                                              context,
                                              erro.toString());
                                        }
                                        }else{
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Constantes.corAzulEscuroPrincipal,
                                              content: Text(
                                                "Esse equipamento não está mais emprestado!"
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                }, 
                                child: Text(solicitacao.tipo==TipoSolicitacao.emprestimo?'Emprestar':'Devolver',style: TextStyle(color: Colors.black),),
                                style: ElevatedButton.styleFrom(
                                  primary: const Color.fromRGBO(97, 253, 125, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(18.0),
                                  )),
                                ),
                            ],
                          ),
                        ),
                      )
                ],
                ),
            ),
          );
        }else if (snapshot.hasError) {
                return const Center(
                  child: Text('ERRO!'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(color: Constantes.corAzulEscuroPrincipal,),
                );
              }
        }
      ),
    );
  }
}