import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../constants/constants.dart';
import '../../../../utils/dialogs/carregando.dart';
import '../../../../utils/dialogs/confirmar.dart';
import '../../../../utils/dialogs/error_message.dart';
import '../../../../utils/dialogs/justificativa.dart';
import '../../../../utils/models/equipamento.dart';
import '../../../../utils/models/paciente.dart';
import '../../../../utils/models/usuario.dart';
import '../../../../utils/services/firebase.dart';
import '../../../tabelas/widgets/item_paciente.dart';
import '../../../tabelas/widgets/item_usuario.dart';

class Detalhes extends StatefulWidget {
  final Usuario model;
  final Equipamento equipamento;
  final BuildContext contextoScaffold;
  const Detalhes(
      {Key? key,
      required this.model,
      required this.equipamento,
      required this.contextoScaffold})
      : super(key: key);

  @override
  State<Detalhes> createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              color: Constantes.corAzulEscuroSecundario,
            ),
            height: 30,
            child: const Text(
              "Detalhes",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Visibility(
              visible: widget.equipamento.status ==
                      StatusDoEquipamento.emprestado ||
                  widget.equipamento.status == StatusDoEquipamento.concedido,
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseService().streamInfoPacientePorID(
                      widget.equipamento.idPacienteResponsavel ?? 'N/A'),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: LinearProgressIndicator(
                              color: Constantes.corAzulEscuroPrincipal,
                            ),
                          ),
                        );
                      default:
                        Paciente pacienteEmprestado =
                            Paciente.porDocumentSnapshot(snapshot.data!);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "Paciente",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Constantes.corAzulEscuroSecundario,
                                  ),
                                ),
                              ),
                              const Divider(),
                              Row(
                                children: [
                                  FotoDoPacienteThumbnail(
                                    pacienteEmprestado.urlFotoDePerfil,
                                    statusPaciente: pacienteEmprestado.status,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      pacienteEmprestado.nomeCompleto,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 16.0),
                                    child: Text(
                                      "Data de expedição",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Constantes.corAzulEscuroSecundario,
                                      ),
                                    ),
                                  ),
                                  Text(widget
                                      .equipamento.dataDeExpedicaoEmString),
                                ],
                              ),
                              Visibility(
                                visible: [
                                  PerfilUsuario.mestre,
                                  PerfilUsuario.dispensacao,
                                  PerfilUsuario.vigilancia
                                ].contains(widget.model.perfil),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromRGBO(
                                              97, 253, 125, 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          )),
                                      onPressed: () async {
                                        final scaffoldcontext =
                                            ScaffoldMessenger.of(
                                                widget.contextoScaffold);
                                        String? justificativa =
                                            await mostrarDialogJustificativa(
                                                context,
                                                'Retornar ao hospital?',
                                                'Qual o motivo da devolução?');
                                        if (justificativa != null) {
                                          mostrarDialogCarregando(
                                              widget.contextoScaffold);
                                          try {
                                            await widget.equipamento
                                                .solicitarDevolucao(
                                                    pacienteEmprestado,
                                                    widget.model,
                                                    justificativa);
                                          } catch (e) {
                                            mostrarMensagemErro(
                                                context, e.toString());
                                          }
                                          Navigator.pop(
                                              widget.contextoScaffold);
                                          scaffoldcontext.showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Constantes
                                                  .corAzulEscuroPrincipal,
                                              content: Text(
                                                  "Solicitação enviada à dispensação!"),
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        widget.equipamento.status ==
                                                StatusDoEquipamento.emprestado
                                            ? "Solicitar devolução"
                                            : "Voltar ao hospital",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: [
                                  PerfilUsuario.mestre,
                                  PerfilUsuario.dispensacao,
                                  PerfilUsuario.vigilancia
                                ].contains(widget.model.perfil),
                                child: Visibility(
                                  visible: widget.equipamento.status ==
                                      StatusDoEquipamento.emprestado,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    97, 253, 125, 1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            )),
                                        onPressed: () async {
                                          if (await mostrarDialogConfirmacao(
                                                  context,
                                                  'Deseja mesmo conceder?',
                                                  'Ele será concedido ao paciente atualmente emprestado') ==
                                              true) {
                                            mostrarDialogCarregando(context);
                                            try {
                                              await widget.equipamento.conceder(
                                                  pacienteEmprestado,
                                                  widget.model);
                                            } catch (erro) {
                                              mostrarMensagemErro(
                                                  context, erro.toString());
                                            }
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(
                                                    widget.contextoScaffold)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Constantes
                                                    .corAzulEscuroPrincipal,
                                                content: Text(
                                                    "Equipamento concedido ao paciente atual!"),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text(
                                          "Conceder ao paciente",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                    }
                  })),
          Visibility(
            visible: widget.equipamento.status ==
                    StatusDoEquipamento.manutencao ||
                widget.equipamento.status == StatusDoEquipamento.desinfeccao,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Enviado à ${widget.equipamento.status.emStringMaiuscula} por",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constantes.corAzulEscuroSecundario,
                      ),
                    ),
                  ),
                  const Divider(),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseService().streamInfoUsuarioPorID(
                          widget.equipamento.alteradoPor ?? 'N/A'),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const Center(
                              child: LinearProgressIndicator(),
                            );
                          default:
                            Usuario profissionalQueModificouStatus =
                                Usuario.porDocumentSnapshot(snapshot.data!);
                            return Row(
                              children: [
                                FotoDoUsuarioThumbnail(
                                    profissionalQueModificouStatus
                                        .urlFotoDePerfil),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    profissionalQueModificouStatus.nomeCompleto,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            );
                        }
                      }),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Data de expedição",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constantes.corAzulEscuroSecundario,
                      ),
                    ),
                  ),
                  Text(widget.equipamento.dataDeExpedicaoEmString),
                  Visibility(
                    visible: widget.equipamento.status ==
                        StatusDoEquipamento.desinfeccao,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Previsão de entrega",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Constantes.corAzulEscuroSecundario,
                            ),
                          ),
                        ),
                        Text(widget
                                .equipamento.dataDeDevolucaoEmStringFormatada ??
                            'Indefinido!'),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: [PerfilUsuario.mestre, PerfilUsuario.dispensacao]
                        .contains(widget.model.perfil),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(97, 253, 125, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                          onPressed: () async {
                            if (await mostrarDialogConfirmacao(
                                    context,
                                    'Deseja mesmo disponibilizar?',
                                    'Ele será alterado para Disponível') ==
                                true) {
                              mostrarDialogCarregando(context);
                              try {
                                widget.equipamento.disponibilizar();
                                widget.equipamento.status =
                                    StatusDoEquipamento.disponivel;
                              } catch (e) {
                                mostrarMensagemErro(context, e.toString());
                              }
                              Navigator.pop(context);
                              ScaffoldMessenger.of(widget.contextoScaffold)
                                  .showSnackBar(
                                const SnackBar(
                                  backgroundColor:
                                      Constantes.corAzulEscuroPrincipal,
                                  content: Text("Equipamento disponibilizado!"),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "Disponibilizar",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
