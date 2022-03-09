import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';

import 'enunciado_respostas.dart';

class RespostaExtensoQuestionario extends StatefulWidget {
  final Pergunta pergunta;
  final Paciente? paciente;
  final bool? numerico;
  final Color? corDominio;
  final String? autoPreencher;
  final TextEditingController _extensoController = TextEditingController();
  final bool enabled;

  RespostaExtensoQuestionario({
    required this.pergunta,
    this.paciente,
    this.numerico,
    this.corDominio = Colors.blue,
    this.autoPreencher,
    this.enabled = true,
    Key? key,
  }) : super(key: key) {
    _extensoController.text = autoPreencher ?? pergunta.respostaExtenso ?? "";
  }

  @override
  _RespostaExtensoState createState() => _RespostaExtensoState();
}

class _RespostaExtensoState extends State<RespostaExtensoQuestionario> {
  Paciente? paciente;

  @override
  Widget build(BuildContext context) {
    if (widget.paciente != null || widget.autoPreencher != null) {
      paciente = widget.paciente;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EnunciadoRespostasDeQuestionarios(
          enunciado: widget.pergunta.enunciado,
        ),
        const SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 50),
          child: TextFormField(
            enabled: widget.enabled,
            controller: widget._extensoController,
            minLines: 1,
            maxLines: 3,
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
              label: const Text(
                "Digite a resposta",
                style: TextStyle(fontSize: 20),
              ),
              labelStyle: const TextStyle(
                color: Constantes.corAzulEscuroPrincipal,
                fontSize: 16,
              ),
              suffixIcon:
                  widget.enabled && widget._extensoController.text.isNotEmpty
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
            onChanged: (String? value) {
              if (value!.length <= 1) {
                setState(() {});
              }
            },
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            onSaved: (String? value) {
              setState(
                () {
                  widget.pergunta
                      .setRespostaExtenso(value!.isEmpty ? null : value.trim());
                },
              );
            },
            validator: widget.pergunta.validador,
          ),
        )
      ],
    );
  }
}
