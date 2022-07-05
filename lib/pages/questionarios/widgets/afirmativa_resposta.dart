import 'package:flutter/material.dart';
import 'package:simple_rich_text/simple_rich_text.dart';
import 'package:sono/utils/models/pergunta.dart';

import '../../../constants/constants.dart';

class RespostaAfirmativa extends StatefulWidget {
  final Pergunta pergunta;
  final Future<void> Function() passarPagina;

  const RespostaAfirmativa({
    Key? key,
    required this.pergunta,
    required this.passarPagina,
  }) : super(key: key);

  @override
  _RespostaAfirmativaState createState() => _RespostaAfirmativaState();
}

class _RespostaAfirmativaState extends State<RespostaAfirmativa> {
  @override
  Widget build(BuildContext context) {
    bool respostaInvalida = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: false,
          child: TextFormField(
            validator: (value) => widget.pergunta.respostaExtenso == null
                ? () {
                    setState(() {
                      respostaInvalida = true;
                    });
                    return "Pergunta obrigatória.";
                  }()
                : null,
          ),
          maintainState: true,
        ),
        Container(
          color: Constantes.corAzulEscuroSecundario,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.15,
            minWidth: double.infinity,
          ),
          padding: const EdgeInsets.all(8.0),
          alignment: AlignmentDirectional.center,
          child: SimpleRichText(
            widget.pergunta.enunciado,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: Constantes.fontSizeEnunciados,
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: [
              _Botao(
                pergunta: widget.pergunta,
                value: 1,
                parentSetState: () => () async {
                  setState(() {});
                  await widget.passarPagina();
                }(),
              ),
              const SizedBox(
                height: 20,
              ),
              _Botao(
                pergunta: widget.pergunta,
                value: 0,
                parentSetState: () => () async {
                  setState(() {});
                  await widget.passarPagina();
                }(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Botao extends StatefulWidget {
  final int value;
  final Pergunta pergunta;
  final Function parentSetState;
  const _Botao({
    Key? key,
    required this.pergunta,
    required this.value,
    required this.parentSetState,
  }) : super(key: key);

  @override
  State<_Botao> createState() => _BotaoState();
}

class _BotaoState extends State<_Botao> {
  @override
  Widget build(BuildContext context) {
    int value = widget.value;
    int? groupValue = widget.pergunta.resposta;
    return ElevatedButton(
      child: widget.value == 1
          ? const Text(
              "Sim",
              style: TextStyle(
                color: Colors.black,
              ),
            )
          : const Text(
              "Não",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        primary: groupValue == value
            ? value == 0
                ? Colors.green
                : Colors.red
            : Constantes.corCinzaPrincipal,
      ),
      onPressed: () {
        widget.pergunta.setResposta(value);
        widget.pergunta.setRespostaExtenso(value == 1 ? "Sim" : "Não");
        widget.parentSetState();
      },
    );
  }
}
