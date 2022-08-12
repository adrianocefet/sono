import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/perfis/perfil_equipamento/tela_equipamento.dart';

import '../../../../utils/models/equipamento.dart';
import '../../../../utils/models/user_model.dart';

class relatorioEspecifico extends StatefulWidget {
  const relatorioEspecifico({Key? key}) : super(key: key);

  @override
  State<relatorioEspecifico> createState() => _relatorioEspecificoState();
}

class _relatorioEspecificoState extends State<relatorioEspecifico> {
  int? indexOrdenarColuna;
  bool ordemCrescente = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView(
                scrollDirection: Axis.vertical,
                children:[construirTabela()]
                ),
           );
  }
  
  Widget construirTabela() {
    final colunas = ['Tipo','Fabricante','Equipamento','Status'];
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) =>
       StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('equipamentos').where('hospital',isEqualTo: model.hospital).snapshots(),
        builder: (context, snapshot,){
          switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                return DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => Constantes.corAzulEscuroSecundario),
                  decoration: BoxDecoration(),
                  dataRowHeight: 90,
                  columnSpacing: 5,
                  horizontalMargin: 1,
                  sortAscending: ordemCrescente,
                  sortColumnIndex: indexOrdenarColuna,
                  dataTextStyle: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 10,
                    color: Colors.black
                  ),
                  columns: pegarColunas(colunas), 
                  rows: pegarLinhas(context, snapshot.data!.docs),
                  );}
        }
      ),
    );
  }
  
  List<DataColumn> pegarColunas(List<String> colunas) => colunas.map((String coluna) => 
  DataColumn(
    label: Expanded(
      child: Center(
          child:
            Text(coluna,style: TextStyle(fontSize: 10)),
      ),
    ),
    //onSort: ordenar,
    ))
    
    .toList();
  
  List<DataRow> pegarLinhas(BuildContext context, List<DocumentSnapshot> snapshot) => snapshot.map((DocumentSnapshot data) {
    Map<String, dynamic> dadosEquipamento = data.data()! as Map<String, dynamic>;
    dadosEquipamento["id"]=data.id;
    Equipamento equipamento = Equipamento.porMap(dadosEquipamento);
    final celulas = [equipamento.tipo,equipamento.fabricante,equipamento.nome,equipamento.status.emString];

    return DataRow(
      cells: pegarCelulas(celulas),
      onLongPress:(){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>TelaEquipamento(id:equipamento.id)));
      } 
      );
  }).toList();
  
  List<DataCell> pegarCelulas(List<Object?> celulas) => celulas.map((data) => DataCell(Center(child: ConstrainedBox(constraints: BoxConstraints(minWidth: 10,maxWidth: 60),child: Text('$data',textAlign: TextAlign.center,softWrap: true,overflow: TextOverflow.visible,))))).toList();

  /* void ordenar(int indexColuna, bool crescente) {
    if(indexColuna==0){
      equipamentos.sort((equipamento1, equipamento2) =>
        comparararString(crescente, equipamento1.fabricante, equipamento2.fabricante));
    }
    else if(indexColuna==1){
      equipamentos.sort((equipamento1, equipamento2) =>
        comparararString(crescente, equipamento1.nome, equipamento2.nome));
    }
    else if(indexColuna==2){
      equipamentos.sort((equipamento1, equipamento2) =>
        comparararString(crescente, equipamento1.status.emString, equipamento2.status.emString));
    }
    else if(indexColuna==3){
      equipamentos.sort((equipamento1, equipamento2) =>
        comparararString(crescente, equipamento1.tamanho, equipamento2.tamanho));
    }
    else if(indexColuna==4){
      equipamentos.sort((equipamento1, equipamento2) =>
        comparararString(crescente, equipamento1.inicioStatus, equipamento2.inicioStatus));
    }
    setState(() {
      this.indexOrdenarColuna = indexColuna;
      this.ordemCrescente = crescente;
    });
  } */
  
  int comparararString(bool crescente, String string1, String string2) {
    return crescente ? string1.compareTo(string2) : string2.compareTo(string1);
  }
}