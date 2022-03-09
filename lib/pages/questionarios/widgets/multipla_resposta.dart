import 'package:flutter/material.dart';
import 'package:sono/utils/models/pergunta.dart';
import '../../../../../constants/constants.dart';
import 'enunciado_respostas.dart';

class RespostaMultipla extends StatefulWidget {
  final Pergunta pergunta;
  final Future<void> Function() passarPagina;

  const RespostaMultipla({
    Key? key,
    required this.pergunta,
    required this.passarPagina,
  }) : super(key: key);

  @override
  _RespostaMultiplaState createState() => _RespostaMultiplaState();
}

class _RespostaMultiplaState extends State<RespostaMultipla> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: false,
            child: TextFormField(
              validator: (indice) => widget.pergunta.resposta == null
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
                        await widget.passarPagina();
                      }(),
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
    int peso = widget.pergunta.pesos[indice];
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
      onPressed: () {
        widget.pergunta.setRespostaExtenso(label);
        widget.pergunta.setResposta(peso);
        widget.parentSetState();
      },
    );
  }
}
