import 'package:flutter/material.dart';
import 'package:sono/utils/models/pergunta.dart';

class RespostaDropdownCadastros extends StatefulWidget {
  final Pergunta pergunta;
  final int? autoPreencher;
  const RespostaDropdownCadastros(
      {required this.pergunta, this.autoPreencher, Key? key})
      : super(key: key);

  @override
  _RespostaDropdownState createState() => _RespostaDropdownState();
}

class _RespostaDropdownState extends State<RespostaDropdownCadastros> {
  int? _escolha;
  List<String> _opcoes = [];

  @override
  Widget build(BuildContext context) {
    _opcoes = widget.pergunta.opcoes!;
    _escolha = _escolha ?? widget.autoPreencher;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ButtonTheme(
            alignedDropdown: true,
            height: double.minPositive,
            child: DropdownButtonFormField(
              iconEnabledColor: Theme.of(context).primaryColor,
              menuMaxHeight: 400,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                label: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    widget.pergunta.enunciado,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                isCollapsed: true,
                contentPadding: const EdgeInsets.all(2),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.2,
                  ),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.2,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColorLight,
                    width: 1.2,
                  ),
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              value: _escolha != null ? _opcoes[_escolha!] : null,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Theme.of(context).primaryColor,
              ),
              isExpanded: true,
              isDense: false,
              onChanged: (String? value) {
                setState(() {
                  _escolha = _opcoes.indexOf(value.toString());
                  widget.pergunta.setResposta(_escolha ?? 0);
                });
              },
              onSaved: (value) {
                widget.pergunta.setResposta(_escolha);
              },
              validator: (value) => widget.pergunta.validador != null
                  ? _escolha != null
                      ? null
                      : "Dado obrigatório"
                  : null,
              items: _opcoes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
