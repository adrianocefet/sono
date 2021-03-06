import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/_lixo/screen_paciente.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sono/widgets/foto_de_perfil.dart';

import '../pagina_inicial/widgets/widgets_drawer.dart';
import '../../utils/dialogs/adicionar_paciente_dialog.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pacientes"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      drawer: CustomDrawer(widget.pageController),
      drawerEnableOpenDragGesture: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Paciente')
                  .where('Hospital', isEqualTo: model.hospital)
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
                      children: snapshot.data!.docs.reversed
                          .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return FotoDePerfil.paciente(
                          data['Foto'] ?? model.semimagem,
                          data['Nome'] ?? 'sem nome',
                          document.id,
                        );
                      }).toList(),
                    );
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {
          mostrarDialogAdicionarPaciente(context);
        },
      ),
    );
  }

  Widget geraImagemDoPaciente(String imagem, String texto, String id) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ScreenPaciente(id)));
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
