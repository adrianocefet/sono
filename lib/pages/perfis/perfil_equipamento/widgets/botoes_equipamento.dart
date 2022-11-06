import 'package:flutter/material.dart';
import 'package:sono/utils/models/equipamento.dart';
import '../../../../constants/constants.dart';
import '../../../../utils/dialogs/confirmar.dart';
import '../../../../utils/dialogs/error_message.dart';
import '../../../../utils/dialogs/escolher_paciente_dialog.dart';
import '../../../../utils/models/paciente.dart';
import '../../../../utils/models/usuario.dart';

class BotoesEquipamento extends StatelessWidget {
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
                if (pacientePreEscolhido == null) {
                  Paciente? pacienteEscolhido =
                      await mostrarDialogEscolherPaciente(context);
                  if (pacienteEscolhido != null) {
                    try {
                      await equipamento.solicitarEmprestimo(
                          pacienteEscolhido, model);
                    } catch (erro) {
                      equipamento.status = StatusDoEquipamento.disponivel;
                      mostrarMensagemErro(context, erro.toString());
                    }
                    ScaffoldMessenger.of(contextoScaffold).showSnackBar(
                      const SnackBar(
                        backgroundColor: Constantes.corAzulEscuroPrincipal,
                        content: Text("Solicitação enviada à dispensação!"),
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
                      await equipamento.solicitarEmprestimo(
                          pacientePreEscolhido!, model);
                    } catch (erro) {
                      equipamento.status = StatusDoEquipamento.disponivel;
                      mostrarMensagemErro(context, erro.toString());
                    }
                    ScaffoldMessenger.of(contextoScaffold).showSnackBar(
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
          visible: pacientePreEscolhido == null,
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
                        try {
                          await equipamento.manutencao(model);
                          equipamento.status = StatusDoEquipamento.manutencao;
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
                        try {
                          await equipamento.desinfectar(model);
                          equipamento.status = StatusDoEquipamento.desinfeccao;
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
            width: mediaQuery.size.width * (1 / 3),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(97, 253, 125, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )),
              onPressed: () async {
                if (pacientePreEscolhido == null) {
                  Paciente? pacienteEscolhido =
                      await mostrarDialogEscolherPaciente(context);
                  if (pacienteEscolhido != null) {
                    try {
                      await equipamento.conceder(pacienteEscolhido, model);
                    } catch (erro) {
                      equipamento.status = StatusDoEquipamento.disponivel;
                      mostrarMensagemErro(contextoScaffold, erro.toString());
                    }
                    ScaffoldMessenger.of(contextoScaffold).showSnackBar(
                      const SnackBar(
                        backgroundColor: Constantes.corAzulEscuroPrincipal,
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
                      await equipamento.conceder(pacientePreEscolhido!, model);
                    } catch (erro) {
                      equipamento.status = StatusDoEquipamento.disponivel;
                      mostrarMensagemErro(context, erro.toString());
                    }
                    ScaffoldMessenger.of(contextoScaffold).showSnackBar(
                      const SnackBar(
                        backgroundColor: Constantes.corAzulEscuroPrincipal,
                        content: Text("Equipamento concedido"),
                      ),
                    );
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                }
              },
              child: Row(
                mainAxisAlignment: pacientePreEscolhido == null
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.center,
                mainAxisSize: pacientePreEscolhido == null
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
