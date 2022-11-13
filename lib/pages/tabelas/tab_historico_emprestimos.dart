import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/painel_historico.dart';
import 'package:sono/utils/models/solicitacao.dart';
import '../../utils/models/paciente.dart';
import '../../utils/models/usuario.dart';

class HistoricoEmprestimos extends StatefulWidget {
  final Paciente? pacientePreEscolhido;
  final String equipamento;
  const HistoricoEmprestimos(
      {required this.equipamento, this.pacientePreEscolhido, Key? key})
      : super(key: key);

  @override
  State<HistoricoEmprestimos> createState() => _HistoricoEmprestimosState();
}

class _HistoricoEmprestimosState extends State<HistoricoEmprestimos> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Usuario>(
      builder: (context, child, model) => StreamBuilder<
              QuerySnapshot<Map<String, dynamic>>>(
          stream: widget.pacientePreEscolhido == null
              ? FirebaseFirestore.instance
                  .collection('solicitacoes')
                  .where('hospital', isEqualTo: model.instituicao.emString)
                  .where('confirmacao',
                      isEqualTo: Confirmacao.confirmado.emString.toLowerCase())
                  .where('equipamento', isEqualTo: widget.equipamento)
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection('solicitacoes')
                  .where('hospital', isEqualTo: model.instituicao.emString)
                  .where('confirmacao',
                      isEqualTo: Confirmacao.confirmado.emString.toLowerCase())
                  .where('equipamento', isEqualTo: widget.equipamento)
                  .where('paciente', isEqualTo: widget.pacientePreEscolhido!.id)
                  .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    title: const Text('Histórico'),
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
                List<Solicitacao> docsSolicitacoes = snapshot.data!.docs
                    .map((DocumentSnapshot data) {
                  DocumentSnapshot<Map<String, dynamic>> dados =
                      data as DocumentSnapshot<Map<String, dynamic>>;
                  Solicitacao solicitacao =
                      Solicitacao.porDocumentSnapshot(dados);
                  return solicitacao;
                }).toList()
                  ..sort(((Solicitacao a, Solicitacao b) =>
                      a.dataDeResposta!.compareTo(b.dataDeResposta!)));
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    title: const Text('Histórico'),
                    centerTitle: true,
                  ),
                  body: Container(
                      height: MediaQuery.of(context).size.height,
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
                      child: docsSolicitacoes.isNotEmpty
                          ? ListView.builder(
                              itemCount: docsSolicitacoes.length,
                              padding: const EdgeInsets.only(bottom: 140),
                              itemBuilder: (context, index) {
                                int reversedIndex =
                                    docsSolicitacoes.length - 1 - index;

                                return PainelHistorico(
                                    idSolicitacao:
                                        docsSolicitacoes[reversedIndex].id);
                              },
                            )
                          : Padding(
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
                                    SizedBox(
                                      height: 16.0,
                                    ),
                                    Text(
                                      'Nenhum empréstimo ou devolução encontrada!',
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
                );
            }
          }),
    );
  }
}
