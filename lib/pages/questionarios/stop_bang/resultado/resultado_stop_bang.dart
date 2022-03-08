import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/pagina_inicial/screen_home.dart';
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
        backgroundColor: Constantes.corPrincipalQuestionarios,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            height: 400,
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: Constantes.corAzulEscuroSecundario.withOpacity(0.7),
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
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Constantes.corPrincipalQuestionarios,
                minimumSize: const Size(0, 140)),
            child: const Text(
              "Salvar resultado no perfil do paciente",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
