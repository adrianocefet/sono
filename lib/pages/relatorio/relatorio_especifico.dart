import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/perfis/perfil_equipamento/tela_equipamento.dart';
import '../../utils/models/equipamento.dart';
import '../../utils/models/user_model.dart';

class RelatorioEspecifico extends StatefulWidget {
  const RelatorioEspecifico({Key? key}) : super(key: key);

  @override
  State<RelatorioEspecifico> createState() => _RelatorioEspecificoState();
}

class _RelatorioEspecificoState extends State<RelatorioEspecifico> {
  int? indexOrdenarColuna;
  bool ordemCrescente = false;
  List<Equipamento> equipamentos=[];
  bool inicializou=false;
  @override
  Widget build(BuildContext context) {
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
                inicializou==false?
                equipamentos = pegarEquipamentos(snapshot.data!.docs):null;
                inicializou=true;
                return Scaffold(
                  body:ListView(
                            scrollDirection: Axis.vertical,
                            children:[construirTabela()]
                            ),
                      );}}));}

  
  Widget construirTabela() {
    final colunas = ['Tipo','Equipamento','Status','Tamanho','Data de expedição'];
      return DataTable(
        headingRowColor: MaterialStateColor.resolveWith((states) => Constantes.corAzulEscuroSecundario),
        headingRowHeight: 60,
        dataRowHeight: 90,
        columnSpacing: 5,
        horizontalMargin: 1,
        sortAscending: ordemCrescente,
        sortColumnIndex: indexOrdenarColuna,
        dataTextStyle: const TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 10,
          color: Colors.black
        ),
        columns: pegarColunas(colunas), 
        rows: pegarLinhas(context, equipamentos),
        );}
  
  List<DataColumn> pegarColunas(List<String> colunas) => colunas.map((String coluna) => 
  DataColumn(
    label: Expanded(
      child: Center(
          child:
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 10,maxWidth: 65),
              child: Text(coluna,style: const TextStyle(fontSize: 10),softWrap: true,overflow: TextOverflow.visible,textAlign: TextAlign.center,)),
      ),
    ),
    onSort: ordenar,
    ))
    
    .toList();
  
  List<DataRow> pegarLinhas(BuildContext context, List<Equipamento> equipamentos) => equipamentos.map((Equipamento equipamento) {
    final celulas = [equipamento.tipo.emString,equipamento.nome,equipamento.status.emStringMaiuscula,equipamento.tamanho??'-',equipamento.dataDeExpedicaoEmString];

    return DataRow(
      cells: pegarCelulas(celulas),
      onLongPress:(){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>TelaEquipamento(id:equipamento.id)));
        inicializou=false;
      } 
      );
  }).toList();

  List<Equipamento> pegarEquipamentos(List<DocumentSnapshot> snapshot) => snapshot.map((DocumentSnapshot data) {
    Map<String, dynamic> dadosEquipamento = data.data()! as Map<String, dynamic>;
    dadosEquipamento["id"]=data.id;
    Equipamento equipamento = Equipamento.porMap(dadosEquipamento);
    return equipamento;
  }).toList();
  
  List<DataCell> pegarCelulas(List<String> celulas) => celulas.map((data) => DataCell(Center(child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 10,maxWidth: 60),child: Text('$data',textAlign: TextAlign.center,softWrap: true,overflow: TextOverflow.visible,))))).toList();

  void ordenar(int indexColuna, bool crescente) {
    if(indexColuna==0){
      equipamentos.sort((equipamento1, equipamento2) =>
        comparararString(crescente, equipamento1.tipo.emString, equipamento2.tipo.emString));
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
        comparararString(crescente, equipamento1.tamanho??'-', equipamento2.tamanho??'-'));
    }
    else if(indexColuna==4){
      equipamentos.sort((equipamento1, equipamento2) =>
        comparararString(crescente, equipamento1.dataDeExpedicaoEmString, equipamento2.dataDeExpedicaoEmString));
    }
    setState(() {
      indexOrdenarColuna = indexColuna;
      ordemCrescente = crescente;
    });
  } 
  
  int comparararString(bool crescente, String string1, String string2) {
    return crescente ? string1.compareTo(string2) : string2.compareTo(string1);
  }
}