import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';

class RespostaExtensoCadastro extends StatefulWidget {
  final Pergunta pergunta;
  final Paciente? paciente;
  final bool? numerico;
  final Color? corTexto;
  final Color? corDominio;
  final String? autoPreencher;
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
    _extensoController.text = autoPreencher!;
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
          Text(
            widget.pergunta.enunciado,
            style: const TextStyle(
              fontSize: Constantes.fontSizeEnunciados,
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          TextFormField(
            enabled: widget._enabled,
            controller: widget._extensoController,
            minLines: 1,
            maxLines: 4,
            textCapitalization:
                ['F1', 'F2', 'cid'].contains(widget.pergunta.codigo)
                    ? TextCapitalization.characters
                    : ['nome_completo'].contains(widget.pergunta.codigo)
                        ? TextCapitalization.words
                        : TextCapitalization.none,
            keyboardType:
                ['A3', 'H1', 'H2', 'H3'].contains(widget.pergunta.codigo) ||
                        (widget.numerico ?? false)
                    ? TextInputType.number
                    : TextInputType.text,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelStyle: const TextStyle(
                color: Constantes.corAzulEscuroSecundario,
                fontSize: 14,
              ),
              suffixIcon:
                  widget._enabled && widget._extensoController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                widget._extensoController.clear();
                              },
                            );
                          },
                        )
                      : null,
            ),
            onChanged: (value) {
              if (value.length <= 1) {
                setState(() {});
              }
            },
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            onSaved: (String? value) {
              setState(
                () {
                  widget.pergunta.setRespostaExtenso(
                    (value!.trim()).replaceAll(
                      RegExp(' +'),
                      ' ',
                    ),
                  );
                },
              );
            },
            validator: widget.pergunta.validador,
          )
        ],
      ),
    );
  }
}
