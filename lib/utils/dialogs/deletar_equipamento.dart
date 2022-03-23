import 'package:flutter/material.dart';
import 'package:sono/utils/dialogs/carregando.dart';
import 'package:sono/utils/services/firebase.dart';


Future<bool> mostrarDialogDeletarEquipmaneto(context, idEquipamento) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
      false;
}
