import 'package:flutter/material.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';

class RespostaExtensoCadastro extends StatefulWidget {
  final Pergunta pergunta;
  final Paciente? paciente;
  final bool? numerico;
  final Color? corTexto;
  final Color? corDominio;
  final dynamic autoPreencher;
  final TextEditingController _extensoController = TextEditingController();
  late final bool _enabled;

  RespostaExtensoCadastro({
    required this.pergunta,
    this.paciente,
    this.numerico,
    this.corTexto = Colors.black,
    this.corDominio = Colors.blue,
    this.autoPreencher,
    Key? key,
  }) : super(key: key) {
    _extensoController.text =
        autoPreencher == null ? "" : autoPreencher.toString();
    _enabled = true;
  }

  @override
  _RespostaExtensoState createState() => _RespostaExtensoState();
}

class _RespostaExtensoState extends State<RespostaExtensoCadastro> {
  Paciente? paciente;

  @override
  Widget build(BuildContext context) {
    if (widget.paciente != null || widget.autoPreencher != null) {
      paciente = widget.paciente;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            enabled: widget._enabled,
            controller: widget._extensoController,
            validator: widget.pergunta.validador,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            minLines: 1,
            maxLines: 3,
            keyboardType: widget.numerico ?? false
                ? TextInputType.number
                : TextInputType.text,
            decoration: InputDecoration(
              suffix: widget.pergunta.unidade == null
                  ? null
                  : Text(
                      widget.pergunta.unidade!,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
              labelText: widget.pergunta.enunciado,
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor, width: 1.2),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.2),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.2),
              ),
              labelStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 14,
              ),
            ),
            onChanged: (value) {
              print(value);
            },
            onSaved: (String? value) {
              setState(
                () {
                  widget.pergunta.setRespostaExtenso(
                    value!.isEmpty
                        ? null
                        : (value.trim()).replaceAll(
                            RegExp(' +'),
                            ' ',
                          ),
                  );
                  widget.pergunta.setRespostaNumerica(value.isEmpty
                      ? null
                      : int.tryParse(value.trim()) ??
                          double.tryParse(value.replaceAll(',', '.').trim()));
                },
              );
            },
          )
        ],
      ),
    );
  }
}
