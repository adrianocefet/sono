import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(identificador).where('hospital',isEqualTo: hospital).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasError){
            return Text('Erro: ${snapshot.error}');
          }
          if(!snapshot.hasData){
            return Text('Erro: sem informação');
          }else{
            if(snapshot.data!.docs.where((QueryDocumentSnapshot<Object?> element) => element['Nome'].toString().toLowerCase().contains(query.toLowerCase())
            ).isEmpty){
              return Center(child: Text("Nenhum ${identificador} encontrado"),);
            }else{
              return ListView(
                children: [
                  ...snapshot.data!.docs.where((QueryDocumentSnapshot<Object?> element) => element['Nome'].toString().toLowerCase().contains(query.toLowerCase())).map((QueryDocumentSnapshot<Object?> data){
                    final String title = data.get("Nome");
                    return ListTile(
                          onTap: (){
                            print(data["Nome"]);
                          },
                          trailing:Icon(Icons.tag_faces_rounded, size: 40,),
                          title: Text(title),
                    );
                  }
                  )],
              );
            }}

          

        }
      );
  }

  @override
  Widget buildSuggestions(BuildContext context){
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
                   return ListView(
                      children: [
                        ...snapshot.data!.docs.where((QueryDocumentSnapshot<Object?> element) => element['Nome'].toString().toLowerCase().contains(query.toLowerCase())).map((QueryDocumentSnapshot<Object?> data){
                          final String title = data.get("Nome");
                          return ListTile(
                                onTap: (){},
                                trailing: Icon(Icons.tag_faces_rounded, size: 40,),
                                title: Text(title),
                          );
                        }
                        )],
                    );
                }
          }
        },
      );
  }
}