import 'package:flutter/material.dart';
import 'package:sono/pages/perfis/perfil_equipamento/relatorio/DadosTeste/EquipamentosCriados.dart';
import 'package:sono/pages/perfis/perfil_equipamento/relatorio/DadosTeste/classeEquipamentoteste.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/item_equipamento.dart';

import '../../../../constants/constants.dart';

class PesquisaEquipamento extends SearchDelegate {
  final String tipo;
  final int status;
  PesquisaEquipamento({required this.tipo, required this.status});

  late List<Equipamento> equipamentos=List.of(todosEquipamentos);


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 194, 195, 255),Colors.white],
            stops: [0,0.4]
            )
        ),
        child:ListView(
            children:itensEquipamento(equipamentos), 
          ),
        );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 194, 195, 255),Colors.white],
            stops: [0,0.4]
            )
        ),
        child:ListView(
            children:itensEquipamento(equipamentos), 
          ),
        );
  }

  List<Widget> itensEquipamento(List<Equipamento> equipamentos)=> 
    equipamentos.where((equipamento) => equipamento.nome.toLowerCase().contains(query.toLowerCase())&&tipo==equipamento.tipo&&status==Constantes.status2.indexOf(equipamento.status)).isNotEmpty?
    equipamentos.map((Equipamento equipamento) {
      return tipo==equipamento.tipo&&status==Constantes.status2.indexOf(equipamento.status)&&equipamento.nome.toLowerCase().contains(query.toLowerCase())?Padding(
        padding: const EdgeInsets.symmetric(horizontal:8.0),
        child: ItemEquipamento(equipamento: equipamento),
      ):Container();
    }).toList():[
        Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.search_off,
                      size: 80.0,
                      color: Constantes.corAzulEscuroPrincipal,
                    ),
                    SizedBox(height: 16.0,),
                    Text(
                      'Equipamento não encontrado!',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Constantes.corAzulEscuroPrincipal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
      
      ];
    
}
