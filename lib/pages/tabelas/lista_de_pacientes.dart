import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/cadastros/cadastro_paciente/cadastro_paciente.dart';
import 'package:sono/pages/perfis/perfil_paciente/perfil_clinico_paciente.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sono/utils/services/firebase.dart';
import 'package:sono/widgets/foto_de_perfil.dart';

import '../../widgets/pesquisa.dart';
import '../pagina_inicial/widgets/widgets_drawer.dart';

class ListaDePacientes extends StatelessWidget {
  final PageController pageController;
  const ListaDePacientes({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
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
                    delegate: BarraDePesquisa('Paciente', usuario.hospital),
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
              stream: FirebaseService()
                  .streamPacientesPorHospital(usuario.hospital),
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
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          Paciente paciente = Paciente.porDocumentSnapshot(
                              docsPacientes[index]);
                          return ListTile(
                            title: Text(paciente.nomeCompleto),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PerfilClinicoPaciente(paciente.id),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: snapshot.data!.docs.length,
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
