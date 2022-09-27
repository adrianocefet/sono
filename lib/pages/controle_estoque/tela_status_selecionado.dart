import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/tabelas/tab_tipos_equipamento.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/usuario.dart';

import '../../constants/constants.dart';

int currentIndex = 0;

class TiposEquipamentos extends StatefulWidget {
  const TiposEquipamentos({Key? key}) : super(key: key);
  @override
  State<TiposEquipamentos> createState() => _TiposEquipamentosState();
}

class _TiposEquipamentosState extends State<TiposEquipamentos> {
  // ignore: non_constant_identifier_names
  Map<int, StatusDoEquipamento> Status = {
    0: StatusDoEquipamento.disponivel,
    1: StatusDoEquipamento.emprestado,
    2: StatusDoEquipamento.manutencao,
    3: StatusDoEquipamento.desinfeccao,
    4: StatusDoEquipamento.concedido
  };
  final telas = const [
    TiposDeEquipamentos(),
    TiposDeEquipamentos(),
    TiposDeEquipamentos(),
    TiposDeEquipamentos(),
    TiposDeEquipamentos(),
  ];

  bool inicializado = false;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Usuario>(builder: (context, child, model) {
      if (inicializado == false) {
        currentIndex = Status.keys.firstWhere((i) => Status[i] == model.status);
        inicializado = true;
      }

      return Scaffold(
        body: telas[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Constantes.corAzulEscuroPrincipal,
          selectedFontSize: 10,
          currentIndex: currentIndex,
          selectedItemColor: Colors.white,
          showUnselectedLabels: false,
          unselectedItemColor: Color.fromARGB(255, 33, 35, 87),
          onTap: (index) => setState(() {
            currentIndex = index;
            model.status = Status[index]!;
          }),
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.check_circle), label: 'Disponíveis'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.people), label: 'Empréstimos'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.build_circle_rounded), label: 'Reparos'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.clean_hands_rounded), label: 'Desinfecção'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.assignment_ind), label: 'Concedidos'),
          ],
        ),
      );
    });
  }
}
