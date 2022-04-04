import 'package:flutter/material.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/user_model.dart';

import 'equipamentos_emprestados.dart';

class PacienteVisaoGeral extends StatefulWidget {
  final Paciente paciente;
  final UserModel model;
  const PacienteVisaoGeral(
      {required this.paciente, required this.model, Key? key})
      : super(key: key);

  @override
  State<PacienteVisaoGeral> createState() => _PacienteVisaoGeralState();
}

class _PacienteVisaoGeralState extends State<PacienteVisaoGeral> {
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
                  Image.network(
                    widget.paciente.urlFotoDePerfil ?? widget.model.semimagem,
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.3,
                    fit: BoxFit.cover,
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
                                widget.paciente.nome,
                                style: const TextStyle(
                                  fontSize: 40,
                                ),
                              ),
                            )
                          : Container(),
                      EquipamentosEmprestados(
                        listaDeEquipamentos:
                            widget.paciente.equipamentosEmprestados,
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
