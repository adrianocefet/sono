import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/relatorio/relatorio.dart';
import 'package:sono/pages/controle_estoque/tela_status_selecionado.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../utils/models/equipamento.dart';
import '../../utils/models/user_model.dart';
import '../pagina_inicial/widgets/widgets_drawer.dart';

class ControleEstoque extends StatefulWidget {
  final PageController pageController;
  const ControleEstoque({required this.pageController, Key? key})
      : super(key: key);

  @override
  State<ControleEstoque> createState() => _ControleEstoqueState();
}

class _ControleEstoqueState extends State<ControleEstoque> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Controle de estoque"),
        backgroundColor: Constantes.corAzulEscuroPrincipal,
        centerTitle: true,
      ),
      drawer: CustomDrawer(widget.pageController),
      drawerEnableOpenDragGesture: true,
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        return Container(
          // ignore: prefer_const_constructors
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromARGB(255, 194, 195, 255), Colors.white],
                  stops: [0, 0.4])),
          child: ListView(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      direction: Axis.horizontal,
                      spacing: 50,
                      runSpacing: 20,
                      children: [
                        for (StatusDoEquipamento status in StatusDoEquipamento.values)
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Colors.white),
                              onPressed: () {
                                model.status = status;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TiposEquipamentos()));
                              },
                              child: SizedBox(
                                height: 50,
                                width: 90,
                                child: Column(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Icon(
                                      status.icone,
                                      size: 34,
                                      color: const Color.fromRGBO(97, 253, 125, 1),
                                    ),
                                    Text(
                                      status.emStringPlural,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 2,
                                color: Constantes.corAzulEscuroPrincipal),
                            color: Colors.white),
                        width: MediaQuery.of(context).size.width,
                        child: Column(children: [
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
                            child: const Text(
                              "Visão Geral",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          ScopedModelDescendant<UserModel>(
                            builder: (context, child, model) => StreamBuilder<
                                    QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('equipamentos')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                      return const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(
                                            color: Constantes
                                                .corAzulEscuroPrincipal,
                                          ),
                                        ),
                                      );
                                    default:
                                      List<QueryDocumentSnapshot<Object?>>
                                          documentos = snapshot.data!.docs;
                                      final List<ChartData> chartData = [
                                        for (var tipo in TipoEquipamento.values)
                                          ChartData(
                                            tipo.emString,
                                            documentos
                                                .where((element) =>
                                                    element['tipo']
                                                        .toString()
                                                        .contains(tipo
                                                            .emStringSnakeCase) &&
                                                    element['status']
                                                        .toString()
                                                        .contains(StatusDoEquipamento.disponivel.emString) &&
                                                    element['hospital']
                                                        .toString()
                                                        .contains(
                                                            model.hospital))
                                                .length,
                                            documentos
                                                .where((element) =>
                                                    element['tipo']
                                                        .toString()
                                                        .contains(tipo
                                                            .emStringSnakeCase) &&
                                                    element['status']
                                                        .toString()
                                                        .contains(StatusDoEquipamento.emprestado.emString) &&
                                                    element['hospital']
                                                        .toString()
                                                        .contains(
                                                            model.hospital))
                                                .length,
                                            documentos
                                                .where((element) =>
                                                    element['tipo']
                                                        .toString()
                                                        .contains(tipo
                                                            .emStringSnakeCase) &&
                                                    element['status']
                                                        .toString()
                                                        .contains(StatusDoEquipamento.manutencao.emString) &&
                                                    element['hospital']
                                                        .toString()
                                                        .contains(
                                                            model.hospital))
                                                .length,
                                            documentos
                                                .where((element) =>
                                                    element['tipo']
                                                        .toString()
                                                        .contains(tipo
                                                            .emStringSnakeCase) &&
                                                    element['status']
                                                        .toString()
                                                        .contains(StatusDoEquipamento.desinfeccao.emString) &&
                                                    element['hospital']
                                                        .toString()
                                                        .contains(
                                                            model.hospital))
                                                .length,
                                          ),
                                      ];
                                      return SfCartesianChart(
                                        zoomPanBehavior: ZoomPanBehavior(
                                            enablePinching: true,
                                            enablePanning: true),
                                        legend: Legend(
                                            width: MediaQuery.of(context).size.width.toString(),
                                            isVisible: true,
                                            overflowMode: LegendItemOverflowMode.wrap,
                                            position: LegendPosition.bottom,),
                                        enableAxisAnimation: true,
                                        primaryXAxis: CategoryAxis(
                                            labelStyle:
                                                const TextStyle(fontSize: 5)),
                                        series: <ChartSeries>[
                                          StackedColumnSeries<ChartData,
                                              String>(
                                            name: "Disponível",
                                            color: Constantes
                                                .corVerdeClaroPrincipal,
                                            dataSource: chartData,
                                            xValueMapper: (ChartData ch, _) =>
                                                ch.x,
                                            yValueMapper: (ChartData ch, _) =>
                                                ch.y1,
                                          ),
                                          StackedColumnSeries<ChartData,
                                              String>(
                                            name: "Empréstimos",
                                            color: const Color.fromARGB(
                                                255, 255, 191, 87),
                                            dataSource: chartData,
                                            xValueMapper: (ChartData ch, _) =>
                                                ch.x,
                                            yValueMapper: (ChartData ch, _) =>
                                                ch.y2,
                                          ),
                                          StackedColumnSeries<ChartData,
                                                  String>(
                                              name: "Manutenção",
                                              color: const Color.fromARGB(
                                                  255, 255, 112, 122),
                                              dataSource: chartData,
                                              xValueMapper: (ChartData ch, _) =>
                                                  ch.x,
                                              yValueMapper: (ChartData ch, _) =>
                                                  ch.y3),
                                          StackedColumnSeries<ChartData,
                                                  String>(
                                              name: "Desinfecção",
                                              color: const Color.fromARGB(
                                                  255, 116, 239, 255),
                                              dataSource: chartData,
                                              xValueMapper: (ChartData ch, _) =>
                                                  ch.x,
                                              yValueMapper: (ChartData ch, _) =>
                                                  ch.y4),
                                        ],
                                      );
                                  }
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(97, 253, 125, 1),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TelaRelatorio()));
                                },
                                child: const Text(
                                  "Gerar relatório",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black),
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
            ),
          ]),
        );
      }),
    );
  }
}

class ChartData {
  final String x;
  final int y1;
  final int y2;
  final int y3;
  final int y4;
  ChartData(this.x, this.y1, this.y2, this.y3, this.y4);
}
