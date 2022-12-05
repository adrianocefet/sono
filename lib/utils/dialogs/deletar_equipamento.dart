import 'package:flutter/material.dart';
import 'package:sono/utils/dialogs/carregando.dart';
import 'package:sono/utils/models/solicitacao.dart';
import 'package:sono/utils/services/firebase.dart';

import '../../constants/constants.dart';
import '../models/equipamento.dart';
import '../models/usuario.dart';
import 'error_message.dart';
import 'justificativa.dart';

Future mostrarDialogDeletarEquipamento(
    context, Equipamento equipamento, Usuario usuario) async {
  return await showDialog(
      context: context,
      builder: (context) => Center(
            child: Container(
              margin: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Material(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(17),
                          topRight: Radius.circular(17),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: const Center(
                        child: Text(
                          'Deseja deletar esse equipamento?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Uma solicitação de deleção será enviada à dispensação!",
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Não',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(97, 253, 125, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                String? justificativa =
                                    await mostrarDialogJustificativa(
                                        context,
                                        'Deletar do hospital?',
                                        'Qual o motivo da deleção?');
                                if (justificativa != null) {
                                  mostrarDialogCarregando(context);
                                  await equipamento.solicitarDelecao(
                                      usuario, justificativa);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor:
                                          Constantes.corAzulEscuroPrincipal,
                                      content: Text(
                                          "Solicitação enviada à dispensação!"),
                                    ),
                                  );
                                } else {
                                  Navigator.pop(context);
                                }
                              } catch (erro) {
                                mostrarMensagemErro(context, erro.toString());
                              }
                            },
                            child: const Text(
                              'Sim',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(97, 253, 125, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));

  /* AlertDialog(
          title: const Text(
            'Deseja deletar este equipamento?',
          ),
          content: const Text(
            "Este processo não pode ser revertido!",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                mostrarDialogCarregando(context);
                try {
                  await FirebaseService().removerEquipamento(idEquipamento);
                } catch (e) {
                  rethrow;
                }

                Navigator.pop(context, true);
                Navigator.pop(context);
              },
              child: const Text(
                "Sim",
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                "Não",
              ),
            )
          ],
        ),
      ) ??
      false; */
}
