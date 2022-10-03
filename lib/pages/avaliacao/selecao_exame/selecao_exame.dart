import 'package:flutter/material.dart';
import 'package:sono/pages/avaliacao/relatorio/relatorio_avaliacao.dart';
import 'package:sono/pages/avaliacao/selecao_exame/widgets/exame_descritivo.dart';
import 'package:sono/pages/avaliacao/selecao_exame/widgets/selecionar_questionario.dart';
import 'package:sono/utils/models/exame.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/usuario.dart';
import '../avaliacao_controller.dart';
import 'widgets/selecionar_exame.dart';

class SelecaoDeExames extends StatefulWidget {
  final Paciente paciente;
  final Usuario usuario;
  late final ControllerAvaliacao controllerAvaliacao;
  SelecaoDeExames({Key? key, required this.paciente, required this.usuario})
      : super(key: key) {
    controllerAvaliacao =
        ControllerAvaliacao(paciente: paciente, avaliador: usuario);
  }

  @override
  State<SelecaoDeExames> createState() => _SelecaoDeExamesState();
}

class _SelecaoDeExamesState extends State<SelecaoDeExames> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Avaliação"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromRGBO(165, 166, 246, 1.0), Colors.white],
            stops: [0, 0.2],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.controllerAvaliacao.dataDaAvaliacaoFormatada,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: ValueListenableBuilder(
                  valueListenable:
                      widget.controllerAvaliacao.examesRealizadoNotifier,
                  builder: (context, examesRealizados, _) {
                    return Form(
                      key: widget.controllerAvaliacao.keyExamesDescritivos,
                      child: Column(
                        children: [
                          ...TipoExame.values.map(
                            (tipoExame) {
                              switch (tipoExame) {
                                case TipoExame.conclusao:
                                case TipoExame.dadosComplementares:
                                  return ExameDescritivo(
                                    exame: widget.controllerAvaliacao
                                        .obterExamePorTipoGeral(tipoExame),
                                    controllerAvaliacao:
                                        widget.controllerAvaliacao,
                                  );
                                case TipoExame.questionario:
                                  return SelecionarQuestionario(
                                    exame: widget.controllerAvaliacao
                                        .obterExamePorTipoGeral(tipoExame),
                                    controllerAvaliacao:
                                        widget.controllerAvaliacao,
                                  );
                                default:
                                  return SelecionarExame(
                                    exame: widget.controllerAvaliacao
                                        .obterExamePorTipoGeral(tipoExame),
                                    controllerAvaliacao:
                                        widget.controllerAvaliacao,
                                  );
                              }
                            },
                          ).toList(),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: ElevatedButton(
                              onPressed: () {
                                if (widget.controllerAvaliacao
                                    .keyExamesDescritivos.currentState!
                                    .validate()) {
                                  widget.controllerAvaliacao
                                      .keyExamesDescritivos.currentState!
                                      .save();

                                  widget.controllerAvaliacao
                                      .listaDeExamesRealizados;

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      maintainState: true,
                                      builder: (context) => RelatorioAvaliacao(
                                        controllerAvaliacao:
                                            widget.controllerAvaliacao,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                'Finalizar avaliação',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 5.0,
                                backgroundColor: Theme.of(context).focusColor,
                                fixedSize: Size(
                                  MediaQuery.of(context).size.width,
                                  50,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
