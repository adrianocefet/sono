import 'package:flutter/material.dart';
import 'package:sono/utils/dialogs/carregando.dart';
import 'package:sono/utils/dialogs/error_message.dart';
import 'package:sono/utils/helpers/registro_usuario_helper.dart';
import 'package:sono/utils/models/pergunta.dart';

class CadastroUsuarioController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RegistroUsuarioHelper helper = RegistroUsuarioHelper();
  String? senhaGerada;
  List<Pergunta> get perguntas => helper.perguntas;

  CadastroUsuarioController();

  Future<void> registrarUsuario(BuildContext context) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    if (_validarFormulario()) {
      _salvarRespostasDoFormulario();
      try {
        mostrarDialogCarregando(context);
        switch (await helper.registrarUsuario()) {
          case CondicaoUsuario.novo:
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).focusColor,
                content: const Text(
                  'Usuário registrado com sucesso!',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
            senhaGerada = helper.senhaGerada;
            break;
          case CondicaoUsuario.jaExistenteNoBancoDeDados:
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Usuário já existe!',
                ),
              ),
            );
            break;
        }
      } catch (e) {
        Navigator.pop(context);
        mostrarMensagemErro(context, e.toString());
      }
    }
  }

  bool _validarFormulario() {
    if (formKey.currentState!.validate() == false) return false;

    return true;
  }

  void _salvarRespostasDoFormulario() => formKey.currentState!.save();
}
