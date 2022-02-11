import 'package:flutter/material.dart';
import 'package:sono/utils/services/firebase.dart';
import 'package:sono/widgets/dialogs/carregando.dart';

Future<bool> mostrarDialogDeletarPaciente(context, idPaciente) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Deseja deletar este paciente?',
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
              await FirebaseService().removePatient(idPaciente);
            } catch (e) {
              rethrow;
            }
            Navigator.pop(context);
            Navigator.pop(context, true);
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
  );
}
