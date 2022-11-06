import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constants/constants.dart';
import '../../../utils/models/equipamento.dart';
import '../../../utils/models/usuario.dart';

class GraficoRelatorio extends StatefulWidget {
  const GraficoRelatorio({Key? key}) : super(key: key);

  @override
  State<GraficoRelatorio> createState() => _GraficoRelatorioState();
}

class _GraficoRelatorioState extends State<GraficoRelatorio> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Usuario>(
      builder: (context, child, model) => StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('equipamentos').snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: LinearProgressIndicator(
                      color: Constantes.corAzulEscuroPrincipal,
                    ),
                  ),
                );
              default:
                List<QueryDocumentSnapshot<Object?>> documentos =
                    snapshot.data!.docs;
                final List<ChartData> chartData = [
                  for (var tipo in TipoEquipamento.values)
                    ChartData(
                      tipo.emString,
                      documentos
                          .where((element) =>
                              element['tipo']
                                  .toString()
                                  .contains(tipo.emStringSnakeCase) &&
                              element['status'].toString().contains(
                                  StatusDoEquipamento.disponivel.emString) &&
                              element['hospital']
                                  .toString()
                                  .contains(model.instituicao.emString))
                          .length,
                      documentos
                          .where((element) =>
                              element['tipo']
                                  .toString()
                                  .contains(tipo.emStringSnakeCase) &&
                              element['status'].toString().contains(
                                  StatusDoEquipamento.emprestado.emString) &&
                              element['hospital']
                                  .toString()
                                  .contains(model.instituicao.emString))
                          .length,
                      documentos
                          .where((element) =>
                              element['tipo']
                                  .toString()
                                  .contains(tipo.emStringSnakeCase) &&
                              element['status'].toString().contains(
                                  StatusDoEquipamento.manutencao.emString) &&
                              element['hospital']
                                  .toString()
                                  .contains(model.instituicao.emString))
                          .length,
                      documentos
                          .where((element) =>
                              element['tipo']
                                  .toString()
                                  .contains(tipo.emStringSnakeCase) &&
                              element['status'].toString().contains(
                                  StatusDoEquipamento.desinfeccao.emString) &&
                              element['hospital']
                                  .toString()
                                  .contains(model.instituicao.emString))
                          .length,
                    ),
                ];
                return SfCartesianChart(
                  zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true, enablePanning: true),
                  legend: Legend(
                    width: MediaQuery.of(context).size.width.toString(),
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                    position: LegendPosition.bottom,
                  ),
                  enableAxisAnimation: true,
                  primaryXAxis:
                      CategoryAxis(labelStyle: const TextStyle(fontSize: 5)),
                  series: <ChartSeries>[
                    StackedColumnSeries<ChartData, String>(
                      name: "Disponível",
                      color: Constantes.corVerdeClaroPrincipal,
                      dataSource: chartData,
                      xValueMapper: (ChartData ch, _) => ch.x,
                      yValueMapper: (ChartData ch, _) => ch.y1,
                    ),
                    StackedColumnSeries<ChartData, String>(
                      name: "Empréstimos",
                      color: const Color.fromARGB(255, 255, 191, 87),
                      dataSource: chartData,
                      xValueMapper: (ChartData ch, _) => ch.x,
                      yValueMapper: (ChartData ch, _) => ch.y2,
                    ),
                    StackedColumnSeries<ChartData, String>(
                        name: "Manutenção",
                        color: const Color.fromARGB(255, 255, 112, 122),
                        dataSource: chartData,
                        xValueMapper: (ChartData ch, _) => ch.x,
                        yValueMapper: (ChartData ch, _) => ch.y3),
                    StackedColumnSeries<ChartData, String>(
                        name: "Desinfecção",
                        color: const Color.fromARGB(255, 116, 239, 255),
                        dataSource: chartData,
                        xValueMapper: (ChartData ch, _) => ch.x,
                        yValueMapper: (ChartData ch, _) => ch.y4),
                  ],
                );
            }
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
