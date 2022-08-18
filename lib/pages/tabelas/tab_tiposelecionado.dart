import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/models/equipamento.dart';

import '../../utils/models/user_model.dart';
import '../../widgets/foto_de_perfil.dart';
import '../../widgets/pesquisa.dart';
import '../perfis/perfil_equipamento/adicionar_equipamento.dart';
import '../perfis/perfil_equipamento/widgets/tipos_equip.dart';

class TipoSelecionado extends StatefulWidget {
  const TipoSelecionado({Key? key}) : super(key: key);

  @override
  State<TipoSelecionado> createState() => _TipoSelecionadoState();
}

class _TipoSelecionadoState extends State<TipoSelecionado> {
  
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
        builder:(context, child, model) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constantes.status[model.status]),
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
                for(var tipo in TipoEquipamento.values)
                BotaoTipoEquipamento(titulo: tipo, imagem: tipo.imagens),
              ],
                ),
          ),
        ),        
        
      );},
    );
  }
}