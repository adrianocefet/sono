import 'package:flutter/material.dart';
import 'package:sono/pages/avaliacao/selecao_exame/dialogs/excluir_exame.dart';
import 'package:sono/utils/models/exame.dart';
import '../../avaliacao_controller.dart';
import 'acao_exame.dart';

class SelecionarQuestionario extends StatefulWidget {
  final ControllerAvaliacao controllerAvaliacao;
  final Exame exame;
  const SelecionarQuestionario(
      {Key? key, required this.exame, required this.controllerAvaliacao})
      : super(key: key);

  @override
  State<SelecionarQuestionario> createState() => _SelecionarQuestionarioState();
}

class _SelecionarQuestionarioState extends State<SelecionarQuestionario> {
  @override
  Widget build(BuildContext context) {
    String dataUltimaAtualizacaoDeQuestionarios =
        widget.controllerAvaliacao.obterDataDaUltimaAtualizacaoFormatada(
      widget.exame,
    );

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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Última atualização',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            dataUltimaAtualizacaoDeQuestionarios,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      AcaoExame(
                        versaoQuestionarios: true,
                        tipo: 'adicionar',
                        modificarEstadoExame: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => _ListaDeQuestionarios(
                              controllerAvaliacao: widget.controllerAvaliacao,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ...widget.controllerAvaliacao.listaDeExamesRealizados
                    .where((element) => element.tipo == TipoExame.questionario)
                    .map(
                      (e) => _QuestionarioRealizado(
                        controllerAvaliacao: widget.controllerAvaliacao,
                        exame: e,
                      ),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionarioRealizado extends StatefulWidget {
  final ControllerAvaliacao controllerAvaliacao;
  final Exame exame;
  const _QuestionarioRealizado(
      {Key? key, required this.controllerAvaliacao, required this.exame})
      : super(key: key);

  @override
  State<_QuestionarioRealizado> createState() => _QuestionarioRealizadoState();
}

class _QuestionarioRealizadoState extends State<_QuestionarioRealizado> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Theme.of(context).primaryColor),
            ),
            color: Theme.of(context).primaryColorLight,
          ),
          child: Center(
            child: Text(
              widget.exame.nomeDoQuestionario!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AcaoExame(
                versaoQuestionarios: true,
                tipo: 'ver',
                modificarEstadoExame: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => widget.controllerAvaliacao
                          .gerarObjetoQuestionario(
                              widget.exame.tipoQuestionario!),
                    ),
                  );
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => widget.controllerAvaliacao
                          .gerarViewResultadoDoQuestionario(widget.exame),
                    ),
                  );
                },
              ),
              AcaoExame(
                versaoQuestionarios: true,
                tipo: 'refazer',
                modificarEstadoExame: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          widget.controllerAvaliacao.gerarObjetoQuestionario(
                        widget.exame.tipoQuestionario!,
                        refazer: true,
                      ),
                    ),
                  );
                },
              ),
              AcaoExame(
                versaoQuestionarios: true,
                tipo: 'excluir',
                modificarEstadoExame: () async {
                  if (await mostrarDialogExclusaoDeExame(context)) {
                    widget.controllerAvaliacao.removerExame(widget.exame);
                  }
                },
              )
            ]),
      ],
    );
  }
}

class _ListaDeQuestionarios extends StatelessWidget {
  final ControllerAvaliacao controllerAvaliacao;
  const _ListaDeQuestionarios({Key? key, required this.controllerAvaliacao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TipoQuestionario> questionariosRealizados =
        controllerAvaliacao.listarQuestionariosRealizados();
    List<TipoQuestionario> listarQuestionariosNaoRealizados() {
      List<TipoQuestionario> questionariosNaoRealizados =
          List.from(TipoQuestionario.values);

      for (TipoQuestionario tipoRealizado in questionariosRealizados) {
        questionariosNaoRealizados.remove(tipoRealizado);
      }
      return questionariosNaoRealizados;
    }

    List<TipoQuestionario> questionariosNaoRealizados =
        listarQuestionariosNaoRealizados();

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 165),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: const Center(
                child: Text(
                  'Adicionar opção',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Theme.of(context).primaryColorLight,
                      width: 1.2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: questionariosNaoRealizados.length,
                      itemBuilder: (context, i) {
                        TipoQuestionario tipoQuestionario =
                            questionariosNaoRealizados[i];

                        String dataUltimaAtualizacao = controllerAvaliacao
                            .obterDataDaUltimaAtualizacaoFormatada(
                          Exame(
                            TipoExame.questionario,
                            tipoQuestionario: tipoQuestionario,
                          ),
                        );

                        return Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              Map<String, dynamic>? respostasQuestionario;
                              respostasQuestionario = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return controllerAvaliacao
                                        .gerarObjetoQuestionario(
                                            tipoQuestionario);
                                  },
                                ),
                              );

                              if (respostasQuestionario != null) {
                                Exame exameRealizado = Exame(
                                  TipoExame.questionario,
                                  tipoQuestionario: tipoQuestionario,
                                  respostas: respostasQuestionario,
                                );

                                controllerAvaliacao.salvarExame(exameRealizado);

                                Navigator.pop(context, exameRealizado);
                              }
                            },
                            child: Column(
                              children: [
                                Text(
                                  controllerAvaliacao.nomeDoQuestionarioPorTipo(
                                      tipoQuestionario),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Última atualização: $dataUltimaAtualizacao",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 13),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1.2,
                              ),
                              backgroundColor: Theme.of(context).focusColor,
                              minimumSize: const Size.fromHeight(45),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
