import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/widgets/dialogs/aviso_ja_possui_paciente.dart';
import 'package:sono/widgets/dialogs/carregando.dart';
import 'package:sono/utils/helpers/registro_paciente_helper.dart';
import 'package:sono/utils/helpers/resposta_widget.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:sono/utils/dialogs/error_message.dart';

void mostrarDialogAdicionarPaciente(BuildContext context) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RegistroPacienteHelper helper = RegistroPacienteHelper();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ScopedModelDescendant<UserModel>(
        builder: (context, child, model) => AlertDialog(
          title: const Text('Adicionar paciente'),
          contentPadding: EdgeInsets.zero,
          content: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  RespostaWidget(helper.perguntas.first),
                  RespostaWidget(helper.perguntas.last),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Adicionar"),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  mostrarDialogCarregando(context);
                  try {
                    switch (await helper.registrarPaciente(model.hospital)) {
                      case StatusPaciente.jaExistenteNoBancoDeDados:
                        Navigator.pop(context);
                        mostrarAvisoJaPossuiPaciente(context);
                        break;
                      default:
                        Navigator.pop(context);
                        Navigator.pop(context);
                    }
                  } catch (e) {
                    Navigator.pop(context);
                    mostrarMensagemErro(context, e.toString());
                  }
                }
              },
            ),
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    },
  );
}
