import 'package:flutter/material.dart';
import 'package:sono/pages/questionarios/whodas/questionario/whodas_controller.dart';

import '../../../../../utils/models/pergunta.dart';
import '../../resultado/resultado_whodas.dart';

class ControleDeNavegacao extends StatefulWidget {
  final int paginaAtual;
  final WHODASController controller;
  final Pergunta? perguntaAtual;

  const ControleDeNavegacao({
    Key? key,
    required this.controller,
    required this.paginaAtual,
    required this.perguntaAtual,
  }) : super(key: key);

  @override
  State<ControleDeNavegacao> createState() => _ControleDeNavegacaoState();
}

class _ControleDeNavegacaoState extends State<ControleDeNavegacao> {
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
                            await widget.controller.passarParaProximaPagina();
                          }
                        }
                      : null;
                } else {
                  return () async {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();

                    ResultadoWHODAS? resultadoWHODAS = widget.controller
                        .validarFormulario(widget.controller.formKey);
                    if (resultadoWHODAS != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          maintainState: true,
                          builder: (context) => ResultadoWHODASView(
                            resultado: resultadoWHODAS,
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
