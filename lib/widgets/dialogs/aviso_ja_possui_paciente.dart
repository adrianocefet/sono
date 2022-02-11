import 'package:flutter/material.dart';

void mostrarAvisoJaPossuiPaciente(
  BuildContext context, {
  bool? isLoading,
  String? conteudo,
}) {
  conteudo = conteudo ?? "Você já possui este paciente!";
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        "Paciente duplicado",
      ),
      content: Text(
        conteudo!,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ok'),
        )
      ],
    ),
  );
}
