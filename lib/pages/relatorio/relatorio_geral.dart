import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/usuario.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../constants/constants.dart';

class RelatorioGeral extends StatefulWidget {
  const RelatorioGeral({Key? key}) : super(key: key);

  @override
  State<RelatorioGeral> createState() => _RelatorioGeralState();
}

class _RelatorioGeralState extends State<RelatorioGeral> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Usuario>(
      builder: (context, child, model) => StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('equipamentos')
              .where('hospital', isEqualTo: model.instituicao.emString)
              .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              default:
                List<QueryDocumentSnapshot<Object?>> documentos =
                    snapshot.data!.docs;
                return Scaffold(
                  body: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Color.fromARGB(255, 194, 195, 255),
                          Colors.white
                        ],
                            stops: [
                          0,
                          0.4
                        ])),
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Table(
                              border: TableBorder.all(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              columnWidths: const {
                                0: FractionColumnWidth(0.25),
                                1: FractionColumnWidth(0.15),
                                2: FractionColumnWidth(0.15),
                                3: FractionColumnWidth(0.15),
                                4: FractionColumnWidth(0.15),
                                5: FractionColumnWidth(0.15),
                              },
                              children: [
                                mostrarlinhas([
                                  '',
                                  'Disponível',
                                  'Emprestado',
                                  'Manutenção',
                                  'Desinfecção',
                                  'Total'
                                ], topo: true),
                                for (var tipo in TipoEquipamento.values)
                                  mostrarlinhas([
                                    tipo.emString,
                                    for (var status in StatusDoEquipamento
                                        .values
                                        .getRange(0, 4))
                                      calcularQuantidade(
                                          documentos,
                                          tipo,
                                          status.emString,
                                          model.instituicao.emString,
                                          emString: true),
                                    calcularQuantidade(
                                        documentos,
                                        tipo,
                                        StatusDoEquipamento.disponivel.emString,
                                        model.instituicao.emString,
                                        total: true,
                                        emString: true),
                                  ]),
                              ],
                            ),
                          ),
                        ),
                        for (var tipo in TipoEquipamento.values)
                          Padding(
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
                                    height: 25,
                                    child: Text(
                                      'Percentual ${tipo.emString.toLowerCase()}(%)',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
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
                                        overflowMode:
                                            LegendItemOverflowMode.wrap,
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontStyle: FontStyle.italic)),
                                    series: <CircularSeries>[
                                      PieSeries<GDPData, String>(
                                          dataSource: [
                                            for (var status
                                                in StatusDoEquipamento.values
                                                    .getRange(0, 4))
                                              GDPData(
                                                  status.emStringMaiuscula,
                                                  (calcularQuantidade(
                                                              documentos,
                                                              tipo,
                                                              status.emString,
                                                              model.instituicao
                                                                  .emString) *
                                                          100 /
                                                          (calcularQuantidade(
                                                                      documentos,
                                                                      tipo,
                                                                      status
                                                                          .emString,
                                                                      model
                                                                          .instituicao
                                                                          .emString,
                                                                      total:
                                                                          true) ==
                                                                  0
                                                              ? 1
                                                              : calcularQuantidade(
                                                                  documentos,
                                                                  tipo,
                                                                  status
                                                                      .emString,
                                                                  model
                                                                      .instituicao
                                                                      .emString,
                                                                  total: true)))
                                                      .toStringAsFixed(2)),
                                          ],
                                          xValueMapper: (GDPData data, _) =>
                                              data.tipo,
                                          yValueMapper: (GDPData data, _) =>
                                              double.tryParse(data.qntd),
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  textStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300),
                                                  overflowMode:
                                                      OverflowMode.shift,
                                                  isVisible: true,
                                                  angle: 1))
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
            }
          }),
    );
  }

  TableRow mostrarlinhas(List<String> celula, {bool topo = false}) => TableRow(
        decoration: BoxDecoration(
            color: topo ? Constantes.corAzulEscuroSecundario : Colors.white,
            borderRadius: topo
                ? const BorderRadius.only(
                    topLeft: Radius.circular(10), topRight: Radius.circular(10))
                : null),
        children: celula.map((celula) {
          final estilo = TextStyle(
              fontWeight: topo ? FontWeight.bold : FontWeight.w300,
              fontSize: 15);
          final IconData icone;
          switch (celula) {
            case 'Disponível':
              icone = StatusDoEquipamento.disponivel.icone2;
              break;
            case 'Emprestado':
              icone = StatusDoEquipamento.emprestado.icone2;
              break;

            case 'Manutenção':
              icone = StatusDoEquipamento.manutencao.icone2;
              break;

            case 'Desinfecção':
              icone = StatusDoEquipamento.desinfeccao.icone2;
              break;
            default:
              icone = Icons.add;
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: topo && celula != '' && celula != 'Total'
                    ? Icon(icone)
                    : Text(
                        celula,
                        style: estilo,
                      )),
          );
        }).toList(),
      );

  calcularQuantidade(List<QueryDocumentSnapshot<Object?>> equipamentos,
      TipoEquipamento tipo, String status, String hospital,
      {bool total = false, bool emString = false}) {
    int contador;
    if (total) {
      contador = equipamentos
          .where((element) =>
              element['tipo'].toString().contains(tipo.emStringSnakeCase) &&
              element['hospital'].toString().contains(hospital) &&
              !element['status']
                  .toString()
                  .contains(StatusDoEquipamento.concedido.emString))
          .length;
    } else {
      contador = equipamentos
          .where((element) =>
              element['tipo'].toString().contains(tipo.emStringSnakeCase) &&
              element['status'].toString().contains(status) &&
              element['hospital'].toString().contains(hospital))
          .length;
    }

    return emString ? contador.toString() : contador;
  }
}

class GDPData {
  GDPData(this.tipo, this.qntd);

  String tipo;
  String qntd;
}
