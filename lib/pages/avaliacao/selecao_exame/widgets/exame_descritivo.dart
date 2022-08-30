import 'package:flutter/material.dart';
import 'package:sono/pages/avaliacao/avaliacao_controller.dart';

import '../../exame.dart';

class ExameDescritivo extends StatelessWidget {
  final Exame exame;
  final ControllerAvaliacao controllerAvaliacao;
  final TextEditingController _textEditingController = TextEditingController();
  ExameDescritivo(
      {Key? key, required this.exame, required this.controllerAvaliacao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _textEditingController.text =
        controllerAvaliacao.obterExamePorTipoGeral(exame.tipo).respostas[
                exame.tipo == TipoExame.conclusao
                    ? 'conclusao'
                    : 'dados_complementares'] ??
            '';
    return Container(
      margin: const EdgeInsets.only(top: 20),
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
              controller: _textEditingController,
              minLines: 7,
              maxLines: 7,
              decoration: InputDecoration(
                labelText: exame.tipo == TipoExame.conclusao
                    ? 'Digite aqui os resultados da avaliação'
                    : 'Digite aqui suas observações',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.2,
                  ),
                ),
                labelStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              validator: (value) =>
                  exame.tipo == TipoExame.conclusao && value!.isEmpty
                      ? 'Preenchimento obrigatório'
                      : null,
              onEditingComplete: () {
                exame.respostas[exame.tipo == TipoExame.conclusao
                    ? 'conclusao'
                    : 'dados_complementares'] = _textEditingController.text;
                controllerAvaliacao.salvarExame(exame);
              },
              onSaved: (value) {
                exame.respostas[exame.tipo == TipoExame.conclusao
                    ? 'conclusao'
                    : 'dados_complementares'] = _textEditingController.text;
                controllerAvaliacao.salvarExame(exame);
              },
            ),
          ),
        ],
      ),
    );
  }
}
