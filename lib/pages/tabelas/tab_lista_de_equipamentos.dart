import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sono/constants/constants.dart';

import '../perfis/perfil_equipamento/adicionar_equipamento.dart';
import '../perfis/perfil_equipamento/relatorio/DadosTeste/EquipamentosCriados.dart';
import '../perfis/perfil_equipamento/relatorio/DadosTeste/classeEquipamentoteste.dart';
import '../perfis/perfil_equipamento/widgets/item_equipamento.dart';
import '../perfis/perfil_equipamento/widgets/pesquisaEquipamento.dart';

class ListaDeEquipamentos extends StatefulWidget {
  final String tipo;
  final int status;
  const ListaDeEquipamentos({required this.tipo,required this.status,Key? key}) : super(key: key);

  @override
  State<ListaDeEquipamentos> createState() => _ListaDeEquipamentosState();
}

class _ListaDeEquipamentosState extends State<ListaDeEquipamentos> {
  late List<Equipamento> equipamentos;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.equipamentos = List.of(todosEquipamentos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tipo),
        actions: [
          IconButton(onPressed: (){
            showSearch(
              context: context,
              delegate: PesquisaEquipamento(tipo: widget.tipo,status: widget.status),);
          }, icon: Icon(Icons.search))
        ],
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
        child:ListView(
            children:itensEquipamento(equipamentos), 
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdicionarEquipamento(widget.tipo)),
            );
        },
        child: Icon(Icons.add),
        backgroundColor: Constantes.corAzulEscuroPrincipal,
        ),
    );
  }
  
  List<Widget> itensEquipamento(List<Equipamento> equipamentos)=> 
    equipamentos.where((equipamento) => widget.tipo==equipamento.tipo&&widget.status==Constantes.status2.indexOf(equipamento.status)).isNotEmpty?
    equipamentos.map((Equipamento equipamento) {
      return widget.tipo==equipamento.tipo&&widget.status==Constantes.status2.indexOf(equipamento.status)?Padding(
        padding: const EdgeInsets.symmetric(horizontal:8.0),
        child: ItemEquipamento(equipamento: equipamento),
      ):Container();
    }).toList():[
        Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cancel,
                      size: 80.0,
                      color: Constantes.corAzulEscuroPrincipal,
                    ),
                    SizedBox(height: 16.0,),
                    Text(
                      'Nenhum(a) ${widget.tipo.toLowerCase()} ${Constantes.status3[widget.status].toLowerCase()}!',
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