import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/solicitacao.dart';
import 'package:sono/utils/services/firebase.dart';
import '../../../../constants/constants.dart';
import '../../../../pdf/pdf_api.dart';
import '../../../../pdf/tela_pdf.dart';
import '../../../../utils/models/paciente.dart';
import '../../../../utils/models/user_model.dart';

class PainelHistorico extends StatefulWidget {
  final String idSolicitacao;
  const PainelHistorico({Key? key, required this.idSolicitacao})
      : super(key: key);

  @override
  State<PainelHistorico> createState() => _PainelHistoricoState();
}

class _PainelHistoricoState extends State<PainelHistorico> {
  @override
  Widget build(BuildContext context) {
    late Paciente pacienteSolicitado;
    late Equipamento equipamentoSolicitado;
    return ScopedModelDescendant<UserModel>(
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
                      "${solicitacao.tipo.emString}\n${solicitacao.dataDaSolicitacaoEmString}",
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
                              'Clínico solicitante',
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
                            child: Text(solicitacao.idSolicitante),
                          ),
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
                                      title:
                                          Text(pacienteSolicitado.nomeCompleto),
                                      subtitle: Text(
                                          "CPF: ${pacienteSolicitado.cpf ?? 'Não informado!'}"),
                                      leading: Image.network(
                                        pacienteSolicitado.urlFotoDePerfil ??
                                            model.semimagem,
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    );
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
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: equipamentoSolicitado
                                                      .tamanho ==
                                                  null
                                              ? Text(equipamentoSolicitado.nome)
                                              : Text(
                                                  "${equipamentoSolicitado.nome}\n(Tamanho:${equipamentoSolicitado.tamanho})"),
                                          subtitle: Text(equipamentoSolicitado
                                              .tipo.emString),
                                          leading: Image.network(
                                            equipamentoSolicitado
                                                    .urlFotoDePerfil ??
                                                model.semimagem,
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                          child: ElevatedButton.icon(
                                              icon: const Icon(
                                                Icons.list_alt,
                                                color: Colors.black,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromRGBO(97, 253, 125, 1),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(18.0),
                                                  )),
                                              onPressed: solicitacao.urlPdf != null
                                                  ? () async {
                                                      final url = solicitacao.urlPdf;
                                                      final arquivo =
                                                          await PDFapi.gerarPdfSolicitacao(
                                                              url!, solicitacao.tipo, equipamentoSolicitado);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  TelaPDF(arquivo: arquivo)));
                                                    }
                                                  : null,
                                              label: Text(
                                                solicitacao.tipo == TipoSolicitacao.emprestimo
                                                    ? equipamentoSolicitado.tipo.emStringSnakeCase.contains('mascara')||equipamentoSolicitado.tipo.emStringSnakeCase.contains('ap')?
                                                    "Ver termo de responsabilidade":"Ver recibo"
                                                    : "Ver documento de devolução",
                                                style: TextStyle(color: Colors.black),
                                              )),
                                        ),
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
              return const Center(
                child: CircularProgressIndicator(
                  color: Constantes.corAzulEscuroPrincipal,
                ),
              );
            }
          }),
    );
  }
}
