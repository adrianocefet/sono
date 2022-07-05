import 'package:flutter/material.dart';

import '../../../../utils/models/paciente.dart';

class AtributoPaciente extends StatelessWidget {
  final String atributo;
  final Paciente paciente;
  const AtributoPaciente({
    required this.atributo,
    required this.paciente,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$atributo : ',
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
        Text(
          paciente.infoMap[atributo] ?? '',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
