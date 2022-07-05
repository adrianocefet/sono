import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../tabelas/tab_lista_de_equipamentos.dart';

class BotaoTipoEquipamento extends StatefulWidget {
  final String imagem;
  final String titulo;
  final int paginaAtual;
  const BotaoTipoEquipamento({required this.imagem,required this.titulo,required this.paginaAtual,Key? key}) : super(key: key);

  @override
  State<BotaoTipoEquipamento> createState() => _BotaoTipoEquipamentoState();
}

class _BotaoTipoEquipamentoState extends State<BotaoTipoEquipamento> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
            style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ListaDeEquipamentos(tipo: widget.titulo,status: widget.paginaAtual,)));
            }, 
            child: Column(
              children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1,),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        widget.imagem,
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.1,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
              const SizedBox(
                height: 3,
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  widget.titulo,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontWeight: FontWeight.w300,
                    color: Colors.black
                  ),
                ),
              )
              ],
            )
            );
  }
}