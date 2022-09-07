import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/avaliacao/questionarios/epworth/questionario/widgets/controle_de_nav_epworth.dart';
import 'package:sono/utils/models/pergunta.dart';
import '../../widgets/dialogs/sair_questionario.dart';
import 'epworth_controller.dart';

class Epworth extends StatefulWidget {
  late final EpworthController _controller;
  Epworth({Map<String, dynamic>? autoPreencher, Key? key}) : super(key: key) {
    _controller = EpworthController(autoPreencher: autoPreencher);
  }

  @override
  _EpworthState createState() => _EpworthState();
}

class _EpworthState extends State<Epworth> {
  Pergunta? perguntaAtual;
  ValueNotifier<int>? paginaAtual;

  @override
  Widget build(BuildContext context) {
    final listaDeRespostas = widget._controller.listaDePaginas;

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
              return const Text(
                "Epworth",
                textAlign: TextAlign.center,
              );
            },
          ),
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
              paginaAtual!.value = i + 1;
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Constantes.corAzulEscuroPrincipal,
          child: ValueListenableBuilder(
            valueListenable: paginaAtual!,
            builder: (context, int paginaAtual, _) =>
                ControleDeNavegacaoEpworth(
              controller: widget._controller,
              paginaAtual: paginaAtual,
            ),
          ),
        ),
      ),
    );
  }
}
