import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/perfis/perfil_equipamento/adicionar_equipamento.dart';
import 'package:sono/pages/perfis/perfil_equipamento/equipamento_controller.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/botoes_equipamento.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/detalhes.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/informacoes_adicionais.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/atributos_equipamento.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/observacao.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/titulo_e_foto.dart';
import 'package:sono/pages/tabelas/tab_historico_emprestimos.dart';
import 'package:sono/utils/dialogs/error_message.dart';
import 'package:sono/utils/models/paciente.dart';
import '../../../../utils/models/equipamento.dart';
import 'package:sono/pdf/pdf_api.dart';
import 'package:sono/utils/models/usuario.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../pdf/tela_pdf.dart';
import '../../../utils/dialogs/carregando.dart';
import '../../../utils/services/firebase.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late YoutubePlayerController controller;
  bool videoExiste = true;
  String link = '';

  _testarUrl(String value) {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value) || value == '') {
      return false;
    }
    return true;
  }

  Widget _youtubeBuilder(Equipamento equipamento) {
    controller = YoutubePlayerController(
        initialVideoId:
            YoutubePlayer.convertUrlToId(equipamento.videoInstrucional ?? '') ??
                '',
        flags: const YoutubePlayerFlags(
            autoPlay: false, loop: false, hideControls: false));
    if (controller.initialVideoId != '') {
      try {
        return YoutubePlayerBuilder(
            player: YoutubePlayer(controller: controller),
            builder: (context, player) => Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: player,
                  ),
                ));
      } catch (e) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Erro na reprodução do vídeo $e'),
        );
      }
    }
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text('Não foi possível encontrar o link especificado!'),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
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
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Constantes.corAzulEscuroPrincipal,
                      centerTitle: true,
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
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Constantes.corAzulEscuroPrincipal,
                        ),
                      ),
                    ),
                  );
                default:
                  Map<String, dynamic> dadosEquipamento =
                      snapshot.data!.data()!;
                  dadosEquipamento["id"] = snapshot.data!.id;

                  Equipamento equipamento =
                      Equipamento.porMap(dadosEquipamento);

                  return Scaffold(
                    key: _scaffoldKey,
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
                              icon: const Icon(Icons.edit)),
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
                        child: ListView(
                          padding: const EdgeInsets.all(8.0),
                          children: [
                            Container(
                              width: mediaQuery.size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        child: BotoesEquipamento(
                                          equipamento: equipamento,
                                          model: model,
                                          pacientePreEscolhido:
                                              widget.pacientePreEscolhido,
                                          contextoScaffold: context,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                                visible: equipamento.status !=
                                    StatusDoEquipamento.disponivel,
                                child: Detalhes(
                                    model: model,
                                    equipamento: equipamento,
                                    contextoScaffold: context)),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                width: mediaQuery.size.width,
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
                                        color:
                                            Constantes.corAzulEscuroSecundario,
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
                                                    BorderRadius.circular(18.0),
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
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: (equipamento.manualPdf ?? '') != '',
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  width: mediaQuery.size.width,
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
                                                      arquivo == null
                                                          ? mostrarMensagemErro(
                                                              context,
                                                              'Não foi possível encontrar o pdf indicado.')
                                                          : abrirPDF(
                                                              context, arquivo);
                                                    } catch (e) {
                                                      Navigator.pop(context);
                                                      mostrarMensagemErro(
                                                          context,
                                                          'Erro ao abrir o link');
                                                    }
                                                  }
                                                : null,
                                            label: Text(
                                              _testarUrl(
                                                      equipamento.manualPdf ??
                                                          '')
                                                  ? "Visualizar PDF"
                                                  : "PDF não encontrado",
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            )),
                                      ),
                                    ],
                                  ),
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
                                visible: equipamento.higieneECuidadosPaciente !=
                                        null &&
                                    equipamento.higieneECuidadosPaciente != '',
                                child: InformacoesAdicionais(
                                  equipamento,
                                  "Higiene e informações ao paciente",
                                  equipamento.higieneECuidadosPaciente ??
                                      'Clique em editar para adicionar informações',
                                )),
                            Visibility(
                              visible:
                                  (equipamento.videoInstrucional ?? '') != '',
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  width: mediaQuery.size.width,
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
                                          "Modo de uso",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      _youtubeBuilder(equipamento)
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
                              child: Observacao(equipamento),
                            ),
                          ],
                        )),
                  );
              }
            });
      },
    );
  }

  void abrirPDF(BuildContext context, File arquivo) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => TelaPDF(arquivo: arquivo)));
}
