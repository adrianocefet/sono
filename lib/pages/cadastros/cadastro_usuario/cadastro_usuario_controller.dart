import 'package:flutter/material.dart';
import 'package:sono/utils/dialogs/carregando.dart';
import 'package:sono/utils/dialogs/error_message.dart';
import 'package:sono/utils/helpers/registro_usuario_helper.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/utils/models/usuario.dart';

class CadastroUsuarioController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RegistroUsuarioHelper helper = RegistroUsuarioHelper();
  ValueNotifier<String?> senhaGerada = ValueNotifier<String?>(null);
  List<Pergunta> get perguntas => helper.perguntas;
  Usuario? usuario;

  CadastroUsuarioController({this.usuario});

  Future<void> registrarUsuario(BuildContext context) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    if (_validarFormulario()) {
      _salvarRespostasDoFormulario();
      try {
        mostrarDialogCarregando(context);
        switch (await helper.registrarUsuario()) {
          case CondicaoUsuario.novo:
            Navigator.pop(context);
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

  Future<void> editarUsuario(BuildContext context) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    if (_validarFormulario()) {
      _salvarRespostasDoFormulario();
      try {
        mostrarDialogCarregando(context);
        await helper.editarUsuario(usuario!);

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).focusColor,
            content: const Text(
              'Usuário editado com sucesso!',
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
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
