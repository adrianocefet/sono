import 'package:flutter/material.dart';
import 'package:sono/pages/perfis/perfil_paciente/perfil_clinico_paciente_controller.dart';
import 'package:sono/pages/perfis/perfil_paciente/visao_geral/widgets/foto_e_info.dart';
import 'package:sono/pages/perfis/perfil_paciente/visao_geral/widgets/iniciar_avaliacao.dart';
import 'package:sono/pages/perfis/perfil_paciente/visao_geral/widgets/sintomas_ultima_avaliacao.dart';

class VisaoGeralDoPaciente extends StatelessWidget {
  final ControllerPerfilClinicoPaciente controller;
  const VisaoGeralDoPaciente({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            FotoEInformacoesPaciente(
              controller: controller,
            ),
            IniciarAvaliacao(
              paciente: controller.paciente,
            ),
            SintomasUltimaAvaliacao(
              ultimaAvaliacao: controller.paciente.ultimaAvaliacao,
            ),
          ],
        ),
      ),
    );
  }
}
