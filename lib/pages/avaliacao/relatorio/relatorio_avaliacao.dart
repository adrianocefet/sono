import 'package:flutter/material.dart';
import 'package:sono/pages/avaliacao/avaliacao_controller.dart';
import 'package:sono/pages/avaliacao/relatorio/widgets/exames_realizados.dart';

class RelatorioAvaliacao extends StatelessWidget {
  final ControllerAvaliacao controllerAvaliacao;
  const RelatorioAvaliacao({Key? key, required this.controllerAvaliacao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Relatório da Avaliação',
        ),
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'xafAFSFxasd5623',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    '8, ago, 2022  15:40',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ExamesRealizados(
                      listaDeExamesRealizados:
                          controllerAvaliacao.listaDeExamesRealizados,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}