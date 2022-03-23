import 'package:flutter/material.dart';

void mostrarAvisoJaPossuiEquipamento(
  BuildContext context, {
  bool? isLoading,
  String? conteudo,
}) {
  conteudo = conteudo ?? "Você já possui este equipamento!";
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        "Equipamento duplicado",
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