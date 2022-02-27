import 'package:flutter/material.dart';
import 'package:sono/utils/models/equipamento/equipamento.dart';
import 'package:sono/widgets/dialogs/error_message.dart';

Future<void> mostrarDialogDevolverEquipamento(
    context, Equipamento equipamento) async {
  bool estaCarregando = false;
  return await showDialog(
    context: context,
    builder: (context) => AbsorbPointer(
      absorbing: estaCarregando,
      child: AlertDialog(
        title: const Text("Gostaria de devolver este equipamento?"),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                estaCarregando = true;
                await equipamento.devolver().then(
                      (value) => Navigator.pop(context),
                    );
              } on Exception catch (e) {
                Navigator.pop(context);
                mostrarMensagemErro(context, e.toString());
              }
            },
            child: const Text("Sim"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Não"),
          ),
        ],
      ),
    ),
  );
}
