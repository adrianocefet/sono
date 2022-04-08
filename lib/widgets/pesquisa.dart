import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:sono/utils/services/firebase.dart';

import 'foto_de_perfil.dart';

class BarraDePesquisa extends SearchDelegate {
  final String identificador;
  final String hospital;
  BarraDePesquisa(this.identificador,this.hospital);

  static const String _stringPaciente = 'Paciente';
  static const String _stringEquipamento = "Equipamento";

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
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection(identificador).where('hospital',isEqualTo: hospital).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError){
                return Text('Erro: ${snapshot.error}');
              }
              if(snapshot.data!.docs.where((QueryDocumentSnapshot<Object?> element) => element['Nome'].toString().toLowerCase().contains(query.toLowerCase())
              ).isEmpty){
                return Center(child: Text("Nenhuma Resposta encontrada"),);
              }else{
                return GridView(
                            padding: EdgeInsets.only(top:15),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            scrollDirection: Axis.vertical,
                            children: [
                            ...snapshot.data!.docs.where((QueryDocumentSnapshot<Object?> element) => element['Nome'].toString().toLowerCase().contains(query.toLowerCase())).map((QueryDocumentSnapshot<Object?> data){
                              return FotoDePerfil.paciente(
                                data['Foto'] ?? model.semimagem,
                                data['Nome'] ?? 'sem nome',
                                data.id,
                              );
                            }).toList()]
                            );
              }}
        );}
    );
  }

  @override
  Widget buildSuggestions(BuildContext context){
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection(identificador).where('Hospital',isEqualTo: hospital).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasError){
              return Text('Error: ${snapshot.error}');
            }
    
            switch(snapshot.connectionState){
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if(snapshot.data!.docs.where((QueryDocumentSnapshot<Object?> element) => element['Nome'].toString().toLowerCase().contains(query.toLowerCase())
                  ).isEmpty){
                    return Center(child: Text("Nenhuma Resposta encontrada"),);
                  }else{
                     return GridView(
                            padding: EdgeInsets.only(top:15),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            scrollDirection: Axis.vertical,
                            children: [
                            ...snapshot.data!.docs.where((QueryDocumentSnapshot<Object?> element) => element['Nome'].toString().toLowerCase().contains(query.toLowerCase())).map((QueryDocumentSnapshot<Object?> data){
                              return FotoDePerfil.paciente(
                                data['Foto'] ?? model.semimagem,
                                data['Nome'] ?? 'sem nome',
                                data.id,
                              );
                            }).toList()]
                            );
                  }
            }
          },
        );}
    );
  }
}