import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sono/widgets/foto_de_perfil.dart';

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
                      actions: [
                        IconButton(
                          onPressed: () {
                            showSearch(
                                context: context,
                                delegate: CustomSearchDelegate(),);
                          },
                          icon: const Icon(Icons.search),
                        ),
                    ],
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

class CustomSearchDelegate extends SearchDelegate {
  List<String> Equipamentos = [
    'Máscara facial',
    'CPAP System One',
    'Máscara Nasal Pico Philips',
    'Resmed S9 AutoSet',
    'Máscara Pillow AirFit30i ResMed',
    'AutoCPAP G1 BMC',
    'Máscara Nasal N5 BMC',
    'Máscara Facial F&P Simplus',
    'Máscara Nasal N5 Média BMC',
    'Máscara Nasal AirFit30i ResMed',
    'Máscara Nasal Wisp',
    'Cpap Dreamstation Auto Philips Respironics'
  ];

  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var equipamento in Equipamentos) {
      if (equipamento.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(equipamento);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var equipamento in Equipamentos) {
      if (equipamento.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(equipamento);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}