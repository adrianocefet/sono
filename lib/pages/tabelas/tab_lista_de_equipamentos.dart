import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/usuario.dart';
import '../../utils/models/paciente.dart';
import '../controle_estoque/widgets/item_equipamento.dart';
import '../controle_estoque/widgets/pesquisa_equipamento.dart';
import '../perfis/perfil_equipamento/adicionar_equipamento.dart';
import '../perfis/perfil_equipamento/equipamento_controller.dart';

class ListaDeEquipamentos extends StatefulWidget {
  final Paciente? pacientePreEscolhido;
  final ControllerPerfilClinicoEquipamento controller;
  const ListaDeEquipamentos(
      {required this.controller, Key? key, this.pacientePreEscolhido})
      : super(key: key);

  @override
  State<ListaDeEquipamentos> createState() => _ListaDeEquipamentosState();
}

class _ListaDeEquipamentosState extends State<ListaDeEquipamentos> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Usuario>(builder: (context, child, model) {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('equipamentos')
              .where('hospital', isEqualTo: model.instituicao.emString)
              .where('status', isEqualTo: widget.controller.status.emString)
              .where('tipo',
                  isEqualTo: widget.controller.tipo.emStringSnakeCase)
              .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    title: Text(widget.controller.tipo.emString),
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
                List<DocumentSnapshot> docsEquipamentos = snapshot.data!.docs;
                return Scaffold(
                    appBar: AppBar(
                      title: Text(
                          '${widget.controller.tipo.emString} (${snapshot.data!.docs.length})'),
                      actions: [
                        IconButton(
                            onPressed: () {
                              showSearch(
                                context: context,
                                delegate: PesquisaEquipamento(
                                    controller: widget.controller,
                                    tipo: widget.controller.tipo,
                                    status: widget.controller.status),
                              );
                            },
                            icon: const Icon(Icons.search))
                      ],
                      backgroundColor: Constantes.corAzulEscuroPrincipal,
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
                      child: snapshot.data!.docs.isNotEmpty
                          ? ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> data =
                                    docsEquipamentos[index].data()!
                                        as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: ItemEquipamento(
                                      controller: widget.controller,
                                      id: docsEquipamentos[index].id,
                                      pacientePreEscolhido:
                                          widget.pacientePreEscolhido),
                                );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.cancel,
                                      size: 80.0,
                                      color: Constantes.corAzulEscuroPrincipal,
                                    ),
                                    const SizedBox(
                                      height: 16.0,
                                    ),
                                    Text(
                                      'Nenhum(a) ${widget.controller.tipo.emString.toLowerCase()} ${widget.controller.status.emString.toLowerCase()}!',
                                      style: const TextStyle(
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
                            ),
                    ),
                    floatingActionButton: widget.pacientePreEscolhido == null
                        ? Visibility(
                            visible: [
                              PerfilUsuario.mestre,
                              PerfilUsuario.dispensacao,
                              PerfilUsuario.vigilancia
                            ].contains(model.perfil),
                            child: FloatingActionButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AdicionarEquipamento(
                                              tipo: widget.controller.tipo)),
                                );
                              },
                              child: const Icon(Icons.add),
                              backgroundColor:
                                  Constantes.corAzulEscuroPrincipal,
                            ),
                          )
                        : null);
            }
          });
    });
  }
}
