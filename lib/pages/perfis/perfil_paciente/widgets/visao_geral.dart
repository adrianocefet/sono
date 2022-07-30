import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sono/pages/perfis/perfil_paciente/perfil_clinico_paciente_controller.dart';
import 'package:sono/pages/perfis/perfil_paciente/widgets/informacoes_gerais.dart';
import 'package:sono/utils/models/paciente.dart';

class VisaoGeralPaciente extends StatefulWidget {
  final ControllerPerfilClinicoPaciente controller;
  const VisaoGeralPaciente({Key? key, required this.controller})
      : super(key: key);

  @override
  State<VisaoGeralPaciente> createState() => _VisaoGeralPacienteState();
}

class _VisaoGeralPacienteState extends State<VisaoGeralPaciente> {
  @override
  Widget build(BuildContext context) {
    final Paciente paciente = widget.controller.paciente;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.92,
          margin: const EdgeInsets.only(top: 65),
          padding: const EdgeInsets.fromLTRB(10, 45, 10, 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              width: 2,
              color: Theme.of(context).primaryColor,
            ),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Status: ${paciente.statusFormatado}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              InformacoesGerais(paciente: paciente),
            ],
          ),
        ),
        _FotoDoPaciente(paciente.urlFotoDePerfil),
      ],
    );
  }
}

class _FotoDoPaciente extends StatelessWidget {
  final String? urlImagem;
  const _FotoDoPaciente(
    this.urlImagem, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: urlImagem == null
              ? const NetworkImage(
                  'https://toppng.com/uploads/preview/app-icon-set-login-icon-comments-avatar-icon-11553436380yill0nchdm.png',
                )
              : NetworkImage(urlImagem!),
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          child: const FaIcon(
            FontAwesomeIcons.smile,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
