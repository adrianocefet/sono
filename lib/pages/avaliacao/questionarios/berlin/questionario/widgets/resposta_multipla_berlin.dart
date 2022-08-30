import 'package:flutter/material.dart';
import 'package:simple_rich_text/simple_rich_text.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/models/pergunta.dart';

bool _condicionaisHabilitadas = false;

class RespostaMultiplaBerlin extends StatefulWidget {
  final Pergunta pergunta;
  final Future<void> Function() passarPagina;

  const RespostaMultiplaBerlin({
    Key? key,
    required this.pergunta,
    required this.passarPagina,
  }) : super(key: key);

  @override
  _RespostaMultiplaBerlinState createState() => _RespostaMultiplaBerlinState();
}

class _RespostaMultiplaBerlinState extends State<RespostaMultiplaBerlin> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _condicionaisHabilitadas = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
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
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
              children: [
                for (int i = 0; i <= 1; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: _Botao(
                      pergunta: widget.pergunta,
                      indice: i,
                      parentSetState: () => () async {
                        setState(() {});
                        if (i == 0) {
                          _condicionaisHabilitadas = true;
                        } else if (i == 1) {
                          _condicionaisHabilitadas = false;
                          await widget.passarPagina();
                        } else {
                          await widget.passarPagina();
                        }
                      }(),
                    ),
                  ),
                AnimatedOpacity(
                  opacity: _condicionaisHabilitadas ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    children: [
                      const Divider(
                        thickness: 4,
                        color: Constantes.corPrincipalQuestionarios,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Quantas vezes isto ocorreu?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      for (int i = 2; i < widget.pergunta.opcoes!.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: _Botao(
                            pergunta: widget.pergunta,
                            indice: i,
                            parentSetState: () => () async {
                              setState(() {});
                              await widget.passarPagina();
                            }(),
                          ),
                        ),
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
  const _Botao({
    Key? key,
    required this.pergunta,
    required this.indice,
    required this.parentSetState,
  }) : super(key: key);

  @override
  State<_Botao> createState() => _BotaoState();
}

class _BotaoState extends State<_Botao> {
  @override
  Widget build(BuildContext context) {
    int indice = widget.indice;
    int peso = widget.pergunta.pesos![indice];
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
            ? peso == 0
                ? Colors.green
                : Colors.red
            : Constantes.corCinzaPrincipal,
      ),
      onPressed: _condicionaisHabilitadas && label == "Sim"
          ? null
          : () {
              if (label != "Sim") {
                widget.pergunta.setRespostaExtenso(label);
                widget.pergunta.setRespostaNumerica(peso);
              }
              widget.parentSetState();
            },
    );
  }
}
