import 'package:flutter/material.dart';
import 'package:sono/pages/avaliacao/avaliacao.dart';
import 'package:sono/pages/avaliacao/exame.dart';

class ExameDescritivoDetalhe extends StatelessWidget {
  final Exame exame;
  final Avaliacao avaliacao;
  final TextEditingController _textEditingController = TextEditingController();
  ExameDescritivoDetalhe(
      {Key? key, required this.exame, required this.avaliacao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _textEditingController.text =
        avaliacao.obterExamePorTipoGeral(exame.tipo).respostas[
                exame.tipo == TipoExame.conclusao
                    ? 'conclusao'
                    : 'dados_complementares'] ??
            '';
    return Visibility(
      visible: avaliacao.examesRealizados
          .where((element) => [
                TipoExame.conclusao,
                TipoExame.dadosComplementares
              ].contains(element.tipo))
          .isNotEmpty,
      child: Container(
        margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
        padding: const EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width * 0.92,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            width: 2,
            color: Theme.of(context).primaryColor,
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(17),
                  topRight: Radius.circular(17),
                ),
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: Text(
                  exame.nome,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: TextFormField(
                enabled: false,
                controller: _textEditingController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
