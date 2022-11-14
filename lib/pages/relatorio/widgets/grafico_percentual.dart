import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constants/constants.dart';
import '../../../utils/models/equipamento.dart';
import '../../../utils/models/usuario.dart';
import '../relatorio_geral.dart';

class GraficoPercentual extends StatelessWidget {
  final Usuario model;
  final List<QueryDocumentSnapshot<Object?>> documentos;
  final TipoEquipamento tipo;
  const GraficoPercentual(
      {Key? key,
      required this.tipo,
      required this.model,
      required this.documentos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1.4),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(9),
              topRight: Radius.circular(9),
            )),
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
              height: 30,
              child: Text(
                'Percentual ${tipo.emString.toLowerCase()}(%)',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            SfCircularChart(
              palette: [
                Constantes.corVerdeClaroPrincipal,
                const Color.fromARGB(255, 255, 191, 87),
                const Color.fromARGB(255, 255, 112, 122),
                StatusDoEquipamento.desinfeccao.cor
              ],
              backgroundColor: Colors.white,
              legend: Legend(
                  position: LegendPosition.bottom,
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic)),
              series: <CircularSeries>[
                PieSeries<GDPData, String>(
                    animationDuration: 0,
                    dataSource: [
                      for (var status
                          in StatusDoEquipamento.values.getRange(0, 4))
                        GDPData(
                            status.emStringMaiuscula,
                            (calcularQuantidade(
                                        documentos,
                                        tipo,
                                        status.emString,
                                        model.instituicao.emString) *
                                    100 /
                                    (calcularQuantidade(
                                                documentos,
                                                tipo,
                                                status.emString,
                                                model.instituicao.emString,
                                                total: true) ==
                                            0
                                        ? 1
                                        : calcularQuantidade(
                                            documentos,
                                            tipo,
                                            status.emString,
                                            model.instituicao.emString,
                                            total: true)))
                                .toStringAsFixed(2)),
                    ],
                    xValueMapper: (GDPData data, _) => data.tipo,
                    yValueMapper: (GDPData data, _) =>
                        double.tryParse(data.qntd),
                    dataLabelSettings: const DataLabelSettings(
                        textStyle: TextStyle(fontWeight: FontWeight.w300),
                        overflowMode: OverflowMode.shift,
                        isVisible: true,
                        angle: 1))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GDPData {
  GDPData(this.tipo, this.qntd);

  String tipo;
  String qntd;
}
