import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/models/pergunta.dart';
import '../../../widgets/enunciado_respostas.dart';

class MultiplaCustomizadaPittsburg extends StatefulWidget {
  final Pergunta pergunta;
  final Future<void> Function() passarPagina;
  final Color? corSelecionado;

  const MultiplaCustomizadaPittsburg({
    Key? key,
    required this.pergunta,
    required this.passarPagina,
    this.corSelecionado,
  }) : super(key: key);

  @override
  _MultiplaCustomizadaPittsburgState createState() =>
      _MultiplaCustomizadaPittsburgState();
}

class _MultiplaCustomizadaPittsburgState extends State<MultiplaCustomizadaPittsburg> {
  ValueNotifier<bool> opcoesAtivadas = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          EnunciadoRespostasDeQuestionarios(
            enunciado: widget.pergunta.enunciado,
          ),
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextFormField(
              onSaved: (value) {
                widget.pergunta.setRespostaExtenso(value);
              } ,
              onChanged: (value) {
                if (value != "") {
                  opcoesAtivadas.value = true;
                } else {
                  opcoesAtivadas.value = false;
                }
              },
              validator: (value) =>
                  value != "" && widget.pergunta.respostaNumerica == null
                      ? "Por favor, marque uma opção."
                      : null,
              decoration: const InputDecoration(
                label: Text(
                  "Digite a resposta",
                  style: TextStyle(fontSize: 20),
                ),
                labelStyle: TextStyle(
                  color: Constantes.corAzulEscuroPrincipal,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: ValueListenableBuilder(
                valueListenable: opcoesAtivadas,
                builder: (context, bool opcoesAtivadas, _) {
                  return Column(
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
                            corSelecionado: widget.corSelecionado,
                            botaoAtivado: opcoesAtivadas,
                          ),
                        ),
                    ],
                  );
                }),
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
  final bool botaoAtivado;

  const _Botao({
    Key? key,
    required this.pergunta,
    required this.indice,
    required this.parentSetState,
    this.corSelecionado,
    required this.botaoAtivado,
  }) : super(key: key);

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
      onPressed: widget.botaoAtivado
          ? () {
              widget.pergunta.setRespostaNumerica(peso);
              widget.parentSetState();
            }
          : null,
    );
  }
}
