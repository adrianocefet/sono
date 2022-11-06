import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/relatorio/widgets/grafico_percentual.dart';
import 'package:sono/pages/relatorio/widgets/grafico_tabela.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/usuario.dart';
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

                return documentos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.cancel,
                              size: 80.0,
                              color: Constantes.corAzulEscuroPrincipal,
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              'Nenhum equipamento encontrado nesse hospital!',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Constantes.corAzulEscuroPrincipal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : Scaffold(
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
                              GraficoTabela(
                                  model: model, documentos: documentos),
                              for (var tipo in TipoEquipamento.values)
                                GraficoPercentual(
                                  tipo: tipo,
                                  model: model,
                                  documentos: documentos,
                                )
                            ],
                          ),
                        ),
                      );
            }
          }),
    );
  }
}

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
