import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/avaliacao/questionarios/whodas/questionario/whodas_controller.dart';
import 'package:sono/utils/helpers/resposta_widget.dart';
import 'package:sono/utils/models/pergunta.dart';
import '../../widgets/dialogs/sair_questionario.dart';
import 'widgets/controle_de_nav.dart';
import 'widgets/resposta_ativ_trab.dart';

class WHODAS extends StatefulWidget {
  late final WHODASController _controller;
  WHODAS({Map<String, dynamic>? autoPreencher, Key? key}) : super(key: key) {
    _controller = WHODASController(autoPreencher: autoPreencher);
  }

  @override
  _WHODASState createState() => _WHODASState();
}

class _WHODASState extends State<WHODAS> {
  Pergunta? perguntaAtual;
  ValueNotifier<int>? paginaAtual;

  @override
  Widget build(BuildContext context) {
    final listaDeRespostas =
        widget._controller.gerarListaDePaginas(() => setState(() {}));

    paginaAtual = paginaAtual ??
        ValueNotifier<int>(
          widget._controller.pageViewController.positions.isNotEmpty
              ? widget._controller.pageViewController.page!.toInt() + 1
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
          title: ValueListenableBuilder<int>(
              valueListenable: paginaAtual!,
              builder: (context, paginaAtual, _) {
                return Text(
                  "WHODAS${widget._controller.tituloSecaoAtual(perguntaAtual)}",
                  textAlign: TextAlign.center,
                );
              }),
          centerTitle: true,
          backgroundColor: Constantes.corAzulEscuroPrincipal,
          actions: [
            ValueListenableBuilder(
              valueListenable: paginaAtual!,
              builder: (context, paginaAtual, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    "$paginaAtual/${widget._controller.listaDePaginas.length}",
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: widget._controller.formKey,
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listaDeRespostas.length,
            controller: widget._controller.pageViewController,
            itemBuilder: (context, i) {
              return SingleChildScrollView(
                child: listaDeRespostas[i],
              );
            },
            onPageChanged: (i) {
              setState(() {});
              switch (listaDeRespostas[i].runtimeType) {
                case RespostaWidget:
                  perguntaAtual =
                      (listaDeRespostas[i] as RespostaWidget).pergunta;
                  break;
                case RespostaAtividadeTrabalho:
                  perguntaAtual =
                      (listaDeRespostas[i] as RespostaAtividadeTrabalho)
                          .pergunta;
                  break;
                default:
                  perguntaAtual = null;
                  break;
              }

              paginaAtual!.value = i + 1;
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Constantes.corAzulEscuroPrincipal,
          child: ValueListenableBuilder(
            valueListenable: paginaAtual!,
            builder: (context, int paginaAtual, _) => ControleDeNavegacao(
              controller: widget._controller,
              paginaAtual: paginaAtual,
              perguntaAtual: perguntaAtual,
            ),
          ),
        ),
      ),
    );
  }
}