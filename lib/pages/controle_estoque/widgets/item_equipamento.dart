import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/user_model.dart';
import '../../../../constants/constants.dart';
import '../../../../utils/dialogs/deletar_equipamento.dart';
import '../../../../utils/models/equipamento.dart';
import '../../../../utils/models/paciente.dart';
import '../../../../utils/services/firebase.dart';
import '../../perfis/perfil_equipamento/tela_equipamento.dart';

class ItemEquipamento extends StatefulWidget {
  final String id;
  const ItemEquipamento({required this.id, Key? key}) : super(key: key);

  @override
  State<ItemEquipamento> createState() => _ItemEquipamentoState();
}

class _ItemEquipamentoState extends State<ItemEquipamento> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
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
                  return const Center(
                    child: CircularProgressIndicator(),
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
                                  builder: (context) =>
                                      TelaEquipamento(id: widget.id)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 2,
                                  color: Constantes.corAzulEscuroPrincipal),
                              color: Colors.white),
                          //height: MediaQuery.of(context).size.height * 0.2,
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
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                            equipamento.urlFotoDePerfil ??
                                                model.semimagem,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.26,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.14,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 30,
                                              width: 30,
                                              decoration: const BoxDecoration(
                                                color: Constantes
                                                    .corAzulEscuroPrincipal,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: Constantes.cor[
                                                      Constantes.status3
                                                          .indexOf(equipamento
                                                              .status
                                                              .emString)],
                                                ),
                                                child: Icon(
                                                  Constantes.icone[Constantes
                                                      .status3
                                                      .indexOf(equipamento
                                                          .status.emString)],
                                                  size: 20,
                                                  color: Constantes
                                                      .corAzulEscuroPrincipal,
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
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
                                          if (equipamento.tipo ==
                                                  TipoEquipamento.nasal ||
                                              equipamento.tipo ==
                                                  TipoEquipamento.oronasal ||
                                              equipamento.tipo ==
                                                  TipoEquipamento.facial ||
                                              equipamento.tipo ==
                                                  TipoEquipamento.pillow)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Tamanho",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromARGB(
                                                          221, 137, 137, 137),
                                                      decoration: TextDecoration
                                                          .underline),
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
                                              const Text(
                                                "Fabricante",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        221, 137, 137, 137),
                                                    decoration: TextDecoration
                                                        .underline),
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
                                                              const Text(
                                                                "Paciente emprestado",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            221,
                                                                            137,
                                                                            137,
                                                                            137),
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline),
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
                                                    const Text(
                                                      "Previsão para entrega",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              221,
                                                              137,
                                                              137,
                                                              137),
                                                          decoration:
                                                              TextDecoration
                                                                  .underline),
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
                                                    const Text(
                                                      "Data de despache",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              221,
                                                              137,
                                                              137,
                                                              137),
                                                          decoration:
                                                              TextDecoration
                                                                  .underline),
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
