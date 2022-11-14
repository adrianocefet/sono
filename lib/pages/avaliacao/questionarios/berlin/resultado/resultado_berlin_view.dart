import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';

import '../questionario/berlin_controller.dart';

class TelaResultadoBerlin extends StatefulWidget {
  final ResultadoBerlin resultadoBerlin;
  final bool consultando;
  const TelaResultadoBerlin({
    Key? key,
    required this.resultadoBerlin,
    this.consultando = false,
  }) : super(key: key);

  @override
  State<TelaResultadoBerlin> createState() => _TelaResultadoBerlinState();
}

class _TelaResultadoBerlinState extends State<TelaResultadoBerlin> {
  Color get corDoResultado =>
      widget.resultadoBerlin.resultadoFinalPositivo ? Colors.red : Colors.green;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resultado"),
        centerTitle: true,
        backgroundColor: Constantes.corAzulEscuroPrincipal,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              color: corDoResultado.withOpacity(0.4),
              child: Text(
                widget.resultadoBerlin.resultadoEmString,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  color: Constantes.corAzulEscuroPrincipal,
                ),
              ),
            ),
            const Divider(
              color: Constantes.corAzulEscuroPrincipal,
              thickness: 3,
            ),
            for (MapEntry<String, bool> resultado
                in widget.resultadoBerlin.resultadosPorCategoria.entries)
              _TextoResultadoDaCategoria(resultadoDaCategoria: resultado),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5.0,
            backgroundColor: Theme.of(context).focusColor,
            fixedSize: Size(
              MediaQuery.of(context).size.width,
              50,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text(
            "Salvar resultado",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          onPressed: () async {
            if (!widget.consultando) Navigator.pop(context);
            Navigator.pop(
              context,
              widget.resultadoBerlin.mapaDeRespostasEPontuacao,
            );
          },
        ),
      ),
    );
  }
}

class _TextoResultadoDaCategoria extends StatelessWidget {
  final MapEntry<String, bool> resultadoDaCategoria;
  const _TextoResultadoDaCategoria(
      {Key? key, required this.resultadoDaCategoria})
      : super(key: key);

  String get nomeCategoria {
    switch (resultadoDaCategoria.key) {
      case "categoria_1":
        return "Categoria 1";
      case "categoria_2":
        return "Categoria 2";
      default:
        return "Categoria 3";
    }
  }

  Color get corDoResultado =>
      resultadoDaCategoria.value ? Colors.red : Colors.green;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: corDoResultado),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        color: corDoResultado.withOpacity(0.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$nomeCategoria :",
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Constantes.corAzulEscuroPrincipal,
            ),
          ),
          Icon(
            resultadoDaCategoria.value ? Icons.add_circle : Icons.remove_circle,
            color: corDoResultado,
          ),
        ],
      ),
    );
  }
}
