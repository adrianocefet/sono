import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/cadastros/cadastro_paciente/cadastro_paciente.dart';
import 'package:sono/pages/tabelas/widgets/item_paciente.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sono/utils/services/firebase.dart';
import '../../utils/models/equipamento.dart';
import '../../utils/models/solicitacao.dart';
import '../../widgets/pesquisa_de_pacientes.dart';
import '../pagina_inicial/widgets/widgets_drawer.dart';

class ListaDePacientes extends StatelessWidget {
  final PageController? pageController;
  final Equipamento? equipamentoPreEscolhido;
  final TipoSolicitacao? tipoSolicitacao;
  const ListaDePacientes(
      {Key? key,
      this.pageController,
      this.equipamentoPreEscolhido,
      this.tipoSolicitacao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Usuario>(
      builder: (context, child, usuario) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Pacientes"),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: PesquisaDePacientes(
                      'Paciente',
                      usuario.instituicao.emString,
                    ),
                  );
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          drawer: equipamentoPreEscolhido == null
              ? FuncionalidadesDrawer(pageController!)
              : null,
          drawerEnableOpenDragGesture: true,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromRGBO(165, 166, 246, 1.0), Colors.white],
                stops: [0, 0.2],
              ),
            ),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseService()
                  .streamPacientesPorHospital(usuario.instituicao.emString),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Text(
                      "ERRO DE CONEXÃO",
                    );
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    if (snapshot.hasData) {
                      List<DocumentSnapshot<Map<String, dynamic>>>
                          docsPacientes = snapshot.data!.docs;
                      return Scrollbar(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            Paciente paciente = Paciente.porDocumentSnapshot(
                              docsPacientes[index],
                            );
                            return Column(
                              children: [
                                SizedBox(
                                  height: index == 0 ? 10 : 0,
                                ),
                                ScopedModel<Usuario>(
                                  model: usuario,
                                  child: ItemPaciente(
                                    paciente: paciente,
                                    equipamentoPreEscolhido:
                                        equipamentoPreEscolhido,
                                    tipoSolicitacao: tipoSolicitacao,
                                  ),
                                ),
                              ],
                            );
                          },
                          itemCount: snapshot.data!.docs.length,
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                }
              },
            ),
          ),
          floatingActionButton: usuario.perfil == PerfilUsuario.vigilancia ||
                  equipamentoPreEscolhido != null
              ? null
              : FloatingActionButton(
                  backgroundColor: Theme.of(context).focusColor,
                  child: const Icon(
                    Icons.add,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CadastroPaciente(),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
