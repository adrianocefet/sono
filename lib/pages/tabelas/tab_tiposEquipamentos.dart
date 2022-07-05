import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sono/pages/tabelas/tab_equipamentos.dart';
import 'package:sono/pages/tabelas/tab_tiposelecionado.dart';

import '../../constants/constants.dart';
int currentIndex=0;
class TiposEquipamentos extends StatefulWidget {
  final int status;
  const TiposEquipamentos(this.status,{Key? key}) : super(key: key);
  @override
  State<TiposEquipamentos> createState() => _TiposEquipamentosState();
}

class _TiposEquipamentosState extends State<TiposEquipamentos> {
    final telas=[
      TipoSelecionado(0),
      TipoSelecionado(1),
      TipoSelecionado(2),
      TipoSelecionado(3),
    ];
    
    bool inicializado=false;
  @override
  Widget build(BuildContext context) {
    
    if (inicializado==false){
      currentIndex=widget.status;
      inicializado=true;
    }
    
    
    return Scaffold(
      body: telas[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Constantes.corAzulEscuroPrincipal,
        currentIndex: currentIndex,
        selectedItemColor: Colors.white,
        showUnselectedLabels: false,
        unselectedItemColor: Color.fromARGB(255, 33, 35, 87),
        onTap: (index)=>setState(()=>currentIndex=index),
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label:'Disponíveis'
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label:'Empréstimos'
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.build_circle_rounded),
            label:'Reparos'
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.clean_hands_rounded),
            label:'Desinfecção'
          ),
        ],
        ),
    );
  }
}