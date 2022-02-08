import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/models/pergunta.dart';

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
    _escolha = _escolha ?? widget.autoPreencher;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            widget.pergunta.enunciado,
            style: const TextStyle(
              fontSize: Constants.fontSizeEnunciados,
            ),
          ),
        ),
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField(
              hint: const Text('Selecione uma opção'),
              menuMaxHeight: 400,
              decoration: const InputDecoration.collapsed(
                hintText: "",
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
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
                  ? (value) {}
                  : (value) => _escolha != null ? null : 'Dado obrigatório.',
              items: _opcoes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
      ]),
    );
  }
}
