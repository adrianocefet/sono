import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/tabelas/tab_equipamentos.dart';
import 'package:sono/pages/tabelas/tab_tiposEquipamentos.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../pagina_inicial/widgets/widgets_drawer.dart';
import '../perfis/perfil_equipamento/relatorio/relatorio.dart';

class TabelaControleEstoque extends StatefulWidget {
  final PageController pageController;
  const TabelaControleEstoque({required this.pageController,Key? key}) : super(key: key);

  @override
  State<TabelaControleEstoque> createState() => _TabelaControleEstoqueState();
}

class _TabelaControleEstoqueState extends State<TabelaControleEstoque> {
  final List<ChartData> chartData=[
    ChartData('Máscaras',70,30,40,50),
    ChartData('Traqueias',40,20,10,16),
    ChartData('Filtros',20,15,10,30),
    ChartData('PAP',20,10,11,8),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Controle de Estoque"),
        backgroundColor: Constantes.corAzulEscuroPrincipal,
        centerTitle: true,
      ),
      drawer: CustomDrawer(widget.pageController),
      drawerEnableOpenDragGesture: true,
      body: Container(
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 194, 195, 255),Colors.white],
            stops: [0,0.4]
            )
        ),
        child: ListView(
          children: [SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Wrap(
                        alignment: WrapAlignment.end,
                        direction: Axis.horizontal,
                        spacing: 50,
                        runSpacing: 20,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.white
                            ),
                            onPressed:(){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>TiposEquipamentos(0)));
                            }, 
                            child: SizedBox(
                              height: 50,
                              width: 90,
                              child: Column(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    size: 34,
                                    color: Color.fromRGBO(97, 253, 125, 1),),
                                  const Text("Disponíveis",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.white
                            ),
                            onPressed:(){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>TiposEquipamentos(1)));
                            }, 
                            child: SizedBox(
                              height: 50,
                              width: 90,
                              child: Column(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  const Icon(
                                    Icons.people,
                                    size: 34,
                                    color: Color.fromRGBO(97, 253, 125, 1),),
                                  const Text("Empréstimos",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.white
                            ),
                            onPressed:(){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>TiposEquipamentos(2)));
                            }, 
                            child: SizedBox(
                              height: 50,
                              width: 90,
                              child: Column(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  const Icon(
                                    Icons.build_circle_rounded,
                                    size: 34,
                                    color: Color.fromRGBO(97, 253, 125, 1),),
                                  const Text("Manutenção",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.white
                            ),
                            onPressed:(){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>TiposEquipamentos(3)));
                            }, 
                            child: SizedBox(
                              height: 50,
                              width: 90,
                              child: Column(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  const Icon(
                                    Icons.clean_hands_rounded,
                                    size: 34,
                                    color: Color.fromRGBO(97, 253, 125, 1),),
                                  // ignore: prefer_const_constructors
                                  Text("Desinfecção",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2,color: Constantes.corAzulEscuroPrincipal),
                            color: Colors.white
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(7),
                                    topRight: Radius.circular(7),
                                  ),
                                  color: Constantes.corAzulEscuroSecundario,
                                ),
                                height: 50,
                                child: const Text("Visão Geral",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                  ),),
                              ),
                              SfCartesianChart(
                                legend: Legend(isVisible: true,position: LegendPosition.bottom),
                                enableAxisAnimation: true,
                                primaryXAxis: CategoryAxis(labelStyle: const TextStyle(fontSize: 10)),
                                series: <ChartSeries> [
                                  StackedColumnSeries<ChartData,String>(
                                    name: "Disponível",
                                    color: Constantes.corVerdeClaroPrincipal,
                                    dataSource: chartData, 
                                    xValueMapper: (ChartData ch, _) => ch.x, 
                                    yValueMapper: (ChartData ch, _) => ch.y1,
                                    ),
                                  StackedColumnSeries<ChartData,String>(
                                    name: "Empréstimos",
                                    color: Constantes.corPrincipalQuestionarios,
                                    dataSource: chartData, 
                                    xValueMapper: (ChartData ch, _) => ch.x, 
                                    yValueMapper: (ChartData ch, _) => ch.y2,
                                    ),
                                  StackedColumnSeries<ChartData,String>(
                                    name: "Manutenção",
                                    color: Constantes.dom4Color,
                                    dataSource: chartData, 
                                    xValueMapper: (ChartData ch, _) => ch.x, 
                                    yValueMapper: (ChartData ch, _) => ch.y3),
                                  StackedColumnSeries<ChartData,String>(
                                    name: "Desinfecção",
                                    color: Constantes.corAzulEscuroPrincipal,
                                    dataSource: chartData, 
                                    xValueMapper: (ChartData ch, _) => ch.x, 
                                    yValueMapper: (ChartData ch, _) => ch.y4),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:10.0,horizontal: 10),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color.fromRGBO(97, 253, 125, 1),
                                    ),
                                    onPressed:(){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TelaRelatorio()));
                                    }, 
                                    child:  Text("Gerar relatório",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black
                                      ),
                                      ),
                                  ),
                                ),
                              )
                            ]),
                        ),
                      )
                    ],
                  ),
                ),
          ),]
        ),
      ),
    );
  }
}

class ChartData{
  final String x;
  final int y1;
  final int y2;
  final int y3;
  final int y4;
  ChartData(this.x,this.y1,this.y2,this.y3,this.y4);
}