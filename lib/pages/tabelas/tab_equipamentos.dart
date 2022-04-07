import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sono/utils/services/firebase.dart';
import 'package:sono/widgets/foto_de_perfil.dart';
import 'package:sono/widgets/pesquisa.dart';

import '../../widgets/widgets_botao_menu.dart';
import '../pagina_inicial/widgets/widgets_drawer.dart';
import '../perfis/perfil_equipamento/screen_equipamentos.dart';

bool inicializa = false;

class TabelaDeEquipamentos extends StatefulWidget {
  final PageController pageController;
  const TabelaDeEquipamentos({required this.pageController, Key? key})
      : super(key: key);

  @override
  _EquipamentoState createState() => _EquipamentoState();
}

class _EquipamentoState extends State<TabelaDeEquipamentos> {
  @override
  void initState() {
    super.initState();
    inicializa = true;
  }

  recarregarTabela() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        inicializa
            ? {model.equipamento = 'Equipamento', inicializa = false}
            : null;
        return WillPopScope(
          onWillPop: () async {
            if (model.equipamento != 'Equipamento') {
              setState(() {
                model.equipamento = 'Equipamento';
              });
            }

            return false;
          },
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Equipamento')
                .where('Hospital', isEqualTo: model.hospital)
                .where('Equipamento', isEqualTo: model.equipamento)
                .snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(model.equipamento),
                      centerTitle: true,
                    ),
                    body: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                default:
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(model.equipamento),
                      centerTitle: true,
                      /* actions: [
                        IconButton(
                          onPressed: () {
                               showSearch(
                                context: context,
                                delegate: BarraDePesquisa('Equipamento',model.hospital),);   
                          },
                          icon: const Icon(Icons.search),
                        ),
                    ], */
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView(
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
                          (DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return FotoDePerfil.equipamento(
                              data['Foto'] ?? model.semimagem,
                              data['Nome'] ?? 'sem nome',
                              document.id,
                              recarregarParent: recarregarTabela,
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    drawer: CustomDrawer(widget.pageController),
                    drawerEnableOpenDragGesture: true,
                    floatingActionButton: model.equipamento != "Equipamento"
                        ? const BotaoMenu()
                        : null,
                  );
              }
            },
          ),
        );
      },
    );
  }
}

void escolherOpcao(context, String editarID) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Escolha uma opção:'),
      content: SizedBox(
          width: 100,
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScreenEquipamento(editarID),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    Text('Editar'),
                  ],
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  FirebaseFirestore.instance
                      .collection('Equipamento')
                      .doc(editarID)
                      .delete();
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.highlight_remove,
                      color: Colors.black,
                    ),
                    Text('Remover'),
                  ],
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //mainAxisSize: MainAxisSize.max,
                  children: const [
                    Icon(
                      Icons.cancel,
                      color: Colors.black,
                    ),
                    Text('Cancelar'),
                  ],
                ),
              ),
            ],
          )),
    ),
  );
}