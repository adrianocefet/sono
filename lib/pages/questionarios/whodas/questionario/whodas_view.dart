import 'package:flutter/material.dart';
import 'package:sono/pages/questionarios/whodas/questionario/whodas_controller.dart';
import 'package:sono/pages/questionarios/whodas/questionario/widgets/controle_de_nav.dart';
import 'package:sono/utils/helpers/resposta_widget.dart';
import '../../../../constants/constants.dart';
import '../../../../utils/models/paciente.dart';
import '../../../../utils/models/pergunta.dart';
import 'widgets/resposta_ativ_trab.dart';

class WHODAS extends StatefulWidget {
  final Paciente paciente;
  late final WHODASController _controller;
  WHODAS({required this.paciente, Key? key}) : super(key: key) {
    _controller = WHODASController(paciente);
  }

  @override
  _WHODASState createState() => _WHODASState();
}

class _WHODASState extends State<WHODAS> {
  Pergunta? perguntaAtual;
  ValueNotifier<int>? paginaAtual;

  @override
  Widget build(BuildContext context) {
    final listaDeRespostas = widget._controller.gerarListaDePaginas();

    paginaAtual = paginaAtual ??
        ValueNotifier<int>(
          widget._controller.pageViewController.positions.isNotEmpty
              ? widget._controller.pageViewController.page!.toInt() + 1
              : 1,
        );

    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        Navigator.pop(context);

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "WHODAS",
            textAlign: TextAlign.center,
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
              return Scrollbar(
                thickness: 6,
                child: SingleChildScrollView(
                  child: listaDeRespostas[i],
                ),
              );
            },
            onPageChanged: (i) {
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
