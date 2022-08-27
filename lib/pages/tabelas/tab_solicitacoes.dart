import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/socilitacoes/solicitacoes_painel.dart';
import 'package:sono/utils/models/equipamento.dart';

import '../../utils/models/user_model.dart';
import '../pagina_inicial/widgets/widgets_drawer.dart';

class TabelaDeSolicitacoes extends StatefulWidget {
  final PageController pageController;
  const TabelaDeSolicitacoes({required this.pageController,Key? key}) : super(key: key);

  @override
  State<TabelaDeSolicitacoes> createState() => _TabelaDeSolicitacoesState();
}

class _TabelaDeSolicitacoesState extends State<TabelaDeSolicitacoes> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) => 
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('solicitacoes').where('hospital',isEqualTo: model.hospital).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Scaffold(
                      drawer: CustomDrawer(widget.pageController),
                      appBar: AppBar(
                        backgroundColor: Theme.of(context).primaryColor,
                        title: const Text('Solicitações'),
                        centerTitle: true,
                      ),
                      body: const Center(
                        child: CircularProgressIndicator(color: Constantes.corAzulEscuroPrincipal,),
                      ),
                    );
                  default:
                    return Scaffold(
                      drawer: CustomDrawer(widget.pageController),
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
                            colors: [Color.fromARGB(255, 194, 195, 255),Colors.white],
                            stops: [0,0.4]
                            )
                          ),
                        child: snapshot.data!.docs.isNotEmpty?
                            ListView(
                              children:
                                snapshot.data!.docs.map(
                                  (DocumentSnapshot document){
                                    return SolicitacoesPainel(idSolicitacao: document.id);
                                  }
                                ).toList(),
                                
                            ):
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.cancel,
                                      size: 80.0,
                                      color: Constantes.corAzulEscuroPrincipal,
                                    ),
                                    SizedBox(height: 16.0,),
                                    Text(
                                      'Nenhuma solicitação encontrada!',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Constantes.corAzulEscuroPrincipal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ),
                    );
        }}
      ),
    );
  }
}