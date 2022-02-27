import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/questionarios/stop_bang/questionario/stop_bang_controller.dart';
import 'package:sono/pages/questionarios/stop_bang/resultado/resultado_stop_bang.dart';
import 'package:sono/utils/models/pergunta.dart';

class StopBang extends StatefulWidget {
  const StopBang({Key? key}) : super(key: key);

  @override
  _StopBangState createState() => _StopBangState();
}

class _StopBangState extends State<StopBang> {
  final _formKey = GlobalKey<FormState>();
  final _pageViewController = PageController();
  final _controller = StopBangController();

  Future<void> _passarPagina() async {
    await _pageViewController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final listaDeRespostas = _controller.listaDeRespostas(_passarPagina);
    ValueNotifier paginaAtual = ValueNotifier(
      _pageViewController.positions.isNotEmpty
          ? _pageViewController.page!.toInt() + 1
          : 0,
    );

    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        Navigator.pop(context);

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("STOP-BANG"),
          backgroundColor: Constants.corPrincipalQuestionarios,
          actions: [
            ValueListenableBuilder(
              valueListenable: paginaAtual,
              builder: (context, value, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    "$value/${_controller.listaDePerguntas.length}",
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
            itemCount: listaDeRespostas.length,
            controller: _pageViewController,
            itemBuilder: (context, i) => listaDeRespostas[i],
            onPageChanged: (i) => paginaAtual.value = i + 1,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Constants.corPrincipalQuestionarios,
              ),
              onPressed: () async {
                for (Pergunta p in _controller.listaDePerguntas) {
                  print("${p.codigo} : ${p.resposta}");
                }

                ScaffoldMessenger.of(context).removeCurrentSnackBar();

                ResultadoStopBang? resultadoQuestionario =
                    _controller.validarFormulario(_formKey);

                if (resultadoQuestionario != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      maintainState: true,
                      builder: (_) {
                        return TelaResultadoStopBang(
                          resultadoQuestionario,
                        );
                      },
                    ),
                  );
                } else {
                  _pageViewController.animateToPage(
                    () {
                      return listaDeRespostas.indexOf(
                          listaDeRespostas.firstWhere(
                              (element) => element.pergunta.resposta == null));
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
              },
              child: const Text(
                "Finalizar questionário",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
