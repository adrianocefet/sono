import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/user_model.dart';
import '../controle_estoque/widgets/item_equipamento.dart';
import '../controle_estoque/widgets/pesquisa_equipamento.dart';
import '../perfis/perfil_equipamento/adicionar_equipamento.dart';

class ListaDeEquipamentos extends StatefulWidget {
  const ListaDeEquipamentos({Key? key}) : super(key: key);

  @override
  State<ListaDeEquipamentos> createState() => _ListaDeEquipamentosState();
}

class _ListaDeEquipamentosState extends State<ListaDeEquipamentos> {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('equipamentos')
            .where('hospital',isEqualTo: model.hospital)
            .where('status',isEqualTo: Constantes.status3[model.status])
            .where('tipo',isEqualTo: model.tipo.emStringSnakeCase)
            .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      title: Text(model.tipo.emString),
                      centerTitle: true,
                    ),
                    body: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                default:
            return Scaffold(
              appBar: AppBar(
                title: Text('${model.tipo.emString} (${snapshot.data!.docs.length})'),
                actions: [
                  IconButton(onPressed: (){
                    showSearch(
                      context: context,
                      delegate: PesquisaEquipamento(tipo: model.tipo,status: model.status),);
                  }, icon: const Icon(Icons.search))
                ],
                backgroundColor: Constantes.corAzulEscuroPrincipal,
              ),
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color.fromARGB(255, 194, 195, 255),Colors.white],
                    stops: [0,0.4]
                    )
                ),
                child:
                snapshot.data!.docs.isNotEmpty?
                  ListView(
                    children:snapshot.data!.docs.map(
                          (DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal:8.0),
                              child: ItemEquipamento(
                                id:document.id
                              ),
                            );
                          },
                        ).toList(), 
                  ):
                  Padding(
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
                          const SizedBox(height: 16.0,),
                          Text(
                            'Nenhum(a) ${model.tipo.emString.toLowerCase()} ${Constantes.status3[model.status].toLowerCase()}!',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Constantes.corAzulEscuroPrincipal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              floatingActionButton: FloatingActionButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdicionarEquipamento(tipo:model.tipo)),
                    );
                },
                child: Icon(Icons.add),
                backgroundColor: Constantes.corAzulEscuroPrincipal,
                ),
            );
          }}
        );
        }
        );
  }
  
}