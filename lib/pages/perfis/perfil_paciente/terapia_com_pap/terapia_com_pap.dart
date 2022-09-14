import 'package:flutter/material.dart';
import 'package:sono/pages/perfis/perfil_paciente/perfil_clinico_paciente_controller.dart';
import 'package:sono/pages/perfis/perfil_paciente/terapia_com_pap/widgets/equipamentos_paciente.dart';

class TerapiaComPAP extends StatelessWidget {
  final ControllerPerfilClinicoPaciente controller;
  const TerapiaComPAP({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: const [
            EquipamentosDoPaciente(),
          ],
        ),
      ),
    );
  }
}
