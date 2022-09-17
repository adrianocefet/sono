import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/qrCodeGerado.dart';
import 'package:sono/utils/models/equipamento.dart';

import '../../../../constants/constants.dart';

class TituloEFoto extends StatefulWidget {
  final Equipamento equipamento;
  final String semfoto;
  const TituloEFoto({required this.equipamento,required this.semfoto,Key? key}) : super(key: key);

  @override
  State<TituloEFoto> createState() => _TituloEFotoState();
}

class _TituloEFotoState extends State<TituloEFoto> {
  @override
  Widget build(BuildContext context) {
    Equipamento equipamento = widget.equipamento;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                equipamento.urlFotoDePerfil??widget.semfoto,
                width: MediaQuery.of(context).size.width *
                    0.26,
                height: MediaQuery.of(context).size.height *
                    0.14,
                fit: BoxFit.cover,
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
                    color:
                        Constantes.corAzulEscuroPrincipal,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(25),
                      color: equipamento.status.cor,
                    ),
                    child: Icon(
                      equipamento.status.icone2,
                      size: 20,
                      color:
                          Constantes.corAzulEscuroPrincipal,
                    ),
                  ),
                ))
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width:
                  MediaQuery.of(context).size.width * 0.4,
              child: Text(
                equipamento.nome,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text("Status: " +
                equipamento.status.emStringMaiuscula)
          ],
        ),
        Material(
            child: IconButton(
          onPressed: () {
            Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  qrCodeGerado(
                                    idEquipamento:equipamento.id,
                                  )));
          },
          icon: const Icon(
            Icons.qr_code,
            color: Constantes.corAzulEscuroPrincipal,
            size: 30,
          ),
          splashColor: Constantes.corAzulEscuroPrincipal,
        ))
      ],
    );
  }
}