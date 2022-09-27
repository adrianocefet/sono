import 'package:flutter/material.dart';
import 'package:sono/utils/models/equipamento.dart';

import '../../../../constants/constants.dart';

class InformacoesAdicionais extends StatefulWidget {
  final Equipamento equipamento;
  final String titulo;
  final String informacao;
  const InformacoesAdicionais(this.equipamento,this.titulo,this.informacao,{Key? key}) : super(key: key);

  @override
  State<InformacoesAdicionais> createState() => _InformacoesAdicionaisState();
}

class _InformacoesAdicionaisState extends State<InformacoesAdicionais> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1)),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                decoration: const 
                  BoxDecoration(
                    borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  color: Constantes.corAzulEscuroSecundario,),
                  height: 30,
                  child: Text(widget.titulo,style: const TextStyle(fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    widget.informacao,
                    style: const TextStyle(fontSize: 12),
                  ),
              ),
            ],
          ),
        ),
      );
  }
}