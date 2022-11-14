import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'resultado_stop_bang.dart';

class TelaResultadoStopBang extends StatelessWidget {
  final ResultadoStopBang resultadoStopBang;
  final bool consultando;
  const TelaResultadoStopBang(this.resultadoStopBang,
      {Key? key, this.consultando = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color _cor = Colors.green;
    String resultadoEmString() {
      switch (resultadoStopBang.resultado) {
        case ResultadoStopBangEnum.altoRiscoDeAOS:
          _cor = Colors.red;
          return "Alto Risco de AOS!";
        case ResultadoStopBangEnum.riscoIntermediarioDeAOS:
          _cor = Colors.orange;
          return "Risco Intermediário de AOS!";
        default:
          _cor = Colors.green;
          return "Risco Baixo de AOS!";
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Resultado',
        ),
        backgroundColor: Theme.of(context).primaryColor,
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
                child: Text(
                  resultadoEmString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: _cor,
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
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          onPressed: () async {
            if (!consultando) Navigator.pop(context);
            Navigator.pop(
              context,
              resultadoStopBang.mapaDeRespostasEPontuacao,
            );
          },
        ),
      ),
    );
  }
}
