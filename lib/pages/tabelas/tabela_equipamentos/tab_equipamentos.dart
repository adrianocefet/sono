import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/perfis/perfil_equipamento/screen_equipamentos.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sono/widgets/foto_de_perfil.dart';

bool inicializa = false;

class Equipamento extends StatefulWidget {
  const Equipamento({Key? key}) : super(key: key);

  @override
  _EquipamentoState createState() => _EquipamentoState();
}

class _EquipamentoState extends State<Equipamento> {
  @override
  void initState() {
    super.initState();
    inicializa = true;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        inicializa
            ? {model.Equipamento = 'Equipamento', inicializa = false}
            : null;
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Equipamento')
              .where('Hospital', isEqualTo: model.hospital)
              .where('Equipamento', isEqualTo: model.Equipamento)
              .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                return GridView(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  scrollDirection: Axis.vertical,
                  children: snapshot.data!.docs.reversed.map(
                    (DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return FotoDePerfil.equipamento(
                        data['Foto'] ?? model.semimagem,
                        data['Nome'] ?? 'sem nome',
                        document.id,
                      );
                    },
                  ).toList(),
                );
            }
          },
        );
      },
    );
  }

  Widget _fazGrid(String imagem, String nome, String id) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return InkWell(
          onTap: () {
            model.Equipamento == 'Equipamento'
                ? setState(() {
                    model.Equipamento = nome;
                  })
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScreenEquipamento(id),
                    ),
                  );
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
              Text(
                nome,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
