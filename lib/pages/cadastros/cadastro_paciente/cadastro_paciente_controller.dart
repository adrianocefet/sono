import 'package:flutter/material.dart';
import 'package:sono/pages/perfis/perfil_paciente/perfil_clinico_paciente.dart';
import 'package:sono/utils/dialogs/aviso_ja_possui_paciente.dart';
import 'package:sono/utils/dialogs/carregando.dart';
import 'package:sono/utils/dialogs/error_message.dart';
import 'package:sono/utils/helpers/registro_paciente_helper.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/utils/models/user_model.dart';

class CadastroPacienteController {
  final List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  final RegistroPacienteHelper helper = RegistroPacienteHelper();
  final PageController pageController = PageController();

  int paginaAtual = 0;
  List<Pergunta> get perguntas => helper.perguntas;

  CadastroPacienteController();

  Future<void> registrarPaciente(BuildContext context, UserModel model) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    if (_validarKeysDoFormulario()) {
      _salvarRespostasDoFormulario();
      try {
        mostrarDialogCarregando(context);
        switch (await helper.registrarPaciente()) {
          case StatusPaciente.pacienteNovo:
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PerfilClinicoPaciente(helper.idPaciente!),
              ),
            );
            break;
          case StatusPaciente.jaExistenteNoBancoDeDados:
            Navigator.pop(context);
            mostrarAvisoJaPossuiPaciente(context);
            break;
        }
      } catch (e) {
        Navigator.pop(context);
        mostrarMensagemErro(context, e.toString());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Existem respostas inválidas!",
          ),
        ),
      );
    }
  }

  bool _validarKeysDoFormulario() {
    for (GlobalKey<FormState> key in formKeys) {
      if (key.currentState!.validate() == false) return false;
    }

    return true;
  }

  void _salvarRespostasDoFormulario() =>
      formKeys.map((key) => key.currentState!.save());

  bool salvarRespostasDaPaginaAtual() {
    formKeys[paginaAtual].currentState!.save();
    if (formKeys[paginaAtual].currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
}
