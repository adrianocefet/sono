import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';

Future<void> mostrarDialogDesejaSairDoQuestionario(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Wrap(
        children: const [
          Text(
            "Deseja sair do questionário?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Constantes.corAzulEscuroPrincipal,
            ),
          ),
        ],
      ),
      content: const Text("As respostas não serão salvas!"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancelar",
            style: TextStyle(
              color: Constantes.corAzulEscuroPrincipal,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text(
            "Sair",
            style: TextStyle(
              color: Constantes.corAzulEscuroPrincipal,
            ),
          ),
        ),
      ],
    ),
  );
}
