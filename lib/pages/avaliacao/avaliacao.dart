import 'package:flutter/material.dart';

import 'widgets/exame.dart';

class Avaliacao extends StatefulWidget {
  const Avaliacao({Key? key}) : super(key: key);

  @override
  State<Avaliacao> createState() => _AvaliacaoState();
}

class _AvaliacaoState extends State<Avaliacao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Avaliação"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromRGBO(165, 166, 246, 1.0), Colors.white],
            stops: [0, 0.2],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
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
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ...TipoExame.values
                      .map((exame) => Exame(tipo: exame))
                      .toList(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'Finalizar avaliação',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 5.0,
                        fixedSize: Size(
                          MediaQuery.of(context).size.width,
                          50,
                        ),
                        primary: Theme.of(context).focusColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
