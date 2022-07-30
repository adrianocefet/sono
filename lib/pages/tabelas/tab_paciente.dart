import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/cadastros/cadastro_paciente/cadastro_paciente.dart';
import 'package:sono/pages/perfis/perfil_paciente/perfil_clinico_paciente.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sono/widgets/foto_de_perfil.dart';

import '../../widgets/pesquisa.dart';
import '../pagina_inicial/widgets/widgets_drawer.dart';

class TabelaDePacientes extends StatefulWidget {
  final PageController pageController;
  const TabelaDePacientes({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  _TabelaDePacientesState createState() => _TabelaDePacientesState();
}

class _TabelaDePacientesState extends State<TabelaDePacientes> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, usuario) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Pacientes"),
          centerTitle: true,
          backgroundColor: Colors.red,
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
        drawer: CustomDrawer(widget.pageController),
        drawerEnableOpenDragGesture: true,
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('pacientes')
                  .where('hospitais_vinculados',
                      arrayContains: usuario.hospital)
                  .snapshots(),
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
                      return GridView(
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        scrollDirection: Axis.vertical,
                        children: snapshot.data!.docs.reversed.map(
                            (DocumentSnapshot<Map<String, dynamic>> document) {
                          Map<String, dynamic> data = document.data()!;
                          return FotoDePerfil.paciente(
                            data['url_foto_de_perfil'] ?? usuario.semimagem,
                            data['nome_completo'] ?? 'sem nome',
                            document.id,
                          );
                        }).toList(),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                }
              },
            )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
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
    });
  }

  Widget geraImagemDoPaciente(String imagem, String texto, String id) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PerfilClinicoPaciente(id)));
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.network(
            imagem,
            width: MediaQuery.of(context).size.width * 0.25,
            height: MediaQuery.of(context).size.width * 0.25,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 3,
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              texto,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.03,
              ),
            ),
          )
        ],
      ),
    );
  }
}
