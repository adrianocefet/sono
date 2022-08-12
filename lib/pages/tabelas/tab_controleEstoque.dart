import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/tabelas/tab_equipamentos.dart';
import 'package:sono/pages/tabelas/tab_tiposEquipamentos.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../utils/models/user_model.dart';
import '../pagina_inicial/widgets/widgets_drawer.dart';
import '../perfis/perfil_equipamento/relatorio/DadosTeste/EquipamentosCriados.dart';
import '../perfis/perfil_equipamento/relatorio/DadosTeste/classeEquipamentoteste.dart';
import '../perfis/perfil_equipamento/relatorio/relatorio.dart';
import '../perfis/perfil_equipamento/relatorio/relatorio_geral.dart';

class TabelaControleEstoque extends StatefulWidget {
  final PageController pageController;
  const TabelaControleEstoque({required this.pageController,Key? key}) : super(key: key);

  @override
  State<TabelaControleEstoque> createState() => _TabelaControleEstoqueState();
}

class _TabelaControleEstoqueState extends State<TabelaControleEstoque> {
  late List<Equipamento> equipamentos;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    equipamentos = List.of(todosEquipamentos);
  }


  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData=[
      for(int i=0;i<8;i++)
      ChartData(Constantes.tipo[i],calcularQuantidade(0, i, equipamentos),calcularQuantidade(1, i, equipamentos),calcularQuantidade(2, i, equipamentos),calcularQuantidade(3, i, equipamentos)),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Controle de Estoque"),
        backgroundColor: Constantes.corAzulEscuroPrincipal,
        centerTitle: true,
      ),
      drawer: CustomDrawer(widget.pageController),
      drawerEnableOpenDragGesture: true,
      body: ScopedModelDescendant<UserModel>(
        builder:(context,child,model){
        return Container(
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
                            for(int i=0;i<4;i++)
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                                backgroundColor: Colors.white
                              ),
                              onPressed:(){
                                model.status=i;
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>TiposEquipamentos()));
                              }, 
                              child: SizedBox(
                                height: 50,
                                width: 90,
                                child: Column(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Icon(
                                      Constantes.icone2[i],
                                      size: 34,
                                      color: Color.fromRGBO(97, 253, 125, 1),),
                                    Text(Constantes.status[i],
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
                                  zoomPanBehavior: ZoomPanBehavior(
                                    enablePinching: true,
                                    enablePanning: true
                                  ),
                                  legend: Legend(isVisible: true,position: LegendPosition.bottom),
                                  enableAxisAnimation: true,
                                  primaryXAxis: CategoryAxis(labelStyle: const TextStyle(fontSize: 5)),
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
        );}
      ),
    );
  }
}

int calcularQuantidade(int status,int tipo, List<Equipamento> equipamentos,{bool calcularTotal=false}){
    int contador=0;
    calcularTotal==false?
    equipamentos.forEach((Equipamento equipamento) {equipamento.status==Constantes.status2[status]&&equipamento.tipo==Constantes.tipo[tipo]?contador++:null;}):
    equipamentos.forEach((Equipamento equipamento) {equipamento.tipo==Constantes.tipo[tipo]?contador++:null;});
    return contador;
  }

class ChartData{
  final String x;
  final int y1;
  final int y2;
  final int y3;
  final int y4;
  ChartData(this.x,this.y1,this.y2,this.y3,this.y4);
}