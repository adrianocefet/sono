import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/perfis/perfil_equipamento/equipamento_controller.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/solicitacao.dart';
import 'package:sono/utils/services/firebase.dart';
import '../../../../constants/constants.dart';
import '../../../../pdf/pdf_api.dart';
import '../../../../pdf/tela_pdf.dart';
import '../../../../utils/dialogs/carregando.dart';
import '../../../../utils/dialogs/error_message.dart';
import '../../../../utils/dialogs/mostrar_foto_completa.dart';
import '../../../../utils/models/paciente.dart';
import '../../../../utils/models/usuario.dart';
import '../../../controle_estoque/widgets/foto_equipamento.dart';
import '../../../tabelas/widgets/item_paciente.dart';
import '../../../tabelas/widgets/item_usuario.dart';

class PainelHistorico extends StatefulWidget {
  final String idSolicitacao;
  const PainelHistorico({Key? key, required this.idSolicitacao})
      : super(key: key);

  @override
  State<PainelHistorico> createState() => _PainelHistoricoState();
}

class _PainelHistoricoState extends State<PainelHistorico> {
  final ControllerPerfilClinicoEquipamento controller =
      ControllerPerfilClinicoEquipamento();
  @override
  Widget build(BuildContext context) {
    late Paciente pacienteSolicitado;
    late Equipamento equipamentoSolicitado;
    return ScopedModelDescendant<Usuario>(
      builder: (context, child, model) => StreamBuilder<
              DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseService.streamSolicitacao(widget.idSolicitacao),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Solicitacao solicitacao =
                  Solicitacao.porDocumentSnapshot(snapshot.data!);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: Constantes.corAzulEscuroPrincipal),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.white),
                  child: ExpansionTile(
                    childrenPadding: const EdgeInsets.all(10),
                    expandedCrossAxisAlignment: CrossAxisAlignment.center,
                    expandedAlignment: Alignment.topLeft,
                    textColor: Constantes.corAzulEscuroPrincipal,
                    collapsedTextColor: Colors.black,
                    iconColor: Constantes.corAzulEscuroPrincipal,
                    collapsedIconColor: Constantes.corAzulEscuroPrincipal,
                    leading: const Icon(Icons.people),
                    title: Text(
                      "${solicitacao.tipo.emString}\n${solicitacao.dataDeRespostaEmString}",
                      style: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0, left: 15),
                            child: Text(
                              'Data de expedição',
                              style: TextStyle(
                                  color: Constantes.corAzulEscuroPrincipal,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Divider(
                            color: Constantes.corAzulEscuroPrincipal,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Text(solicitacao.dataDeRespostaEmString),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0, left: 15),
                            child: Text(
                              'Solicitante',
                              style: TextStyle(
                                  color: Constantes.corAzulEscuroPrincipal,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Divider(
                            color: Constantes.corAzulEscuroPrincipal,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 8, left: 15),
                              child: StreamBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                  stream: FirebaseService()
                                      .streamInfoUsuarioPorID(
                                          solicitacao.idSolicitante),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                      case ConnectionState.waiting:
                                        return const Center(
                                          child: LinearProgressIndicator(),
                                        );
                                      default:
                                        Usuario profissionalSolicitante =
                                            Usuario.porDocumentSnapshot(
                                                snapshot.data!);
                                        return Row(
                                          children: [
                                            FotoDoUsuarioThumbnail(
                                                profissionalSolicitante
                                                    .urlFotoDePerfil),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: Text(
                                                profissionalSolicitante
                                                    .nomeCompleto,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        );
                                    }
                                  })),
                          Visibility(
                            visible: solicitacao.justificativaDevolucao != null,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 8.0, left: 15),
                                  child: Text(
                                    'Justificativa da devolução',
                                    style: TextStyle(
                                        color:
                                            Constantes.corAzulEscuroPrincipal,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Divider(
                                  color: Constantes.corAzulEscuroPrincipal,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  child: Text(
                                      solicitacao.justificativaDevolucao ??
                                          'Sem justificativa!'),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0, left: 15),
                            child: Text(
                              'Paciente',
                              style: TextStyle(
                                  color: Constantes.corAzulEscuroPrincipal,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Divider(
                            color: Constantes.corAzulEscuroPrincipal,
                          ),
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              stream: FirebaseService().streamInfoPacientePorID(
                                  solicitacao.idPaciente),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  default:
                                    pacienteSolicitado =
                                        Paciente.porDocumentSnapshot(
                                            snapshot.data!);
                                    return ListTile(
                                        title: Text(
                                            pacienteSolicitado.nomeCompleto),
                                        subtitle: Text(
                                            "CPF: ${pacienteSolicitado.cpf ?? 'Não informado!'}"),
                                        leading: FotoDoPacienteThumbnail(
                                            pacienteSolicitado.urlFotoDePerfil,
                                            statusPaciente:
                                                pacienteSolicitado.status));
                                }
                              }),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0, left: 15),
                            child: Text(
                              'Equipamento',
                              style: TextStyle(
                                  color: Constantes.corAzulEscuroPrincipal,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Divider(
                            color: Constantes.corAzulEscuroPrincipal,
                          ),
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              stream: FirebaseService.streamEquipamento(
                                  solicitacao.idEquipamento),
                              builder: (context, snapshot) {
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
                                    equipamentoSolicitado =
                                        Equipamento.porMap(dadosEquipamento);
                                    if (solicitacao.urlPdf == null) {
                                      solicitacao.gerarTermoEmprestimo(
                                          pacienteSolicitado,
                                          equipamentoSolicitado,
                                          model);
                                    }
                                    return Column(
                                      children: [
                                        ListTile(
                                            title: equipamentoSolicitado
                                                        .tamanho ==
                                                    null
                                                ? Text(
                                                    equipamentoSolicitado.nome)
                                                : Text(
                                                    "${equipamentoSolicitado.nome}\n${equipamentoSolicitado.tamanho}"),
                                            subtitle: Text(equipamentoSolicitado
                                                .tipo.emString),
                                            leading: GestureDetector(
                                              onTap: () => mostrarFotoCompleta(
                                                  context,
                                                  equipamentoSolicitado
                                                      .urlFotoDePerfil,
                                                  controller.semimagem),
                                              child: FotoEquipamento(
                                                  equipamento:
                                                      equipamentoSolicitado,
                                                  semimagem:
                                                      controller.semimagem),
                                            )),
                                        solicitacao.urlPdf != null
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: ElevatedButton.icon(
                                                    icon: const Icon(
                                                      Icons.list_alt,
                                                      color: Colors.black,
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
                                                    onPressed:
                                                        solicitacao.urlPdf !=
                                                                null
                                                            ? () async {
                                                                mostrarDialogCarregando(
                                                                    context);
                                                                final url =
                                                                    solicitacao
                                                                        .urlPdf;
                                                                final arquivo =
                                                                    await PDFapi.gerarPdfSolicitacao(
                                                                        url!,
                                                                        solicitacao
                                                                            .tipo,
                                                                        equipamentoSolicitado);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                TelaPDF(arquivo: arquivo)));
                                                              }
                                                            : null,
                                                    label: Text(
                                                      solicitacao.tipo !=
                                                              TipoSolicitacao
                                                                  .devolucao
                                                          ? equipamentoSolicitado
                                                                      .tipo
                                                                      .emStringSnakeCase
                                                                      .contains(
                                                                          'mascara') ||
                                                                  equipamentoSolicitado
                                                                      .tipo
                                                                      .emStringSnakeCase
                                                                      .contains(
                                                                          'ap')
                                                              ? "Ver termo de responsabilidade"
                                                              : "Ver recibo"
                                                          : "Ver documento de devolução",
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    )),
                                              )
                                            : const LinearProgressIndicator(
                                                color: Constantes
                                                    .corAzulEscuroPrincipal,
                                              )
                                      ],
                                    );
                                }
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('ERRO!'),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: Constantes.corAzulEscuroPrincipal),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.white),
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Constantes.corAzulEscuroPrincipal,
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
