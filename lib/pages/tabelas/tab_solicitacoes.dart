import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/socilitacoes/solicitacoes_painel.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/solicitacao.dart';

import '../../utils/models/usuario.dart';
import '../pagina_inicial/widgets/widgets_drawer.dart';

class TabelaDeSolicitacoes extends StatefulWidget {
  final PageController pageController;
  const TabelaDeSolicitacoes({required this.pageController, Key? key})
      : super(key: key);

  @override
  State<TabelaDeSolicitacoes> createState() => _TabelaDeSolicitacoesState();
}

class _TabelaDeSolicitacoesState extends State<TabelaDeSolicitacoes> {
  final PanelController panelController = PanelController();
  List<Confirmacao> filtroStatus = [Confirmacao.pendente];
  List<Solicitacao> solicitacoes = [];
  List<Solicitacao> filtradas = [];
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Usuario>(
      builder: (context, child, model) => StreamBuilder<
              QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('solicitacoes')
              .where('hospital', isEqualTo: model.instituicao.emString)
              .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Scaffold(
                  drawer: FuncionalidadesDrawer(widget.pageController),
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    title: const Text('Solicitações'),
                    centerTitle: true,
                  ),
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
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Constantes.corAzulEscuroPrincipal,
                      ),
                    ),
                  ),
                );
              default:
                filtradas = solicitacoesFiltradas(snapshot.data!.docs)
                  ..sort(((Solicitacao a, Solicitacao b) =>
                      a.dataDaSolicitacao.compareTo(b.dataDaSolicitacao)));
                return Scaffold(
                  drawer: FuncionalidadesDrawer(widget.pageController),
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    title: const Text('Solicitações'),
                    centerTitle: true,
                  ),
                  body: SlidingUpPanel(
                    controller: panelController,
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
                        child: filtradas.isNotEmpty
                            ? SingleChildScrollView(
                                padding: const EdgeInsets.only(bottom: 140),
                                child: Column(
                                  children: filtradas.reversed
                                      .map((Solicitacao solicitacao) {
                                    return SolicitacoesPainel(
                                        key: ValueKey(solicitacao.id),
                                        idSolicitacao: solicitacao.id);
                                  }).toList(),
                                ))
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.cancel,
                                        size: 80.0,
                                        color:
                                            Constantes.corAzulEscuroPrincipal,
                                      ),
                                      SizedBox(
                                        height: 16.0,
                                      ),
                                      Text(
                                        'Nenhuma solicitação encontrada!',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Constantes.corAzulEscuroPrincipal,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                    minHeight: 40,
                    maxHeight: 250,
                    panel: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (panelController.isPanelClosed) {
                              panelController.open();
                            } else {
                              panelController.close();
                            }
                          },
                          child: Container(
                            height: 40,
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: Text(
                              'Filtros',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: Confirmacao.values
                                  .map((status) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: CheckboxListTile(
                                            title: Text(status.emString),
                                            dense: true,
                                            activeColor:
                                                Theme.of(context).primaryColor,
                                            value:
                                                filtroStatus.contains(status),
                                            onChanged: (ativo) {
                                              setState(() {
                                                atualizarFiltro(
                                                    status: status,
                                                    ativado: ativo!);
                                              });
                                            }),
                                      ))
                                  .toList()),
                        ),
                      ],
                    ),
                  ),
                );
            }
          }),
    );
  }

  void atualizarFiltro({required Confirmacao status, required bool ativado}) {
    if (ativado) {
      filtroStatus.add(status);
    } else {
      filtroStatus.remove(status);
    }
  }

  List<Solicitacao> solicitacoesFiltradas(List<DocumentSnapshot> document) {
    solicitacoes = document.map((DocumentSnapshot data) {
      DocumentSnapshot<Map<String, dynamic>> dados =
          data as DocumentSnapshot<Map<String, dynamic>>;
      Solicitacao solicitacao = Solicitacao.porDocumentSnapshot(dados);
      return solicitacao;
    }).toList();
    List<Solicitacao> output = solicitacoes.reversed.toList();

    return output.where((o) => filtroStatus.contains(o.confirmacao)).toList();
  }
}
