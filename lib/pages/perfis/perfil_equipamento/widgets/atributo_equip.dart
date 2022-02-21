import 'package:flutter/material.dart';
import 'package:sono/utils/models/equipamento/equipamento.dart';

class AtributoEquipamento extends StatelessWidget {
  final String atributo;
  final Equipamento equipamento;
  const AtributoEquipamento(this.equipamento, this.atributo, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          '$atributo : ',
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
        Text(
          equipamento.infoMap[atributo] ?? '',
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
      ],
    );
  }
}
