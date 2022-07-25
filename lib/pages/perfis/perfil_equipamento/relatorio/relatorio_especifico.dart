import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/perfis/perfil_equipamento/relatorio/DadosTeste/EquipamentosCriados.dart';
import 'package:sono/pages/perfis/perfil_equipamento/relatorio/DadosTeste/classeEquipamentoteste.dart';
import 'package:sono/pages/perfis/perfil_equipamento/tela_equipamento.dart';

class relatorioEspecifico extends StatefulWidget {
  const relatorioEspecifico({Key? key}) : super(key: key);

  @override
  State<relatorioEspecifico> createState() => _relatorioEspecificoState();
}

class _relatorioEspecificoState extends State<relatorioEspecifico> {
  late List<Equipamento> equipamentos;
  int? indexOrdenarColuna;
  bool ordemCrescente = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.equipamentos = List.of(todosEquipamentos);
  }
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
    final colunas = ['Tipo','Equipamento','Status','Tamanho','Data'];
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
      rows: pegarLinhas(equipamentos),
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
    onSort: ordenar,
    ))
    
    .toList();
  
  List<DataRow> pegarLinhas(List<Equipamento> equipamentos) => equipamentos.map((Equipamento equipamento) {
    final celulas = [equipamento.tipo,equipamento.nome,equipamento.status,equipamento.tamanho,equipamento.inicioStatus];

    return DataRow(
      cells: pegarCelulas(celulas),
      onLongPress:(){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>TelaEquipamento(equipamento:equipamento)));
      }
      );
  }).toList();
  
  List<DataCell> pegarCelulas(List<String> celulas) => celulas.map((data) => DataCell(Center(child: ConstrainedBox(constraints: BoxConstraints(minWidth: 10,maxWidth: 60),child: Text('$data',softWrap: true,overflow: TextOverflow.visible,))))).toList();

  void ordenar(int indexColuna, bool crescente) {
    if(indexColuna==0){
      equipamentos.sort((equipamento1, equipamento2) =>
        comparararString(crescente, equipamento1.tipo, equipamento2.tipo));
    }
    else if(indexColuna==1){
      equipamentos.sort((equipamento1, equipamento2) =>
        comparararString(crescente, equipamento1.nome, equipamento2.nome));
    }
    else if(indexColuna==2){
      equipamentos.sort((equipamento1, equipamento2) =>
        comparararString(crescente, equipamento1.status, equipamento2.status));
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
  }
  
  int comparararString(bool crescente, String string1, String string2) {
    return crescente ? string1.compareTo(string2) : string2.compareTo(string1);
  }
}