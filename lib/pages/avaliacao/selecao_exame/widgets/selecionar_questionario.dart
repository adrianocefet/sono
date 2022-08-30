import 'package:flutter/material.dart';
import 'package:sono/pages/avaliacao/avaliacao_controller.dart';
import '../../exame.dart';
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Últimas atualizações',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '02/05/2022 (3 meses e 7 dias atrás)',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    AcaoExame(
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
                ...widget.controllerAvaliacao.listaDeExamesRealizados.map(
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
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AcaoExame(
                tipo: 'ver',
                modificarEstadoExame: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => widget.controllerAvaliacao
                          .gerarViewResultadoDoQuestionario(widget.exame),
                    ),
                  );
                },
              ),
              AcaoExame(
                tipo: 'refazer',
                modificarEstadoExame: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          widget.controllerAvaliacao.gerarObjetoQuestionario(
                        widget.exame.tipoQuestionario!,
                      ),
                    ),
                  );
                },
              ),
              AcaoExame(
                tipo: 'excluir',
                modificarEstadoExame: () {
                  widget.controllerAvaliacao.removerExame(widget.exame);
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
          TipoQuestionario.values;

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
                            child: Text(
                              controllerAvaliacao
                                  .nomeDoQuestionario(tipoQuestionario),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1.2,
                              ),
                              minimumSize: const Size.fromHeight(42),
                              primary: Theme.of(context).focusColor,
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
