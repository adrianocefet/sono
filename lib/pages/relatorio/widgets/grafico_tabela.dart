import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sono/utils/models/usuario.dart';

import '../../../constants/constants.dart';
import '../../../utils/models/equipamento.dart';
import '../relatorio_geral.dart';

class GraficoTabela extends StatelessWidget {
  final Usuario model;
  final List<QueryDocumentSnapshot<Object?>> documentos;
  const GraficoTabela({Key? key, required this.model, required this.documentos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Table(
          border: TableBorder.all(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          columnWidths: const {
            0: FractionColumnWidth(0.25),
            1: FractionColumnWidth(0.15),
            2: FractionColumnWidth(0.15),
            3: FractionColumnWidth(0.15),
            4: FractionColumnWidth(0.15),
            5: FractionColumnWidth(0.15),
          },
          children: [
            mostrarlinhas([
              '',
              'Disponível',
              'Emprestado',
              'Manutenção',
              'Desinfecção',
              'Total'
            ], topo: true),
            for (var tipo in TipoEquipamento.values)
              mostrarlinhas([
                tipo.emString,
                for (var status in StatusDoEquipamento.values.getRange(0, 4))
                  calcularQuantidade(documentos, tipo, status.emString,
                      model.instituicao.emString,
                      emString: true),
                calcularQuantidade(
                    documentos,
                    tipo,
                    StatusDoEquipamento.disponivel.emString,
                    model.instituicao.emString,
                    total: true,
                    emString: true),
              ]),
          ],
        ),
      ),
    );
  }
}

TableRow mostrarlinhas(List<String> celula, {bool topo = false}) => TableRow(
      decoration: BoxDecoration(
          color: topo ? Constantes.corAzulEscuroSecundario : Colors.white,
          borderRadius: topo
              ? const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))
              : null),
      children: celula.map((celula) {
        final estilo = TextStyle(
            fontWeight: topo ? FontWeight.bold : FontWeight.w300, fontSize: 15);
        final IconData icone;
        switch (celula) {
          case 'Disponível':
            icone = StatusDoEquipamento.disponivel.icone2;
            break;
          case 'Emprestado':
            icone = StatusDoEquipamento.emprestado.icone2;
            break;

          case 'Manutenção':
            icone = StatusDoEquipamento.manutencao.icone2;
            break;

          case 'Desinfecção':
            icone = StatusDoEquipamento.desinfeccao.icone2;
            break;
          default:
            icone = Icons.add;
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: topo && celula != '' && celula != 'Total'
                  ? Icon(icone)
                  : Text(
                      celula,
                      style: estilo,
                    )),
        );
      }).toList(),
    );
