import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/cadastros/cadastro_paciente/cadastro_paciente.dart';
import 'package:sono/pages/cadastros/cadastro_usuario/cadastro_usuario.dart';
import 'package:sono/pages/tabelas/widgets/item_usuario.dart';
import 'package:sono/utils/models/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sono/utils/services/firebase.dart';

import '../../widgets/pesquisa_de_pacientes.dart';
import '../pagina_inicial/widgets/widgets_drawer.dart';

class ListaDeUsuarios extends StatelessWidget {
  final PageController pageController;
  const ListaDeUsuarios({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Usuario>(
      builder: (context, child, usuario) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Usuários"),
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
          drawer: CustomDrawer(pageController),
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
              stream: FirebaseService().streamUsuarios(),
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
                          docsUsuarios = snapshot.data!.docs;
                      return Scrollbar(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            Usuario usuario = Usuario.porDocumentSnapshot(
                              docsUsuarios[index],
                            );
                            return Column(
                              children: [
                                SizedBox(
                                  height: index == 0 ? 10 : 0,
                                ),
                                ItemUsuario(usuario: usuario),
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
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).focusColor,
            child: const Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CadastroDeUsuario(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
