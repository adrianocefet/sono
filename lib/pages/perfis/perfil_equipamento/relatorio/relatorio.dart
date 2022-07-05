import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/perfis/perfil_equipamento/relatorio/relatorio_especifico.dart';
import 'package:sono/pages/perfis/perfil_equipamento/relatorio/relatorio_geral.dart';

class TelaRelatorio extends StatefulWidget {
  const TelaRelatorio({Key? key}) : super(key: key);

  @override
  State<TelaRelatorio> createState() => _TelaRelatorioState();
}

class _TelaRelatorioState extends State<TelaRelatorio> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constantes.corAzulEscuroPrincipal,
          title: Text("Relatório de equipamentos"),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Visão geral',),
              Tab(text: 'Visão específica',),
            ]),
        ),
        body: TabBarView(
          children: [
            relatorioGeral(),
            relatorioEspecifico(),
          ]),
      ),
    );
  }
}