import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sono/pages/perfis/perfil_equipamento/qr_code/qrCodeGerado.dart';
import 'package:sono/utils/dialogs/mostrar_foto_completa.dart';
import 'package:sono/utils/models/equipamento.dart';

import '../../../../constants/constants.dart';
import '../../../controle_estoque/widgets/foto_equipamento.dart';

class TituloEFoto extends StatefulWidget {
  final Equipamento equipamento;
  final String semfoto;
  const TituloEFoto(
      {required this.equipamento, required this.semfoto, Key? key})
      : super(key: key);

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
        InkWell(
          onTap: () async {
            await mostrarFotoCompleta(
                context, equipamento.urlFotoDePerfil, widget.semfoto);
          },
          child: FotoEquipamento(
            equipamento: equipamento,
            semimagem: widget.semfoto,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text(
                equipamento.nome,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Text("Status: " + equipamento.status.emStringMaiuscula)
          ],
        ),
        Material(
            child: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QrCodeGerado(
                          idEquipamento: equipamento.id,
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
