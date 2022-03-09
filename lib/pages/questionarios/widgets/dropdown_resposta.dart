import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/models/pergunta.dart';

import 'enunciado_respostas.dart';

class RespostaDropdown extends StatefulWidget {
  final Pergunta pergunta;
  final int? autoPreencher;
  final Function()? notificarParent;
  const RespostaDropdown(
      {required this.pergunta,
      this.autoPreencher,
      this.notificarParent,
      Key? key})
      : super(key: key);

  @override
  _RespostaDropdownState createState() => _RespostaDropdownState();
}

class _RespostaDropdownState extends State<RespostaDropdown> {
  int? _escolha;
  List<String> _opcoes = [];

  @override
  Widget build(BuildContext context) {
    _opcoes = widget.pergunta.opcoes!;
    _escolha = _escolha ?? widget.autoPreencher ?? widget.pergunta.resposta;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EnunciadoRespostasDeQuestionarios(enunciado: widget.pergunta.enunciado),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 50),
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField(
              hint: const Text(
                'Selecione uma opção',
                style: TextStyle(
                  color: Constantes.corAzulEscuroPrincipal,
                ),
              ),
              menuMaxHeight: 400,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
              ),
              style: const TextStyle(
                color: Constantes.corAzulEscuroPrincipal,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              value: _escolha != null ? _opcoes[_escolha!] : null,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.black,
              ),
              isExpanded: true,
              isDense: false,
              onChanged: (String? value) {
                setState(() {
                  _escolha = _opcoes.indexOf(value.toString());
                  widget.pergunta.setResposta(_escolha ?? 0);
                });
                widget.notificarParent!();
              },
              onSaved: (value) {
                widget.pergunta.setResposta(_escolha);
              },
              validator: widget.pergunta.codigo == 'renda_familiar_mensal'
                  ? (value) => null
                  : (value) => _escolha != null ? null : 'Dado obrigatório.',
              items: _opcoes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
