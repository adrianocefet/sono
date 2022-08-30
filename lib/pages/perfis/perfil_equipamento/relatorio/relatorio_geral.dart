import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../constants/constants.dart';

class relatorioGeral extends StatefulWidget {
  const relatorioGeral({Key? key}) : super(key: key);

  @override
  State<relatorioGeral> createState() => _relatorioGeralState();
}

class _relatorioGeralState extends State<relatorioGeral> {
  
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) =>StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('equipamentos').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: CircularProgressIndicator(),
              );
            default:
           List<QueryDocumentSnapshot<Object?>> documentos=snapshot.data!.docs;
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
                        border: TableBorder.all(borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))),
                        columnWidths: const {
                          0:FractionColumnWidth(0.25),
                          1:FractionColumnWidth(0.15),
                          2:FractionColumnWidth(0.15),
                          3:FractionColumnWidth(0.15),
                          4:FractionColumnWidth(0.15),
                          5:FractionColumnWidth(0.15),
                        },
                        children: [
                            mostrarlinhas(['','Disponível','Emprestado','Manutenção','Desinfecção','Total'],topo: true),
                            for(var tipo in TipoEquipamento.values) 
                            mostrarlinhas([tipo.emString,
                            documentos.where((element) => element['tipo'].toString().contains(tipo.emStringSnakeCase)&&element['status'].toString().contains(Constantes.status3[0])&&element['hospital'].toString().contains(model.hospital)).length.toString(),
                            documentos.where((element) => element['tipo'].toString().contains(tipo.emStringSnakeCase)&&element['status'].toString().contains(Constantes.status3[1])&&element['hospital'].toString().contains(model.hospital)).length.toString(),
                            documentos.where((element) => element['tipo'].toString().contains(tipo.emStringSnakeCase)&&element['status'].toString().contains(Constantes.status3[2])&&element['hospital'].toString().contains(model.hospital)).length.toString(),
                            documentos.where((element) => element['tipo'].toString().contains(tipo.emStringSnakeCase)&&element['status'].toString().contains(Constantes.status3[3])&&element['hospital'].toString().contains(model.hospital)).length.toString(),
                            documentos.where((element) => element['tipo'].toString().contains(tipo.emStringSnakeCase)&&element['hospital'].toString().contains(model.hospital)).length.toString()]), 
                        ],
                      ),
                    ),
                  ),
                  for(var tipo in TipoEquipamento.values)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.4),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(9),
                          topRight: Radius.circular(9),
                        )
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
                            child: Text('Percentual ${tipo.emString.toLowerCase()}(%)',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                          ),
                          SfCircularChart(
                            backgroundColor: Colors.white,
                            legend: Legend(isVisible: true,overflowMode: LegendItemOverflowMode.wrap,textStyle: TextStyle(fontWeight: FontWeight.w300,fontStyle: FontStyle.italic)),
                            series: <CircularSeries>[
                              PieSeries<GDPData, String>(
                                dataSource:  [
                                  GDPData('Disponíveis', 
                                  (documentos.where((element) => element['tipo'].toString().contains(tipo.emStringSnakeCase)&&element['status'].toString().contains(Constantes.status3[0])&&element['hospital'].toString().contains(model.hospital)).length*100
                                  ~/(documentos.where((element) => element['tipo'].toString().contains(tipo.emStringSnakeCase)&&element['hospital'].toString().contains(model.hospital)).length==0?1:documentos.where((element) => element['tipo'].toString().contains(tipo.emStringSnakeCase)&&element['hospital'].toString().contains(model.hospital)).length))),

                                  GDPData('Empréstimos', 
                                  (documentos.where((element) => element['tipo'].toString().contains(tipo.emStringSnakeCase)&&element['status'].toString().contains(Constantes.status3[1])&&element['hospital'].toString().contains(model.hospital)).length*100
                                  ~/(documentos.where((element) => element['tipo'].toString().contains(tipo.emStringSnakeCase)&&element['hospital'].toString().contains(model.hospital)).length==0?1:documentos.where((element) => element['tipo'].toString().contains(tipo.emStringSnakeCase)&&element['hospital'].toString().contains(model.hospital)).length))),

                                  GDPData('Manutenção', 
                                  (documentos.where((element) => element['tipo'].toString().contains(tipo.emStringSnakeCase)&&element['status'].toString().contains(Constantes.status3[2])&&element['hospital'].toString().contains(model.hospital)).length*100
                                  ~/(documentos.where((element) => element['tipo'].toString().contains(tipo.emStringSnakeCase)&&element['hospital'].toString().contains(model.hospital)).length==0?1:documentos.where((element) => element['tipo'].toString().contains(tipo.emStringSnakeCase)&&element['hospital'].toString().contains(model.hospital)).length))),

                                  GDPData('Desinfecção', 
                                  (documentos.where((element) => element['tipo'].toString().contains(tipo.emStringSnakeCase)&&element['status'].toString().contains(Constantes.status3[3])&&element['hospital'].toString().contains(model.hospital)).length*100
                                  ~/(documentos.where((element) => element['tipo'].toString().contains(tipo.emStringSnakeCase)&&element['hospital'].toString().contains(model.hospital)).length==0?1:documentos.where((element) => element['tipo'].toString().contains(tipo.emStringSnakeCase)&&element['hospital'].toString().contains(model.hospital)).length))),
                                ],
                                xValueMapper: (GDPData data,_)=> data.tipo,
                                yValueMapper: (GDPData data,_)=> data.qntd,
                                dataLabelSettings: DataLabelSettings(
                                  textStyle: const TextStyle(
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
                  ), 
                ],
              ),
            ),
          );
        }}
      ),
    );
  }

 TableRow mostrarlinhas(List<String> celula,{bool topo=false}) => TableRow(
  decoration: BoxDecoration(color: topo?Constantes.corAzulEscuroSecundario:Colors.white,borderRadius: topo?BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)):null),
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
      icone=Icons.add;
  }
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(child: topo&&celula!=''&&celula!='Total'?Icon(icone):Text(celula,style: estilo,)),

  );}).toList(),
 );

} 

 class GDPData{
  GDPData(this.tipo,this.qntd);

  String tipo;
  int qntd;
 }