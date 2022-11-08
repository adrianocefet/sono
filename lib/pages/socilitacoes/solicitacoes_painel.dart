import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/perfis/perfil_equipamento/equipamento_controller.dart';
import 'package:sono/utils/dialogs/justificativa.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/solicitacao.dart';
import 'package:sono/utils/services/firebase.dart';
import '../../constants/constants.dart';
import '../../utils/dialogs/carregando.dart';
import '../../utils/dialogs/confirmar.dart';
import '../../utils/dialogs/error_message.dart';
import '../../utils/dialogs/integridade_equipamento.dart';
import '../../utils/models/paciente.dart';
import '../../utils/models/usuario.dart';
import '../tabelas/widgets/item_usuario.dart';
import 'dialog/negar_solicitacao.dart';

class SolicitacoesPainel extends StatefulWidget {
  final String idSolicitacao;
  final ControllerPerfilClinicoEquipamento controller =
      ControllerPerfilClinicoEquipamento();
  SolicitacoesPainel({Key? key, required this.idSolicitacao}) : super(key: key);

  @override
  State<SolicitacoesPainel> createState() => _SolicitacoesPainelState();
}

class _SolicitacoesPainelState extends State<SolicitacoesPainel> {
  @override
  Widget build(BuildContext context) {
    late Paciente pacienteSolicitado;
    late Equipamento equipamentoSolicitado;
    final GlobalKey _key = GlobalKey();

    return ScopedModelDescendant<Usuario>(
      builder: (context, child, model) => StreamBuilder<
              DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseService.streamSolicitacao(widget.idSolicitacao),
          builder: (context, snapshot) {
            final Color corStatus;
            if (snapshot.hasData) {
              Solicitacao solicitacao =
                  Solicitacao.porDocumentSnapshot(snapshot.data!);
              switch (solicitacao.confirmacao) {
                case Confirmacao.pendente:
                  corStatus = Constantes.dom6Color;
                  break;
                case Confirmacao.confirmado:
                  corStatus = Constantes.dom51Color;
                  break;
                case Confirmacao.negado:
                  corStatus = Constantes.dom2Color;
                  break;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: Constantes.corAzulEscuroPrincipal),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.white),
                  child: ExpansionTile(
                    key: _key,
                    childrenPadding: const EdgeInsets.all(10),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.topLeft,
                    textColor: Constantes.corAzulEscuroPrincipal,
                    collapsedTextColor: Colors.black,
                    iconColor: Constantes.corAzulEscuroPrincipal,
                    collapsedIconColor: corStatus,
                    leading: const Icon(Icons.people),
                    title: Text(
                      "${solicitacao.tipo.emString}\n${solicitacao.dataDaSolicitacaoEmString}",
                      style: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                    subtitle: Text(
                      solicitacao.confirmacao.emString,
                      style: TextStyle(
                          color: corStatus, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Visibility(
                          visible:
                              solicitacao.confirmacao == Confirmacao.negado,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 15),
                                child: Text(
                                  'Motivo da negação',
                                  style: TextStyle(
                                      color: corStatus,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Divider(
                                color: corStatus,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Text(solicitacao.motivoNegacao ??
                                    'Sem motivo definido!'),
                              ),
                            ],
                          )),
                      Visibility(
                          visible:
                              solicitacao.confirmacao != Confirmacao.pendente,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 15),
                                child: Text(
                                  'Data de resposta',
                                  style: TextStyle(
                                      color: corStatus,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Divider(
                                color: corStatus,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Text(solicitacao.dataDeRespostaEmString),
                              ),
                            ],
                          )),
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
                              stream: FirebaseService().streamInfoUsuarioPorID(
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
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    );
                                }
                              })),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 15),
                        child: Text(
                          'Data da solicitação',
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
                        child: Text(solicitacao.dataDaSolicitacaoEmString),
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
                              child: Text(solicitacao.justificativaDevolucao ??
                                  'Sem justificativa!'),
                            ),
                          ],
                        ),
                      ),
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
                                      title: equipamentoSolicitado.tamanho ==
                                              null
                                          ? Text(equipamentoSolicitado.nome)
                                          : Text(
                                              "${equipamentoSolicitado.nome}\n${equipamentoSolicitado.tamanho}"),
                                      subtitle: Text(
                                          equipamentoSolicitado.tipo.emString),
                                      leading: Image.network(
                                        equipamentoSolicitado.urlFotoDePerfil ??
                                            widget.controller.semimagem,
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                );
                            }
                          }),
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
                          stream: FirebaseService()
                              .streamInfoPacientePorID(solicitacao.idPaciente),
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
                                  title: Text(pacienteSolicitado.nomeCompleto),
                                  subtitle: Text(
                                      "CPF: ${pacienteSolicitado.cpf ?? 'Não informado'}"),
                                  leading: Image.network(
                                    pacienteSolicitado.urlFotoDePerfil ??
                                        widget.controller.semimagemPaciente,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                );
                            }
                          }),
                      Visibility(
                        visible:
                            solicitacao.confirmacao == Confirmacao.pendente,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                onPressed: () {
                                  negarSolicitacao(context, solicitacao);
                                },
                                child: const Text(
                                  'Negar ',
                                  style: TextStyle(
                                      color: Constantes.corAzulEscuroPrincipal),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (solicitacao.tipo ==
                                      TipoSolicitacao.emprestimo) {
                                    if (equipamentoSolicitado.status ==
                                        StatusDoEquipamento.disponivel) {
                                      if (await mostrarDialogConfirmacao(
                                              context,
                                              'Confirmar empréstimo?',
                                              'O equipamento se tornará emprestado') ==
                                          true) {
                                        mostrarDialogCarregando(context);
                                        try {
                                          await equipamentoSolicitado
                                              .emprestarPara(
                                                  pacienteSolicitado);
                                          solicitacao.infoMap['confirmacao'] =
                                              'confirmado';
                                          solicitacao
                                                  .infoMap['data_de_resposta'] =
                                              FieldValue.serverTimestamp();
                                          FirebaseService.atualizarSolicitacao(
                                              solicitacao);
                                        } catch (erro) {
                                          equipamentoSolicitado.status =
                                              StatusDoEquipamento.disponivel;
                                          mostrarMensagemErro(
                                              context, erro.toString());
                                        }
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Constantes
                                                .corAzulEscuroPrincipal,
                                            content: Text(
                                                "Solicitação aceita com sucesso!"),
                                          ),
                                        );
                                        await solicitacao.gerarTermoEmprestimo(
                                            pacienteSolicitado,
                                            equipamentoSolicitado,
                                            model);
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor:
                                              Constantes.corAzulEscuroPrincipal,
                                          content: Text(
                                              "Esse equipamento não está disponível!"),
                                        ),
                                      );
                                    }
                                  } else {
                                    if (equipamentoSolicitado.status ==
                                            StatusDoEquipamento.emprestado ||
                                        equipamentoSolicitado.status ==
                                            StatusDoEquipamento.concedido) {
                                      if (await mostrarDialogConfirmacao(
                                              context,
                                              'Confirmar devolução?',
                                              'O equipamento se tornará disponível') ==
                                          true) {
                                        String? integridadeDoEquipamento =
                                            await mostrarDialogIntegridade(
                                                context,
                                                'Integridade do equipamento',
                                                'Qual o estado do equipamento devolvido?');

                                        if (integridadeDoEquipamento != null) {
                                          mostrarDialogCarregando(context);
                                          try {
                                            await equipamentoSolicitado
                                                .devolver();
                                            solicitacao.infoMap['confirmacao'] =
                                                'confirmado';
                                            solicitacao.infoMap[
                                                    'data_de_resposta'] =
                                                FieldValue.serverTimestamp();
                                            FirebaseService
                                                .atualizarSolicitacao(
                                                    solicitacao);
                                          } catch (erro) {
                                            equipamentoSolicitado.status =
                                                StatusDoEquipamento.emprestado;
                                            mostrarMensagemErro(
                                                context, erro.toString());
                                          }
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Constantes
                                                  .corAzulEscuroPrincipal,
                                              content: Text(
                                                  "Solicitação aceita com sucesso!"),
                                            ),
                                          );
                                          await solicitacao.gerarTermoDevolucao(
                                              integridadeDoEquipamento,
                                              pacienteSolicitado,
                                              equipamentoSolicitado,
                                              model);
                                        }
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor:
                                              Constantes.corAzulEscuroPrincipal,
                                          content: Text(
                                              "Esse equipamento não está mais emprestado!"),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  solicitacao.tipo == TipoSolicitacao.emprestimo
                                      ? 'Emprestar '
                                      : 'Devolver ',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Constantes.corAzulEscuroPrincipal,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    )),
                              ),
                            ],
                          ),
                        ),
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
                  height: MediaQuery.of(context).size.height * 0.1,
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
