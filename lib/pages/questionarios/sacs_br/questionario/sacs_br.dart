import 'package:flutter/material.dart';
import 'package:sono/pages/questionarios/sacs_br/questionario/sacs_br_controller.dart';

import '../../../../constants/constants.dart';
import '../../../../utils/models/paciente.dart';
import '../../../../utils/models/pergunta.dart';
import '../../widgets/dialogs/sair_questionario.dart';
import '../resultado/resultado_sacs_br_view.dart';

class SacsBR extends StatefulWidget {
  final Paciente paciente;

  const SacsBR({required this.paciente, Key? key}) : super(key: key);

  @override
  _SacsBRState createState() => _SacsBRState();
}

class _SacsBRState extends State<SacsBR> {
  final _formKey = GlobalKey<FormState>();
  final _pageViewController = PageController();
  final _controller = SacsBRController();

  Pergunta? perguntaAtual;

  Future<void> _passarParaProximaPagina() async {
    setState(() {});
    await _pageViewController.nextPage(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeIn,
    );
  }

  Future<void> _passarParaPaginaAnterior() async {
    await _pageViewController.previousPage(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    perguntaAtual = perguntaAtual ?? _controller.listaDePerguntas.first;

    final listaDeRespostas =
        _controller.gerarListaDeRespostas(context, _passarParaProximaPagina);

    ValueNotifier paginaAtual = ValueNotifier(
      _pageViewController.positions.isNotEmpty
          ? _pageViewController.page!.toInt() + 1
          : 1,
    );

    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        await mostrarDialogDesejaSairDoQuestionario(context);

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "SACS-BR",
            textAlign: TextAlign.center,
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
                    "$value/${_controller.tamanhoListaDeRespostas}",
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
                  paginaAtual != _controller.tamanhoListaDeRespostas;
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height:
                          perguntaAtual?.tipo != TipoPergunta.extensoNumerico &&
                                  naoEstaNaUltimaPergunta
                              ? 0
                              : 40,
                      width:
                          perguntaAtual?.tipo != TipoPergunta.extensoNumerico &&
                                  naoEstaNaUltimaPergunta
                              ? 0
                              : double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () {
                          if (naoEstaNaUltimaPergunta) {
                            return perguntaAtual?.tipo ==
                                    TipoPergunta.extensoNumerico
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

                              ResultadoSACSBR? resultadoSACSBR =
                                  _controller.validarFormulario(_formKey);
                              if (resultadoSACSBR != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    maintainState: true,
                                    builder: (context) => ResultadoSACSBRView(
                                      resultadoSACSBR: resultadoSACSBR,
                                      paciente: widget.paciente,
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
                    Visibility(
                      visible: !(perguntaAtual?.tipo !=
                              TipoPergunta.extensoNumerico &&
                          naoEstaNaUltimaPergunta),
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
