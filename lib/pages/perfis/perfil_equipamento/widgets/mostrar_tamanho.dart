import 'package:flutter/material.dart';
import 'package:sono/utils/models/tamanho_equipamento.dart';

class mostrarTamanho extends StatelessWidget {
  const mostrarTamanho({required this.tamanho});

  final TamanhoItem tamanho;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  child: Text(
                    "Tamanho: ${tamanho.nome} ",
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 30),
                  ),
                ),
                Container(

                  padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 4),
                  child: Text(
                    'Estoque: ${tamanho.estoque}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25
                    ),
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}