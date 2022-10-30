// ignore_for_file: unnecessary_string_escapes
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/perfis/perfil_equipamento/adicionar_equipamento.dart';
import 'package:sono/pages/perfis/perfil_equipamento/equipamento_controller.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/informacoes_adicionais.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/adicionarObservacao.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/atributos_equipamento.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/titulo_e_foto.dart';
import 'package:sono/pages/tabelas/tab_historico_emprestimos.dart';
import 'package:sono/utils/dialogs/confirmar.dart';
import 'package:sono/utils/dialogs/error_message.dart';
import 'package:sono/utils/dialogs/justificativa.dart';
import 'package:sono/utils/models/paciente.dart';
import '../../../../utils/models/equipamento.dart';
import 'package:sono/pdf/pdf_api.dart';
import 'package:sono/utils/models/usuario.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../pdf/tela_pdf.dart';
import '../../../utils/dialogs/carregando.dart';
import '../../../utils/dialogs/escolher_paciente_dialog.dart';
import '../../../utils/services/firebase.dart';
import '../../tabelas/widgets/item_paciente.dart';
import '../../tabelas/widgets/item_usuario.dart';

class TelaEquipamento extends StatefulWidget {
  final ControllerPerfilClinicoEquipamento controller;
  final String id;
  final Paciente? pacientePreEscolhido;
  const TelaEquipamento(
      {required this.controller,
      required this.id,
      this.pacientePreEscolhido,
      Key? key})
      : super(key: key);

  @override
  State<TelaEquipamento> createState() => _TelaEquipamentoState();
}

class _TelaEquipamentoState extends State<TelaEquipamento> {
  late YoutubePlayerController controller;
  double altura = 200;
  bool clicado = false;
  bool videoExiste = true;
  String link = '';
  Paciente? _pacienteResponsavel;

  void _definirPacienteResponsavel(Paciente? novoPacienteResponsavel) =>
      setState(
        () {
          _pacienteResponsavel =
              novoPacienteResponsavel ?? _pacienteResponsavel;
        },
      );

  _testarUrl(String value) {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value) || value == '') {
      return false;
    }
    return true;
  }

  bool _testarYoutubeUrl(String link) {
    String p =
        '((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?';
    RegExp regExp = RegExp(p);
    if (!regExp.hasMatch(link) || link == '') {
      return false;
    }
    return true;
  }

  Widget _youtubeBuilder() {
    return YoutubePlayerBuilder(
        player: YoutubePlayer(controller: controller),
        builder: (context, player) => Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: player,
              ),
            ));
  }

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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  Map<String, dynamic> dadosEquipamento =
                      snapshot.data!.data()!;
                  dadosEquipamento["id"] = snapshot.data!.id;

                  Equipamento equipamento =
                      Equipamento.porMap(dadosEquipamento);
                  controller = YoutubePlayerController(
                      initialVideoId: YoutubePlayer.convertUrlToId(
                              equipamento.videoInstrucional ?? '') ??
                          '',
                      flags: const YoutubePlayerFlags(
                          autoPlay: false, loop: false, hideControls: false));
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(equipamento.nome),
                      centerTitle: true,
                      backgroundColor: Constantes.corAzulEscuroPrincipal,
                      actions: [
                        Visibility(
                          visible: [
                            PerfilUsuario.mestre,
                            PerfilUsuario.dispensacao,
                            PerfilUsuario.vigilancia
                          ].contains(model.perfil),
                          child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdicionarEquipamento(
                                              equipamentoJaCadastrado:
                                                  equipamento,
                                            )));
                              },
                              icon: Icon(Icons.edit)),
                        )
                      ],
                    ),
                    body: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Color.fromARGB(255, 194, 195, 255),
                              Colors.white
                            ],
                                stops: [
                              0,
                              0.4
                            ])),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TituloEFoto(
                                          equipamento: equipamento,
                                          semfoto: widget.controller.semimagem),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      AtributosEquipamento(
                                          equipamento: equipamento),
                                      Visibility(
                                        visible: [
                                          PerfilUsuario.mestre,
                                          PerfilUsuario.dispensacao,
                                          PerfilUsuario.vigilancia
                                        ].contains(model.perfil),
                                        child: Visibility(
                                          visible: equipamento.status ==
                                              StatusDoEquipamento.disponivel,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                const Color
                                                                        .fromRGBO(
                                                                    97,
                                                                    253,
                                                                    125,
                                                                    1),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          18.0),
                                                            )),
                                                    onPressed: () async {
                                                      if (widget
                                                              .pacientePreEscolhido ==
                                                          null) {
                                                        Paciente?
                                                            pacienteEscolhido =
                                                            await mostrarDialogEscolherPaciente(
                                                                context);
                                                        if (pacienteEscolhido !=
                                                            null) {
                                                          try {
                                                            await equipamento
                                                                .solicitarEmprestimo(
                                                                    pacienteEscolhido,
                                                                    model);
                                                          } catch (erro) {
                                                            equipamento.status =
                                                                StatusDoEquipamento
                                                                    .disponivel;
                                                            mostrarMensagemErro(
                                                                context,
                                                                erro.toString());
                                                          }
                                                          _definirPacienteResponsavel(
                                                              pacienteEscolhido);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              backgroundColor:
                                                                  Constantes
                                                                      .corAzulEscuroPrincipal,
                                                              content: Text(
                                                                  "Solicitação enviada à dispensação!"),
                                                            ),
                                                          );
                                                        }
                                                      } else {
                                                        if (await mostrarDialogConfirmacao(
                                                                context,
                                                                'Deseja mesmo alterar o status?',
                                                                'Ele será emprestado ao paciente selecionado') ==
                                                            true) {
                                                          try {
                                                            await equipamento
                                                                .solicitarEmprestimo(
                                                                    widget
                                                                        .pacientePreEscolhido!,
                                                                    model);
                                                          } catch (erro) {
                                                            equipamento.status =
                                                                StatusDoEquipamento
                                                                    .disponivel;
                                                            mostrarMensagemErro(
                                                                context,
                                                                erro.toString());
                                                          }
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              backgroundColor:
                                                                  Constantes
                                                                      .corAzulEscuroPrincipal,
                                                              content: Text(
                                                                  "Solicitação enviada à dispensação!"),
                                                            ),
                                                          );
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      }
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: const [
                                                        Text(
                                                          "Solicitar empréstimo ",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Icon(
                                                          Icons.people,
                                                          color: Colors.black,
                                                          size: 16,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: widget
                                                        .pacientePreEscolhido ==
                                                    null,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      const Color
                                                                              .fromRGBO(
                                                                          97,
                                                                          253,
                                                                          125,
                                                                          1),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18.0),
                                                                  )),
                                                          onPressed: () async {
                                                            if (await mostrarDialogConfirmacao(
                                                                    context,
                                                                    'Deseja mesmo alterar o status?',
                                                                    'Ele será alterado para Manutenção') ==
                                                                true) {
                                                              mostrarDialogCarregando(
                                                                  context);
                                                              try {
                                                                await equipamento
                                                                    .manutencao(
                                                                        model);
                                                                equipamento
                                                                        .status =
                                                                    StatusDoEquipamento
                                                                        .manutencao;
                                                              } catch (e) {
                                                                mostrarMensagemErro(
                                                                    context,
                                                                    e.toString());
                                                              }
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: const [
                                                              Text(
                                                                "Reparar ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .build_rounded,
                                                                color: Colors
                                                                    .black,
                                                                size: 16,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      const Color
                                                                              .fromRGBO(
                                                                          97,
                                                                          253,
                                                                          125,
                                                                          1),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18.0),
                                                                  )),
                                                          onPressed: () async {
                                                            if (await mostrarDialogConfirmacao(
                                                                    context,
                                                                    'Deseja mesmo alterar o status?',
                                                                    'Ele será alterado para Desinfecção') ==
                                                                true) {
                                                              mostrarDialogCarregando(
                                                                  context);
                                                              try {
                                                                await equipamento
                                                                    .desinfectar(
                                                                        model);
                                                                equipamento
                                                                        .status =
                                                                    StatusDoEquipamento
                                                                        .desinfeccao;
                                                              } catch (e) {
                                                                mostrarMensagemErro(
                                                                    context,
                                                                    e.toString());
                                                              }
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: const [
                                                              Text(
                                                                "Desinfectar ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .clean_hands_sharp,
                                                                color: Colors
                                                                    .black,
                                                                size: 16,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: SizedBox(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                const Color
                                                                        .fromRGBO(
                                                                    97,
                                                                    253,
                                                                    125,
                                                                    1),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          18.0),
                                                            )),
                                                    onPressed: () async {
                                                      if (widget
                                                              .pacientePreEscolhido ==
                                                          null) {
                                                        Paciente?
                                                            pacienteEscolhido =
                                                            await mostrarDialogEscolherPaciente(
                                                                context);
                                                        if (pacienteEscolhido !=
                                                            null) {
                                                          try {
                                                            await equipamento
                                                                .conceder(
                                                                    pacienteEscolhido,
                                                                    model);
                                                          } catch (erro) {
                                                            equipamento.status =
                                                                StatusDoEquipamento
                                                                    .disponivel;
                                                            mostrarMensagemErro(
                                                                context,
                                                                erro.toString());
                                                          }
                                                          _definirPacienteResponsavel(
                                                              pacienteEscolhido);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              backgroundColor:
                                                                  Constantes
                                                                      .corAzulEscuroPrincipal,
                                                              content: Text(
                                                                  "Equipamento concedido ao paciente selecionado!"),
                                                            ),
                                                          );
                                                        }
                                                      } else {
                                                        if (await mostrarDialogConfirmacao(
                                                                context,
                                                                'Deseja conceder?',
                                                                'Ele será concedido ao paciente selecionado') ==
                                                            true) {
                                                          try {
                                                            await equipamento
                                                                .conceder(
                                                                    widget
                                                                        .pacientePreEscolhido!,
                                                                    model);
                                                          } catch (erro) {
                                                            equipamento.status =
                                                                StatusDoEquipamento
                                                                    .disponivel;
                                                            mostrarMensagemErro(
                                                                context,
                                                                erro.toString());
                                                          }
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              backgroundColor:
                                                                  Constantes
                                                                      .corAzulEscuroPrincipal,
                                                              content: Text(
                                                                  "Equipamento concedido"),
                                                            ),
                                                          );
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      }
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          widget.pacientePreEscolhido ==
                                                                  null
                                                              ? MainAxisAlignment
                                                                  .spaceAround
                                                              : MainAxisAlignment
                                                                  .center,
                                                      mainAxisSize:
                                                          widget.pacientePreEscolhido ==
                                                                  null
                                                              ? MainAxisSize.min
                                                              : MainAxisSize
                                                                  .max,
                                                      children: const [
                                                        Text(
                                                          "Conceder ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        Icon(
                                                          Icons.assignment_ind,
                                                          color: Colors.black,
                                                          size: 16,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: equipamento.status !=
                                    StatusDoEquipamento.disponivel,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(width: 1)),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                              color: Constantes
                                                  .corAzulEscuroSecundario,
                                            ),
                                            height: 30,
                                            child: const Text(
                                              "Detalhes",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Visibility(
                                              visible: equipamento.status ==
                                                      StatusDoEquipamento
                                                          .emprestado ||
                                                  equipamento.status ==
                                                      StatusDoEquipamento
                                                          .concedido,
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
                                                                  .all(8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            8.0),
                                                                child: Text(
                                                                  "Paciente",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Constantes
                                                                        .corAzulEscuroSecundario,
                                                                  ),
                                                                ),
                                                              ),
                                                              const Divider(),
                                                              Row(
                                                                children: [
                                                                  FotoDoPacienteThumbnail(
                                                                    pacienteEmprestado
                                                                        .urlFotoDePerfil,
                                                                    statusPaciente:
                                                                        pacienteEmprestado
                                                                            .status,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.6,
                                                                    child: Text(
                                                                      pacienteEmprestado
                                                                          .nomeCompleto,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                      style: TextStyle(
                                                                          color: Theme.of(context)
                                                                              .primaryColor,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                16.0),
                                                                    child: Text(
                                                                      "Data de expedição",
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Constantes
                                                                            .corAzulEscuroSecundario,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(equipamento
                                                                      .dataDeExpedicaoEmString),
                                                                ],
                                                              ),
                                                              Visibility(
                                                                visible: [
                                                                  PerfilUsuario
                                                                      .mestre,
                                                                  PerfilUsuario
                                                                      .dispensacao,
                                                                  PerfilUsuario
                                                                      .vigilancia
                                                                ].contains(model
                                                                    .perfil),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8.0),
                                                                  child:
                                                                      SizedBox(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          backgroundColor: const Color.fromRGBO(97, 253, 125, 1),
                                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(18.0),
                                                                          )),
                                                                      onPressed:
                                                                          () async {
                                                                        if (await mostrarDialogConfirmacao(
                                                                                context,
                                                                                'Deseja mesmo disponibilizar?',
                                                                                'Ele será alterado para Disponível') ==
                                                                            true) {
                                                                          String? justificativa = await mostrarDialogJustificativa(
                                                                              context,
                                                                              'Retornar ao hospital?',
                                                                              'Qual o motivo da devolução?');
                                                                          if (justificativa !=
                                                                              null) {
                                                                            try {
                                                                              await equipamento.solicitarDevolucao(pacienteEmprestado, model, justificativa);
                                                                            } catch (e) {
                                                                              mostrarMensagemErro(context, e.toString());
                                                                            }
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(
                                                                                backgroundColor: Constantes.corAzulEscuroPrincipal,
                                                                                content: Text("Solicitação enviada à dispensação!"),
                                                                              ),
                                                                            );
                                                                          }
                                                                        }
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        equipamento.status ==
                                                                                StatusDoEquipamento.emprestado
                                                                            ? "Solicitar devolução"
                                                                            : "Voltar ao hospital",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible: [
                                                                  PerfilUsuario
                                                                      .mestre,
                                                                  PerfilUsuario
                                                                      .dispensacao,
                                                                  PerfilUsuario
                                                                      .vigilancia
                                                                ].contains(model
                                                                    .perfil),
                                                                child:
                                                                    Visibility(
                                                                  visible: equipamento
                                                                          .status ==
                                                                      StatusDoEquipamento
                                                                          .emprestado,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            8.0),
                                                                    child:
                                                                        SizedBox(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      child:
                                                                          ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: const Color.fromRGBO(97, 253, 125, 1),
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(18.0),
                                                                            )),
                                                                        onPressed:
                                                                            () async {
                                                                          if (await mostrarDialogConfirmacao(context, 'Deseja mesmo conceder?', 'Ele será concedido ao paciente atualmente emprestado') ==
                                                                              true) {
                                                                            mostrarDialogCarregando(context);
                                                                            try {
                                                                              await equipamento.conceder(pacienteEmprestado, model);
                                                                            } catch (erro) {
                                                                              mostrarMensagemErro(context, erro.toString());
                                                                            }
                                                                            Navigator.pop(context);
                                                                          }
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          "Conceder ao paciente",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(color: Colors.black),
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
                                            visible: equipamento.status ==
                                                    StatusDoEquipamento
                                                        .manutencao ||
                                                equipamento.status ==
                                                    StatusDoEquipamento
                                                        .desinfeccao,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Text(
                                                      "Enviado à ${equipamento.status.emStringMaiuscula} por",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Constantes
                                                            .corAzulEscuroSecundario,
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(),
                                                  StreamBuilder<
                                                          DocumentSnapshot<
                                                              Map<String,
                                                                  dynamic>>>(
                                                      stream: FirebaseService()
                                                          .streamInfoUsuarioPorID(
                                                              equipamento
                                                                      .alteradoPor ??
                                                                  'N/A'),
                                                      builder:
                                                          (context, snapshot) {
                                                        switch (snapshot
                                                            .connectionState) {
                                                          case ConnectionState
                                                              .none:
                                                          case ConnectionState
                                                              .waiting:
                                                            return const Center(
                                                              child:
                                                                  LinearProgressIndicator(),
                                                            );
                                                          default:
                                                            Usuario
                                                                profissionalQueModificouStatus =
                                                                Usuario.porDocumentSnapshot(
                                                                    snapshot
                                                                        .data!);
                                                            return Row(
                                                              children: [
                                                                FotoDoUsuarioThumbnail(
                                                                    profissionalQueModificouStatus
                                                                        .urlFotoDePerfil),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.6,
                                                                  child: Text(
                                                                    profissionalQueModificouStatus
                                                                        .nomeCompleto,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                        }
                                                      }),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 8.0),
                                                    child: Text(
                                                      "Data de expedição",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Constantes
                                                            .corAzulEscuroSecundario,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(equipamento
                                                      .dataDeExpedicaoEmString),
                                                  Visibility(
                                                    visible:
                                                        equipamento.status ==
                                                            StatusDoEquipamento
                                                                .desinfeccao,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      // ignore: prefer_const_literals_to_create_immutables
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 8.0),
                                                          child: Text(
                                                            "Previsão de entrega",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Constantes
                                                                  .corAzulEscuroSecundario,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(equipamento
                                                                .dataDeDevolucaoEmStringFormatada ??
                                                            'Indefinido!'),
                                                      ],
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: [
                                                      PerfilUsuario.mestre,
                                                      PerfilUsuario.dispensacao
                                                    ].contains(model.perfil),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      const Color
                                                                              .fromRGBO(
                                                                          97,
                                                                          253,
                                                                          125,
                                                                          1),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18.0),
                                                                  )),
                                                          onPressed: () async {
                                                            if (await mostrarDialogConfirmacao(
                                                                    context,
                                                                    'Deseja mesmo disponibilizar?',
                                                                    'Ele será alterado para Disponível') ==
                                                                true) {
                                                              mostrarDialogCarregando(
                                                                  context);
                                                              try {
                                                                equipamento
                                                                    .disponibilizar();
                                                                equipamento
                                                                        .status =
                                                                    StatusDoEquipamento
                                                                        .disponivel;
                                                              } catch (e) {
                                                                mostrarMensagemErro(
                                                                    context,
                                                                    e.toString());
                                                              }
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          },
                                                          child: const Text(
                                                            "Disponibilizar",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
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
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 1)),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                          ),
                                          color: Constantes
                                              .corAzulEscuroSecundario,
                                        ),
                                        height: 30,
                                        child: const Text(
                                          "Histórico de empréstimos e devoluções",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: ElevatedButton.icon(
                                            icon: const Icon(
                                              Icons.list_alt,
                                              color: Colors.black,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        97, 253, 125, 1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                )),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HistoricoEmprestimos(
                                                            equipamento:
                                                                equipamento.id,
                                                            pacientePreEscolhido:
                                                                widget
                                                                    .pacientePreEscolhido,
                                                          )));
                                            },
                                            label: const Text(
                                              "Ver lista",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 1)),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                          ),
                                          color: Constantes
                                              .corAzulEscuroSecundario,
                                        ),
                                        height: 30,
                                        child: const Text(
                                          "Manual do equipamento",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: ElevatedButton.icon(
                                            icon: const Icon(
                                              Icons.picture_as_pdf,
                                              color: Colors.black,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        97, 253, 125, 1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                )),
                                            onPressed: _testarUrl(
                                                    equipamento.manualPdf ?? '')
                                                ? () async {
                                                    mostrarDialogCarregando(
                                                        context);
                                                    try {
                                                      final url = equipamento
                                                          .manualPdf!;
                                                      final arquivo =
                                                          await PDFapi
                                                              .carregarLink(
                                                                  url);
                                                      Navigator.pop(context);
                                                      abrirPDF(
                                                          context, arquivo);
                                                    } catch (e) {
                                                      Navigator.pop(context);
                                                      mostrarMensagemErro(
                                                          context,
                                                          'Não foi possível acessar o pdf indicado. Tente alterar o link do manual.');
                                                    }
                                                  }
                                                : null,
                                            label: Text(
                                              _testarUrl(
                                                      equipamento.manualPdf ??
                                                          '')
                                                  ? "Visualizar PDF"
                                                  : "PDF indisponível",
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                  visible:
                                      equipamento.informacoesTecnicas != null,
                                  child: InformacoesAdicionais(
                                      equipamento,
                                      "Informações técnicas",
                                      equipamento.informacoesTecnicas == ''
                                          ? 'Clique em editar para adicionar informações'
                                          : equipamento.informacoesTecnicas)),
                              Visibility(
                                  visible: equipamento
                                              .higieneECuidadosPaciente !=
                                          null &&
                                      equipamento.higieneECuidadosPaciente !=
                                          '',
                                  child: InformacoesAdicionais(
                                    equipamento,
                                    "Higiene e informações ao paciente",
                                    equipamento.higieneECuidadosPaciente ??
                                        'Clique em editar para adicionar informações',
                                  )),
                              Visibility(
                                visible: _testarYoutubeUrl(
                                        equipamento.videoInstrucional ?? '') ==
                                    true,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color:
                                            Constantes.corAzulEscuroSecundario,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(width: 1)),
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                            ),
                                            color: Constantes
                                                .corAzulEscuroSecundario,
                                          ),
                                          height: 30,
                                          child: const Text(
                                            "Modo de uso",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        _youtubeBuilder()
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: [
                                  PerfilUsuario.mestre,
                                  PerfilUsuario.dispensacao,
                                  PerfilUsuario.clinico,
                                  PerfilUsuario.vigilancia
                                ].contains(model.perfil),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: AnimatedContainer(
                                    curve: Curves.easeIn,
                                    constraints: BoxConstraints(
                                        minHeight:
                                            MediaQuery.of(context).size.height *
                                                0.1),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(width: 1)),
                                    duration: const Duration(milliseconds: 240),
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                            ),
                                            color: Constantes
                                                .corAzulEscuroSecundario,
                                          ),
                                          height: 30,
                                          child: const Text(
                                            "Observações",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        equipamento.observacao != null
                                            ? Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                      equipamento.observacao ??
                                                          'Observação vazia!',
                                                      maxLines:
                                                          clicado ? null : 3,
                                                      overflow: clicado
                                                          ? null
                                                          : TextOverflow
                                                              .ellipsis,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: equipamento
                                                            .observacao!
                                                            .length >
                                                        141,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10.0),
                                                      child: ElevatedButton(
                                                        onPressed: mostrarMais,
                                                        child: Text(
                                                          clicado
                                                              ? 'Mostrar menos'
                                                              : 'Mostrar mais',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    const Color
                                                                            .fromRGBO(
                                                                        97,
                                                                        253,
                                                                        125,
                                                                        1),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18.0),
                                                                )),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    const Color
                                                                            .fromRGBO(
                                                                        97,
                                                                        253,
                                                                        125,
                                                                        1),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18.0),
                                                                )),
                                                        onPressed: () {
                                                          adicionarObservacao(
                                                              context,
                                                              equipamento);
                                                          setState(() {});
                                                        },
                                                        child: const Icon(
                                                          Icons.add,
                                                          color: Colors.black,
                                                        ))),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  );
              }
            });
      },
    );
  }

  void abrirPDF(BuildContext context, File arquivo) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => TelaPDF(arquivo: arquivo)));

  void mostrarMais() {
    setState(() {
      clicado = !clicado;
      clicado == true
          ? altura = MediaQuery.of(context).size.height * 0.5
          : altura = MediaQuery.of(context).size.height * 0.2;
    });
  }
}
