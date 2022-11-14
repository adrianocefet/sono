import 'package:flutter/material.dart';
import 'package:sono/pages/tabelas/lista_de_pacientes.dart';
import 'package:sono/utils/dialogs/carregando.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/solicitacao.dart';
import '../../../../constants/constants.dart';
import '../../../../utils/dialogs/confirmar.dart';
import '../../../../utils/dialogs/error_message.dart';
import '../../../../utils/models/paciente.dart';
import '../../../../utils/models/usuario.dart';

class BotoesEquipamento extends StatefulWidget {
  final Equipamento equipamento;
  final Usuario model;
  final Paciente? pacientePreEscolhido;
  final BuildContext contextoScaffold;
  const BotoesEquipamento(
      {Key? key,
      required this.equipamento,
      required this.model,
      required this.pacientePreEscolhido,
      required this.contextoScaffold})
      : super(key: key);

  @override
  State<BotoesEquipamento> createState() => _BotoesEquipamentoState();
}

class _BotoesEquipamentoState extends State<BotoesEquipamento> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SizedBox(
            width: mediaQuery.size.width,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(97, 253, 125, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )),
              onPressed: () async {
                if (widget.pacientePreEscolhido == null) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ListaDePacientes(
                      equipamentoPreEscolhido: widget.equipamento,
                      tipoSolicitacao: TipoSolicitacao.emprestimo,
                    );
                  }));
                } else {
                  if (await mostrarDialogConfirmacao(
                          context,
                          'Deseja mesmo alterar o status?',
                          'Ele será emprestado ao paciente selecionado') ==
                      true) {
                    mostrarDialogCarregando(widget.contextoScaffold);
                    try {
                      await widget.equipamento.solicitarEmprestimo(
                          widget.pacientePreEscolhido!, widget.model);
                    } catch (erro) {
                      widget.equipamento.status =
                          StatusDoEquipamento.disponivel;
                      mostrarMensagemErro(context, erro.toString());
                    }
                    Navigator.pop(widget.contextoScaffold);
                    ScaffoldMessenger.of(widget.contextoScaffold).showSnackBar(
                      const SnackBar(
                        backgroundColor: Constantes.corAzulEscuroPrincipal,
                        content: Text("Solicitação enviada à dispensação!"),
                      ),
                    );
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "Solicitar empréstimo ",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
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
          visible: widget.pacientePreEscolhido == null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  width: mediaQuery.size.width * 0.4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(97, 253, 125, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                    onPressed: () async {
                      if (await mostrarDialogConfirmacao(
                              context,
                              'Deseja mesmo alterar o status?',
                              'Ele será alterado para Manutenção') ==
                          true) {
                        mostrarDialogCarregando(widget.contextoScaffold);
                        try {
                          await widget.equipamento.manutencao(widget.model);
                          Navigator.pop(widget.contextoScaffold);
                        } catch (e) {
                          mostrarMensagemErro(context, e.toString());
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "Reparar ",
                          style: TextStyle(color: Colors.black),
                        ),
                        Icon(
                          Icons.build_rounded,
                          color: Colors.black,
                          size: 16,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  width: mediaQuery.size.width * 0.4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(97, 253, 125, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                    onPressed: () async {
                      if (await mostrarDialogConfirmacao(
                              context,
                              'Deseja mesmo alterar o status?',
                              'Ele será alterado para Desinfecção') ==
                          true) {
                        mostrarDialogCarregando(widget.contextoScaffold);
                        try {
                          await widget.equipamento.desinfectar(widget.model);
                          Navigator.pop(widget.contextoScaffold);
                        } catch (e) {
                          mostrarMensagemErro(context, e.toString());
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "Desinfectar ",
                          style: TextStyle(color: Colors.black),
                        ),
                        Icon(
                          Icons.clean_hands_sharp,
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
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SizedBox(
            width: widget.pacientePreEscolhido == null
                ? mediaQuery.size.width * (1 / 3)
                : null,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(97, 253, 125, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )),
              onPressed: () async {
                if (widget.pacientePreEscolhido == null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => ListaDePacientes(
                          equipamentoPreEscolhido: widget.equipamento,
                          tipoSolicitacao: TipoSolicitacao.concessao))));
                } else {
                  if (await mostrarDialogConfirmacao(
                          context,
                          'Deseja conceder?',
                          'Ele será concedido ao paciente selecionado') ==
                      true) {
                    mostrarDialogCarregando(widget.contextoScaffold);
                    try {
                      await widget.equipamento
                          .conceder(widget.pacientePreEscolhido!, widget.model);
                    } catch (erro) {
                      widget.equipamento.status =
                          StatusDoEquipamento.disponivel;
                      mostrarMensagemErro(context, erro.toString());
                    }
                    Navigator.pop(widget.contextoScaffold);
                    ScaffoldMessenger.of(widget.contextoScaffold).showSnackBar(
                      const SnackBar(
                        backgroundColor: Constantes.corAzulEscuroPrincipal,
                        content: Text("Equipamento concedido"),
                      ),
                    );
                    Navigator.pop(widget.contextoScaffold);
                    Navigator.pop(widget.contextoScaffold);
                    Navigator.pop(widget.contextoScaffold);
                  }
                }
              },
              child: Row(
                mainAxisAlignment: widget.pacientePreEscolhido == null
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.center,
                mainAxisSize: widget.pacientePreEscolhido == null
                    ? MainAxisSize.min
                    : MainAxisSize.max,
                children: const [
                  Text(
                    "Conceder ",
                    style: TextStyle(color: Colors.black),
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
    );
  }
}
