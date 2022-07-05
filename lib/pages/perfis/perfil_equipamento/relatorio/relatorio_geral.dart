import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sono/pages/perfis/perfil_equipamento/relatorio/DadosTeste/EquipamentosCriados.dart';
import 'package:sono/pages/perfis/perfil_equipamento/relatorio/DadosTeste/classeEquipamentoteste.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../constants/constants.dart';

class relatorioGeral extends StatefulWidget {
  const relatorioGeral({Key? key}) : super(key: key);

  @override
  State<relatorioGeral> createState() => _relatorioGeralState();
}

class _relatorioGeralState extends State<relatorioGeral> {
  late List<Equipamento> equipamentos;
  late List<GDPData> _infoGrafico;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _infoGrafico = pegarDadosGrafico();
    equipamentos = List.of(todosEquipamentos);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 194, 195, 255),Colors.white],
            stops: [0,0.4]
            )
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Table(
                  border: TableBorder.all(borderRadius: BorderRadius.all(Radius.circular(10))),
                  columnWidths: {
                    0:FractionColumnWidth(0.4),
                    1:FractionColumnWidth(0.15),
                    2:FractionColumnWidth(0.15),
                    3:FractionColumnWidth(0.15),
                    4:FractionColumnWidth(0.15),
                  },
                  children: [
                    mostrarlinhas(['','Disponível','Emprestado','Manutenção','Desinfecção'],topo: true),
                      for(var i=0;i<8;i++) mostrarlinhas([Constantes.tipo[i],calcularQuantidade(0,i,equipamentos).toString(),calcularQuantidade(1,i,equipamentos).toString(),calcularQuantidade(2,i,equipamentos).toString(),calcularQuantidade(3,i,equipamentos).toString()]),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.4),
                  borderRadius: BorderRadius.circular(9)
                ),
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
                      height: 25,
                      child: Text('Percentual(%)',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    ),
                    SfCircularChart(
                      legend: Legend(isVisible: true,overflowMode: LegendItemOverflowMode.wrap,textStyle: TextStyle(fontWeight: FontWeight.w300,fontStyle: FontStyle.italic)),
                      series: <CircularSeries>[
                        PieSeries<GDPData, String>(
                          dataSource: _infoGrafico,
                          xValueMapper: (GDPData data,_)=> data.tipo,
                          yValueMapper: (GDPData data,_)=> data.qntd,
                          dataLabelSettings: DataLabelSettings(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w300
                            ),
                            overflowMode: OverflowMode.shift,
                            isVisible: true,
                            angle:1)
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  int calcularQuantidade(int status,int tipo, List<Equipamento> equipamentos){
    int contador=0;
    equipamentos.forEach((Equipamento equipamento) {equipamento.status==Constantes.status2[status]&&equipamento.tipo==Constantes.tipo[tipo]?contador++:null;});
    return contador;
  }

 TableRow mostrarlinhas(List<String> celula,{bool topo=false}) => TableRow(
  decoration: BoxDecoration(color: topo?Constantes.corAzulEscuroSecundario:Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))),
  children: celula.map((celula){ 
  final estilo = TextStyle(fontWeight: topo?FontWeight.bold:FontWeight.w300,fontSize: 15);
  final IconData icone;
  switch(celula){
    case 'Disponível':
      icone=Constantes.icone[0];
      break;
    case 'Emprestado':
      icone=Constantes.icone[1];
      break;
    
    case 'Manutenção':
      icone=Constantes.icone[2];
      break;
    
    case 'Desinfecção':
      icone=Constantes.icone[3];
      break;
    default:
      icone=Icons.abc_outlined;
  }
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(child: topo&&celula!=''?Icon(icone):Text(celula,style: estilo,)),

  );}).toList(),
 );

  List<GDPData> pegarDadosGrafico(){
    final List<GDPData> dadosGrafico = [
      GDPData('Máscara Nasal', 6),
      GDPData('Máscara Oronasal', 5),
      GDPData('Máscara Pillow', 4),
      GDPData('Máscara Facial', 12),
      GDPData('Aparelho PAP', 11),
      GDPData('Almofadas', 7),
      GDPData('Fixadores', 9),
      GDPData('Traqueia', 10),
    ];
    return dadosGrafico;
  }
  
}

 class GDPData{
  GDPData(this.tipo,this.qntd);

  String tipo;
  int qntd;
 }