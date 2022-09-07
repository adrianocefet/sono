import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/avaliacao/questionarios/berlin/resultado/resultado_berlin_view.dart';
import 'package:sono/utils/models/pergunta.dart';
import '../../widgets/dialogs/sair_questionario.dart';
import 'berlin_controller.dart';

class Berlin extends StatefulWidget {
  late final BerlinController controller;
  Berlin(
      {Map<String, dynamic>? autoPreencher, Key? key})
      : super(key: key) {
    controller = BerlinController(autoPreencher: autoPreencher);
  }

  @override
  _BerlinState createState() => _BerlinState();
}

class _BerlinState extends State<Berlin> {
  final _formKey = GlobalKey<FormState>();
  final _pageViewController = PageController();

  Pergunta? perguntaAtual;

  Future<void> _passarParaProximaPagina() async {
    setState(() {});
    await _pageViewController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }

  Future<void> _passarParaPaginaAnterior() async {
    await _pageViewController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    perguntaAtual = perguntaAtual ?? widget.controller.listaDePerguntas.first;

    final listaDeRespostas =
        widget.controller.gerarListaDeRespostas(_passarParaProximaPagina);

    ValueNotifier paginaAtual = ValueNotifier(
      _pageViewController.positions.isNotEmpty
          ? _pageViewController.page!.toInt() + 1
          : 1,
    );

    ValueNotifier categoriaAtual = ValueNotifier(
      () {
        switch (listaDeRespostas[paginaAtual.value - 1].pergunta.dominio) {
          case "inicial":
            return "Perguntas iniciais";
          case "categoria_1":
            return "Categoria 1";
          case "categoria_2":
            return "Categoria 2";
          case "categoria_3":
            return "Categoria 3";
        }
      }(),
    );

    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        await mostrarDialogDesejaSairDoQuestionario(context);

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: ValueListenableBuilder(
            valueListenable: categoriaAtual,
            builder: (context, value, _) => Text(
              "BERLIN\n$value",
              textAlign: TextAlign.center,
            ),
          ),
          centerTitle: true,
          backgroundColor: Constantes.corAzulEscuroPrincipal,
          actions: [
            ValueListenableBuilder(
              valueListenable: paginaAtual,
              builder: (context, value, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    "$value/${widget.controller.tamanhoListaDeRespostas}",
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listaDeRespostas.length,
            controller: _pageViewController,
            itemBuilder: (context, i) {
              return SingleChildScrollView(child: listaDeRespostas[i]);
            },
            onPageChanged: (i) {
              perguntaAtual = listaDeRespostas[i].pergunta;
              paginaAtual.value = i + 1;

              categoriaAtual.value = () {
                switch (listaDeRespostas[i].pergunta.dominio) {
                  case "inicial":
                    return "Perguntas iniciais";
                  case "categoria_1":
                    return "Categoria 1";
                  case "categoria_2":
                    return "Categoria 2";
                  case "categoria_3":
                    return "Categoria 3";
                }
              }();
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Constantes.corAzulEscuroPrincipal,
          child: ValueListenableBuilder(
            valueListenable: paginaAtual,
            builder: (context, paginaAtual, _) {
              bool estaNaPrimeiraPergunta = paginaAtual == 1;
              bool naoEstaNaUltimaPergunta =
                  paginaAtual != widget.controller.tamanhoListaDeRespostas;
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height:
                          perguntaAtual?.tipo != TipoPergunta.numerica &&
                                  naoEstaNaUltimaPergunta
                              ? 0
                              : 40,
                      width:
                          perguntaAtual?.tipo != TipoPergunta.numerica &&
                                  naoEstaNaUltimaPergunta
                              ? 0
                              : double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () {
                          if (naoEstaNaUltimaPergunta) {
                            return perguntaAtual?.tipo ==
                                    TipoPergunta.numerica
                                ? () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      await _passarParaProximaPagina();
                                    }
                                  }
                                : null;
                          } else {
                            return () async {
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();

                              ResultadoBerlin? resultadoBerlin =
                                  widget.controller.validarFormulario(_formKey);
                              if (resultadoBerlin != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    maintainState: true,
                                    builder: (context) => TelaResultadoBerlin(
                                      resultadoBerlin: resultadoBerlin,
                                    ),
                                  ),
                                );
                              } else {
                                _pageViewController.animateToPage(
                                  () {
                                    return widget.controller
                                        .obterPaginaDaQuestaoNaoRespondida(
                                      listaDeRespostas,
                                    );
                                  }(),
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeIn,
                                );
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
                        child: naoEstaNaUltimaPergunta
                            ? const Text("Confirmar resposta")
                            : const Text(
                                "Finalizar questionário",
                              ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          primary:
                              naoEstaNaUltimaPergunta ? null : Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                          await _passarParaPaginaAnterior();
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
