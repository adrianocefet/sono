import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../utils/models/equipamento.dart';
import '../../perfis/perfil_equipamento/equipamento_controller.dart';
import 'item_equipamento.dart';

class FotoEquipamento extends StatelessWidget {
  const FotoEquipamento({
    Key? key,
    required this.equipamento,
    required this.semimagem,
  }) : super(key: key);

  final Equipamento equipamento;
  final String semimagem;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.14,
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                equipamento.urlFotoDePerfil ?? semimagem,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                color: Constantes.corAzulEscuroPrincipal,
                shape: BoxShape.circle,
              ),
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: equipamento.status.cor,
                ),
                child: Icon(
                  equipamento.status.icone2,
                  size: 20,
                  color: Constantes.corAzulEscuroPrincipal,
                ),
              ),
            ))
      ],
    );
  }
}
