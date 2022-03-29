import 'package:flutter/material.dart';
import 'package:sono/pages/questionarios/widgets/enunciado_respostas.dart';
import '../../../../constants/constants.dart';
import '../../../../utils/models/paciente.dart';
import '../../../../utils/models/pergunta.dart';
import '../../widgets/dialogs/sair_questionario.dart';
import 'pittsburg_controller.dart';
import 'widgets/controle_de_nav_pittsburg.dart';

class Pittsburg extends StatefulWidget {
  final Paciente paciente;
  late final PittsburgController _controller;
  Pittsburg({required this.paciente, Key? key}) : super(key: key) {
    _controller = PittsburgController(paciente);
  }

  @override
  _PittsburgState createState() => _PittsburgState();
}

class _PittsburgState extends State<Pittsburg> {
  Pergunta? perguntaAtual;
  ValueNotifier<int>? paginaAtual;

  @override
  Widget build(BuildContext context) {
    final listaDePaginas = widget._controller.gerarListaDePaginas(
      () => setState(() {}),
    );

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
                  "Pittsburg",
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
            itemCount: listaDePaginas.length,
            controller: widget._controller.pageViewController,
            itemBuilder: (context, i) {
              return SingleChildScrollView(
                child: listaDePaginas[i],
              );
            },
            onPageChanged: (i) {
              setState(() {});
              if (listaDePaginas[i].runtimeType !=
                  EnunciadoRespostasDeQuestionarios) {
                perguntaAtual = (listaDePaginas[i] as dynamic).pergunta;
              } else {
                perguntaAtual = null;
              }

              paginaAtual!.value = i + 1;
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Constantes.corAzulEscuroPrincipal,
          child: ValueListenableBuilder(
            valueListenable: paginaAtual!,
            builder: (context, int paginaAtual, _) =>
                ControleDeNavegacaoPittsburg(
              controller: widget._controller,
              paginaAtual: paginaAtual,
              perguntaAtual: perguntaAtual,
              questionarioSetState: () => setState(() {}),
            ),
          ),
        ),
      ),
    );
  }
}
