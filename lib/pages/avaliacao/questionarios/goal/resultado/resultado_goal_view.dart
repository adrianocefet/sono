import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import '../questionario/goal_controller.dart';

class ResultadoGOALView extends StatelessWidget {
  final ResultadoGOAL resultadoGOAL;
  final bool consultando;
  const ResultadoGOALView({
    required this.resultadoGOAL,
    this.consultando = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Resultado',
        ),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Container(
              height: 400,
              alignment: AlignmentDirectional.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Constantes.corAzulEscuroPrincipal,
                  width: 4,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: resultadoGOAL.resultadoEmString,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: resultadoGOAL.resultado == true
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      TextSpan(
                        text: "\n\nPontuação: ${resultadoGOAL.pontuacao}",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                          color: resultadoGOAL.resultado == true
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () async {
            if (!consultando) Navigator.pop(context);
            Navigator.pop(
              context,
              resultadoGOAL.mapaDeRespostasEPontuacao,
            );
          },
        ),
      ),
    );
  }
}
