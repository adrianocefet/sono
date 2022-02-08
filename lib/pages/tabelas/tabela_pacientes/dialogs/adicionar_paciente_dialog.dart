import 'package:flutter/material.dart';
import 'package:sono/utils/helpers/respostas.dart';
import 'package:sono/utils/models/pergunta.dart';

void mostrarDialogAdicionarPaciente(BuildContext context) {
  List<Pergunta> perguntas = [
    Pergunta("Foto do paciente (opcional)", TipoPergunta.foto, [], '', ''),
    Pergunta('Nome do paciente', TipoPergunta.extenso, [], '', " "),
  ];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: const Text('Adicionar paciente'),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          height: 300,
          width: 700,
          child: FittedBox(
            child: Form(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Resposta(perguntas.first),
                  Resposta(perguntas.last),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Adicionar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}
