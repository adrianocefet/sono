import 'package:flutter/material.dart';
import 'package:sono/pages/avaliacao/avaliacao_controller.dart';
import 'package:sono/pages/avaliacao/realizar_exame/realizar_exame.dart';
import 'package:sono/pages/avaliacao/selecao_exame/dialogs/excluir_exame.dart';
import 'package:sono/utils/models/exame.dart';
import 'acao_exame.dart';

class SelecionarExame extends StatefulWidget {
  final ControllerAvaliacao controllerAvaliacao;
  final Exame exame;
  const SelecionarExame(
      {Key? key, required this.exame, required this.controllerAvaliacao})
      : super(key: key);

  @override
  State<SelecionarExame> createState() => _SelecionarExameState();
}

class _SelecionarExameState extends State<SelecionarExame> {
  @override
  Widget build(BuildContext context) {
    String dataUltimaAtualizacao =
        widget.controllerAvaliacao.obterDataDaUltimaAtualizacaoFormatada(
      widget.exame,
    );
    bool exameRealizado =
        widget.controllerAvaliacao.verificarSeOExameFoiRealizado(widget.exame);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width * 0.92,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            width: 2,
            color: Theme.of(context).primaryColor,
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(17),
                  topRight: Radius.circular(17),
                ),
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: Text(
                  widget.exame.nome,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: exameRealizado
                    ? [
                        AcaoExame(
                          tipo: 'ver',
                          modificarEstadoExame: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RealizarExame(
                                  controllerAvaliacao:
                                      widget.controllerAvaliacao,
                                  exame: widget.exame,
                                ),
                              ),
                            );
                          },
                        ),
                        AcaoExame(
                          tipo: 'refazer',
                          modificarEstadoExame: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RealizarExame(
                                  controllerAvaliacao:
                                      widget.controllerAvaliacao,
                                  exame: widget.exame,
                                  refazerExame: true,
                                ),
                              ),
                            );
                          },
                        ),
                        AcaoExame(
                          tipo: 'excluir',
                          modificarEstadoExame: () async {
                            if (await mostrarDialogExclusaoDeExame(context)) {
                              widget.controllerAvaliacao
                                  .removerExame(widget.exame);
                            }
                          },
                        )
                      ]
                    : [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Última atualização:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              dataUltimaAtualizacao,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        AcaoExame(
                          tipo: 'adicionar',
                          modificarEstadoExame: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RealizarExame(
                                  controllerAvaliacao:
                                      widget.controllerAvaliacao,
                                  exame: widget.exame,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
