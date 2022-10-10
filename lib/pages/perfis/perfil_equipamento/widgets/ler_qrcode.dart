import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:sono/pages/perfis/perfil_equipamento/equipamento_controller.dart';
import 'package:sono/pages/perfis/perfil_equipamento/tela_equipamento.dart';
import 'package:sono/pages/perfis/perfil_paciente/terapia_com_pap/widgets/item_equipamento.dart';

import '../../../../constants/constants.dart';
import '../../../../utils/models/equipamento.dart';
import '../../../../utils/models/paciente.dart';
import '../../../../utils/services/firebase.dart';

class LerQrCode extends StatefulWidget {
  final Paciente pacientePreEscolhido;
  final ControllerPerfilClinicoEquipamento controller;
  const LerQrCode(
      {required this.controller, required this.pacientePreEscolhido, Key? key})
      : super(key: key);

  @override
  State<LerQrCode> createState() => _LerQrCodeState();
}

class _LerQrCodeState extends State<LerQrCode> {
  String ticket = '';
  Equipamento? equipamento;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(255, 183, 189, 246), Colors.white],
                stops: [0, 0.4])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ticket != ''
                ? Column(
                    children: [
                      equipamento != null
                          ? Column(
                              children: [
                                equipamento!.status ==
                                        StatusDoEquipamento.disponivel
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(width: 1)),
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    topRight:
                                                        Radius.circular(8),
                                                  ),
                                                  color: Constantes
                                                      .corAzulEscuroPrincipal,
                                                ),
                                                height: 30,
                                                child: const Text(
                                                  'Equipamento identificado',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                child: Text(
                                                    '${equipamento!.nome}'),
                                              ),
                                              FotoDoEquipamento(
                                                  equipamento!.urlFotoDePerfil),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15.0),
                                                child: Text(
                                                    'Deseja ser direcionado para a tela do equipamento?'),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8.0),
                                                      child:
                                                          ElevatedButton.icon(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        255,
                                                                        112,
                                                                        122),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18.0),
                                                                )),
                                                        onPressed: () {
                                                          setState(() {
                                                            ticket = '';
                                                          });
                                                        },
                                                        icon: const Icon(
                                                          Icons.close,
                                                          color: Colors.black,
                                                        ),
                                                        label: const Text(
                                                          'Cancelar',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    ElevatedButton.icon(
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
                                                        if (equipamento !=
                                                            null) {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  TelaEquipamento(
                                                                id: equipamento!
                                                                    .id,
                                                                controller: widget
                                                                    .controller,
                                                                pacientePreEscolhido:
                                                                    widget
                                                                        .pacientePreEscolhido,
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                            content: Text(
                                                              'Equipamento não encontrado',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            backgroundColor:
                                                                Constantes
                                                                    .corAzulEscuroSecundario,
                                                          ));
                                                        }
                                                        setState(() {});
                                                      },
                                                      icon: const Icon(
                                                        Icons.check,
                                                        color: Colors.black,
                                                      ),
                                                      label: const Text(
                                                        'Confirmar',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(width: 1)),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 30,
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    topRight:
                                                        Radius.circular(8),
                                                  ),
                                                  color: Constantes
                                                      .corAzulEscuroPrincipal,
                                                ),
                                                child: const Text(
                                                  'Aviso',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Text(
                                                    '${equipamento!.nome} não está disponível, tente outro equipamento!',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 21),
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.sentiment_dissatisfied,
                                                  size: 50,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Constantes
                                                                  .corAzulEscuroPrincipal,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18.0),
                                                          )),
                                                  onPressed: () {
                                                    setState(() {
                                                      ticket = '';
                                                    });
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Text(
                                                      'Tente Novamente',
                                                      style: TextStyle(
                                                          fontSize: 21,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ],
                            )
                          : Column(
                              children: [
                                const Text(
                                  'Equipamento não encontrado',
                                  style: TextStyle(fontSize: 21),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.sentiment_dissatisfied,
                                    size: 50,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Constantes.corAzulEscuroPrincipal,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        )),
                                    onPressed: () {
                                      setState(() {
                                        ticket = '';
                                      });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        'Tente Novamente',
                                        style: TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  )
                : Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 31.0),
                        child: Icon(
                          Icons.qr_code_scanner,
                          size: 150,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Constantes.corAzulEscuroPrincipal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                        onPressed: lerQRCode,
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Validar equipamento',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void lerQRCode() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF",
      "Cancelar",
      false,
      ScanMode.QR,
    );
    ticket = code != '-1' ? code : 'Não validado';
    equipamento = await FirebaseService().obterEquipamentoPorID(ticket);
    setState(() {});
  }
}
