import 'package:flutter/material.dart';
import 'package:sono/pages/perfis/perfil_paciente/perfil_clinico_paciente_controller.dart';

class DialogoComOPaciente extends StatelessWidget {
  final ControllerPerfilClinicoPaciente controller;
  const DialogoComOPaciente({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat,
              size: 100,
              color: Theme.of(context).focusColor,
            ),
            Text(
              "Em breve!",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
