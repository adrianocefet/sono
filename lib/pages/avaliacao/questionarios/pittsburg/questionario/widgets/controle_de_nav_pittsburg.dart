import 'package:flutter/material.dart';
import 'package:sono/pages/avaliacao/questionarios/pittsburg/questionario/pittsburg_controller.dart';
import 'package:sono/pages/avaliacao/questionarios/pittsburg/resultado/resultado_pittsburg_view.dart';
import 'package:sono/utils/models/pergunta.dart';
import '../../resultado/resultado_pittsburg.dart';

class ControleDeNavegacaoPittsburg extends StatefulWidget {
  final int paginaAtual;
  final PittsburgController controller;
  final Pergunta? perguntaAtual;
  final void Function() questionarioSetState;

  const ControleDeNavegacaoPittsburg({
    Key? key,
    required this.controller,
    required this.paginaAtual,
    required this.perguntaAtual,
    required this.questionarioSetState,
  }) : super(key: key);

  @override
  State<ControleDeNavegacaoPittsburg> createState() =>
      _ControleDeNavegacaoPittsburgState();
}

class _ControleDeNavegacaoPittsburgState
    extends State<ControleDeNavegacaoPittsburg> {
  @override
  Widget build(BuildContext context) {
    bool estaNaPrimeiraPergunta = widget.paginaAtual == 1;
    bool naoEstaNaUltimaPergunta =
        widget.paginaAtual != widget.controller.listaDePaginas.length;

    bool perguntaSelecionavel = ![
      TipoPergunta.extensoNumerico,
      TipoPergunta.extenso,
      null
    ].contains(widget.perguntaAtual?.tipo);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: perguntaSelecionavel && naoEstaNaUltimaPergunta ? 0 : 40,
            width: perguntaSelecionavel && naoEstaNaUltimaPergunta
                ? 0
                : double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
                if (naoEstaNaUltimaPergunta) {
                  return !perguntaSelecionavel
                      ? () async {
                          if (widget.controller.formKey.currentState!
                              .validate()) {
                            widget.controller.formKey.currentState!.save();
                            await widget.controller.passarParaProximaPagina(widget.questionarioSetState);
                          }
                        }
                      : null;
                } else {
                  return () async {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();

                    ResultadoPittsburg? resultadoPitts =
                        widget.controller.validarFormulario();
                    if (resultadoPitts != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          maintainState: true,
                          builder: (context) => ResultadoPittsburgView(
                            resultado: resultadoPitts,
                            paciente: widget.controller.paciente,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Existem perguntas não respondidas!",
                          ),
                        ),
                      );
                    }
                  };
                }
              }(),
              child: () {
                if (widget.perguntaAtual == null) {
                  return const Text("Avançar");
                } else if (naoEstaNaUltimaPergunta) {
                  return const Text("Confirmar resposta");
                } else {
                  return const Text(
                    "Finalizar questionário",
                  );
                }
              }(),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
                primary: naoEstaNaUltimaPergunta ? null : Colors.green,
              ),
            ),
          ),
          Visibility(
            visible: !(perguntaSelecionavel && naoEstaNaUltimaPergunta),
            child: const SizedBox(
              height: 10,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: estaNaPrimeiraPergunta ? 0 : 40,
            width: estaNaPrimeiraPergunta ? 0 : double.maxFinite,
            child: ElevatedButton(
              child: const Text(
                "Voltar para pergunta anterior",
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
                primary: Colors.orange[300],
              ),
              onPressed: () async {
                await widget.controller.passarParaPaginaAnterior();
              },
            ),
          ),
        ],
      ),
    );
  }
}
