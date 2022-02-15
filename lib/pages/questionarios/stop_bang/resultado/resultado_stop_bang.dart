import 'package:flutter/material.dart';
import '../questionario/stop_bang_controller.dart';

class TelaResultadoStopBang extends StatelessWidget {
  final ResultadoStopBang resultadoStopBang;

  const TelaResultadoStopBang(this.resultadoStopBang, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color _cor = Colors.green;
    String resultadoEmString() {
      switch (resultadoStopBang) {
        case ResultadoStopBang.altoRiscoDeAOS:
          _cor = Colors.red;
          return "Alto Risco de AOS!";
        case ResultadoStopBang.riscoIntermediarioDeAOS:
          _cor = Colors.orange;
          return "Risco Intermediário de AOS!";
        default:
          _cor = Colors.green;
          return "Risco Baixo de AOS!";
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resultado',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Expanded(
          child: Text(
            resultadoEmString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w400,
              color: _cor,
            ),
          ),
        )),
      ),
    );
  }
}
