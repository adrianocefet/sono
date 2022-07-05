import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';

import '../../utils/models/user_model.dart';
import '../../widgets/foto_de_perfil.dart';
import '../../widgets/pesquisa.dart';
import '../perfis/perfil_equipamento/widgets/tipos_equip.dart';

class TipoSelecionado extends StatefulWidget {
  final int status;
  const TipoSelecionado(this.status,{Key? key}) : super(key: key);

  @override
  State<TipoSelecionado> createState() => _TipoSelecionadoState();
}

class _TipoSelecionadoState extends State<TipoSelecionado> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constantes.status[widget.status]),
        centerTitle: true,
        backgroundColor: Constantes.corAzulEscuroPrincipal,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 194, 195, 255),Colors.white],
            stops: [0,0.4]
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView(
            gridDelegate:   
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
            children: [
              BotaoTipoEquipamento(titulo: 'Máscara Nasal',imagem: 'https://www.cpapmed.com.br/media/W1siZiIsIjIwMTQvMDYvMTgvMTVfMDZfMjhfOTk2X1RydWVCbHVlXzEuanBnIl1d/TrueBlue-1.jpg',paginaAtual: widget.status,),
              BotaoTipoEquipamento(titulo: 'Máscara Oronasal',imagem: 'https://www.cpapmed.com.br/media/W1siZiIsIjIwMTQvMDYvMTcvMTNfNDNfMDZfODUwX0FtYXJhXzEuanBnIl0sWyJwIiwidGh1bWIiLCI0MDB4NDAwPiJdXQ/Amara-1.jpg',paginaAtual: widget.status,),
              BotaoTipoEquipamento(titulo: 'Máscara Pillow',imagem: 'https://a3.vnda.com.br/650x/espacoquallys/2019/09/13/10252-mascara-cpap-pillow-breeze-sefam-5146.jpg?v=1568415183',paginaAtual: widget.status,),
              BotaoTipoEquipamento(titulo: 'Máscara Facial',imagem: 'https://www.cpapmed.com.br/media/W1siZiIsIjIwMTMvMDUvMjEvMjFfNDVfMjBfNDk5X0ZpdExpZmUuanBnIl1d/FitLife.jpg',paginaAtual: widget.status,),
              BotaoTipoEquipamento(titulo: 'Aparelho PAP',imagem: 'https://a4.vnda.com.br/1200x/pedeapoio/2019/10/02/31233-aparelho-cpap-apap-reswell-automatico-completo-com-mascara-n2-2550.png?v=1570018948',paginaAtual: widget.status,),
              BotaoTipoEquipamento(titulo: 'Traqueia',imagem: 'https://static.cpapfit.com.br/public/cpapfit/imagens/produtos/mini-traqueia-para-mascara-swift-fx-resmed-720.jpg',paginaAtual: widget.status,),
              BotaoTipoEquipamento(titulo: 'Fixadores',imagem: 'https://static.cpapfit.com.br/public/cpapfit/imagens/produtos/fixador-para-mascara-facial-fitlife-e-performax-philips-respironics-1042.jpg',paginaAtual: widget.status,),
              BotaoTipoEquipamento(titulo: 'Almofadas',imagem: 'https://www.cpapbiancoazure.com.br/upload/produto/imagem/almofada-em-gel-e-aba-em-silicone-p-m-scara-nasal-comfortegel-blue-original-philips-respironics-1.jpg',paginaAtual: widget.status,),
            ],
              ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          print(widget.status);
        },
        child: Icon(Icons.add),
        backgroundColor: Constantes.corAzulEscuroPrincipal,
        )
    );
  }
}