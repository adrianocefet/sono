import 'package:flutter/material.dart';
import 'package:sono/pages/avaliacao/questionarios/epworth/resultado/resultado_epworth_view.dart';

import '../epworth_controller.dart';

class ControleDeNavegacaoEpworth extends StatefulWidget {
  final int paginaAtual;
  final EpworthController controller;

  const ControleDeNavegacaoEpworth(
      {required this.controller, required this.paginaAtual, Key? key})
      : super(key: key);

  @override
  State<ControleDeNavegacaoEpworth> createState() =>
      _ControleDeNavegacaoEpworthState();
}

class _ControleDeNavegacaoEpworthState
    extends State<ControleDeNavegacaoEpworth> {
  @override
  Widget build(BuildContext context) {
    bool estaNaPrimeiraPergunta = widget.paginaAtual == 1;
    bool naoEstaNaUltimaPergunta =
        widget.paginaAtual != widget.controller.listaDePaginas.length;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: naoEstaNaUltimaPergunta ? 0 : 40,
            width: naoEstaNaUltimaPergunta ? 0 : double.maxFinite,
            child: ElevatedButton(
              child: const Text(
                "Finalizar questionário",
              ),
              onPressed: () async {
                if (widget.controller.formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  widget.controller.formKey.currentState!.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      maintainState: true,
                      builder: (context) => ResultadoEpworthView(
                        resultado: widget.controller.resultado,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Visibility(
            visible: !(naoEstaNaUltimaPergunta),
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
