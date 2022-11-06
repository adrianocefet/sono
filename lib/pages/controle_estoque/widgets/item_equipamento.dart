import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/perfis/perfil_equipamento/equipamento_controller.dart';
import 'package:sono/utils/models/usuario.dart';
import '../../../../constants/constants.dart';
import '../../../../utils/dialogs/deletar_equipamento.dart';
import '../../../../utils/models/equipamento.dart';
import '../../../../utils/models/paciente.dart';
import '../../../../utils/services/firebase.dart';
import '../../perfis/perfil_equipamento/tela_equipamento.dart';
import 'foto_equipamento.dart';

class ItemEquipamento extends StatefulWidget {
  final ControllerPerfilClinicoEquipamento controller;
  final String id;
  final Paciente? pacientePreEscolhido;
  const ItemEquipamento(
      {required this.controller,
      required this.id,
      this.pacientePreEscolhido,
      Key? key})
      : super(key: key);

  @override
  State<ItemEquipamento> createState() => _ItemEquipamentoState();
}

class _ItemEquipamentoState extends State<ItemEquipamento> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Usuario>(
      builder: (context, child, model) {
        return StreamBuilder(
            stream: FirebaseService.streamEquipamento(widget.id),
            builder: (
              context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
            ) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: Constantes.corAzulEscuroPrincipal,
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight: Radius.circular(7),
                              ),
                              color: Constantes.corAzulEscuroSecundario,
                            ),
                            height: 25,
                            child: null,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: LinearProgressIndicator(
                                color: Constantes.corAzulEscuroPrincipal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                default:
                  Map<String, dynamic> dadosEquipamento =
                      snapshot.data!.data()!;
                  dadosEquipamento["id"] = snapshot.data!.id;

                  Equipamento equipamento =
                      Equipamento.porMap(dadosEquipamento);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                        splashColor: Constantes.corAzulEscuroSecundario,
                        onLongPress: () {
                          mostrarDialogDeletarEquipamento(
                              context, equipamento.id);
                        },
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TelaEquipamento(
                                      controller: widget.controller,
                                      id: widget.id,
                                      pacientePreEscolhido:
                                          widget.pacientePreEscolhido)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: Constantes.corAzulEscuroPrincipal,
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(7),
                                    topRight: Radius.circular(7),
                                  ),
                                  color: Constantes.corAzulEscuroSecundario,
                                ),
                                height: 25,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    equipamento.nome,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    FotoEquipamento(
                                        equipamento: equipamento,
                                        semimagem: widget.controller.semimagem),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (equipamento.tipo.emStringSnakeCase
                                              .contains('mascara'))
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Tamanho",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                                Text(
                                                  equipamento.tamanho ?? "N/A",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black,
                                                      fontSize: 10),
                                                  softWrap: true,
                                                  overflow: TextOverflow.fade,
                                                ),
                                              ],
                                            ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Fabricante",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                              Text(
                                                equipamento.fabricante,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          Visibility(
                                              visible: equipamento.status ==
                                                  StatusDoEquipamento
                                                      .emprestado,
                                              child: StreamBuilder<
                                                      DocumentSnapshot<
                                                          Map<String,
                                                              dynamic>>>(
                                                  stream: FirebaseService()
                                                      .streamInfoPacientePorID(
                                                          equipamento
                                                                  .idPacienteResponsavel ??
                                                              'N/A'),
                                                  builder: (context, snapshot) {
                                                    switch (snapshot
                                                        .connectionState) {
                                                      case ConnectionState.none:
                                                      case ConnectionState
                                                          .waiting:
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      default:
                                                        Paciente
                                                            pacienteEmprestado =
                                                            Paciente
                                                                .porDocumentSnapshot(
                                                                    snapshot
                                                                        .data!);
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Paciente emprestado",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                              Text(
                                                                pacienteEmprestado
                                                                    .nomeCompleto,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                    }
                                                  })),
                                          Visibility(
                                              visible: equipamento.status ==
                                                  StatusDoEquipamento
                                                      .desinfeccao,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Previsão para entrega",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      equipamento
                                                              .dataDeDevolucaoEmStringFormatada ??
                                                          "Indefinida",
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          Visibility(
                                              visible: equipamento.status !=
                                                  StatusDoEquipamento
                                                      .disponivel,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Data de despache",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      equipamento
                                                          .dataDeExpedicaoEmString,
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Constantes.corAzulEscuroPrincipal,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  );
              }
            });
      },
    );
  }
}
