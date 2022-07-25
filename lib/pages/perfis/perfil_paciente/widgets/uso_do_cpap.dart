import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/dialogs/editar_foto.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/user_model.dart';

import 'atributo_paciente.dart';
import 'editar_atributo_paciente.dart';

class UsoDoCPAP extends StatefulWidget {
  final Paciente paciente;
  final UserModel model;
  const UsoDoCPAP({required this.paciente, required this.model, Key? key})
      : super(key: key);

  @override
  State<UsoDoCPAP> createState() => _PacienteVisaoGeralState();
}

class _PacienteVisaoGeralState extends State<UsoDoCPAP> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Image.network(
                        widget.paciente.urlFotoDePerfil ??
                            widget.model.semimagem,
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.3,
                        fit: BoxFit.cover,
                      ),
                      widget.model.editar
                          ? EditarFoto(widget.paciente.id, "Paciente")
                          : const SizedBox()
                    ],
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.model.editar
                          ? FittedBox(
                              child: Text(
                                widget.paciente.nomeCompleto,
                                style: const TextStyle(
                                  fontSize: 40,
                                ),
                              ),
                            )
                          : Container(),
                      for (String atrib in Constantes.titulosAtributosPacientes)
                        widget.model.editar
                            ? EditarAtributoPaciente(
                                atributo: atrib,
                                paciente: widget.paciente,
                              )
                            : atrib == "Nome"
                                ? Container()
                                : AtributoPaciente(
                                    atributo: atrib,
                                    paciente: widget.paciente,
                                  ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
