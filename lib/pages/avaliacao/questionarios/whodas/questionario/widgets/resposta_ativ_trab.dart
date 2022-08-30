import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/models/pergunta.dart';
import '../../../widgets/enunciado_respostas.dart';

class RespostaAtividadeTrabalho extends StatefulWidget {
  final Pergunta pergunta;
  final Future<void> Function() passarPagina;
  final GlobalKey<FormState> formKey;
  final Color? corSelecionado;

  const RespostaAtividadeTrabalho({
    Key? key,
    required this.pergunta,
    required this.passarPagina,
    required this.formKey,
    this.corSelecionado,
  }) : super(key: key);

  @override
  _RespostaAtividadeTrabalhoState createState() =>
      _RespostaAtividadeTrabalhoState();
}

class _RespostaAtividadeTrabalhoState extends State<RespostaAtividadeTrabalho> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: false,
            child: TextFormField(
              validator: (indice) => widget.pergunta.respostaNumerica == null
                  ? "Pergunta obrigatória."
                  : null,
            ),
            maintainState: true,
          ),
          EnunciadoRespostasDeQuestionarios(
            enunciado: widget.pergunta.enunciado,
          ),
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
              children: [
                for (int i = 0; i < widget.pergunta.opcoes!.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: _Botao(
                      pergunta: widget.pergunta,
                      indice: i,
                      parentSetState: () => () async {
                        setState(() {});
                        if (i != widget.pergunta.opcoes!.length - 1) {
                          await widget.passarPagina();
                        }
                      }(),
                      corSelecionado: widget.corSelecionado,
                    ),
                  ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  height: widget.pergunta.respostaExtenso ==
                          "Outros (especifique)"
                      ? null
                      : 0,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) =>
                            value != '' ? null : "Dado obrigatório.",
                        minLines: 1,
                        maxLines: 4,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                            color: Constantes.corAzulEscuroSecundario,
                            fontSize: 14,
                          ),
                        ),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        onSaved: (value) =>
                            widget.pergunta.setRespostaExtenso(value),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (widget.formKey.currentState!.validate()) {
                            widget.formKey.currentState!.save();
                            await widget.passarPagina();
                          }
                        },
                        child: const Text("Confirmar resposta"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          primary: Colors.blue,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Botao extends StatefulWidget {
  final int indice;
  final Pergunta pergunta;
  final Function parentSetState;
  final Color? corSelecionado;

  const _Botao(
      {Key? key,
      required this.pergunta,
      required this.indice,
      required this.parentSetState,
      this.corSelecionado})
      : super(key: key);

  @override
  State<_Botao> createState() => _BotaoState();
}

class _BotaoState extends State<_Botao> {
  @override
  Widget build(BuildContext context) {
    int indice = widget.indice;
    int peso =
        widget.pergunta.pesos == null ? 0 : widget.pergunta.pesos![indice];
    String label = widget.pergunta.opcoes![indice];
    bool estaSelecionado = widget.pergunta.respostaExtenso == label;

    return ElevatedButton(
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        primary: estaSelecionado
            ? widget.corSelecionado ?? (peso == 0 ? Colors.green : Colors.red)
            : Constantes.corCinzaPrincipal,
      ),
      onPressed: () {
        widget.pergunta.setRespostaExtenso(label);
        widget.pergunta.setRespostaNumerica(peso);
        widget.parentSetState();
      },
    );
  }
}
