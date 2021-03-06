import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/models/paciente.dart';
import '../questionario/goal_controller.dart';

class ResultadoGOALView extends StatelessWidget {
  final ResultadoGOAL resultadoGOAL;
  final Paciente paciente;

  const ResultadoGOALView({
    required this.resultadoGOAL,
    required this.paciente,
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
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: resultadoGOAL.resultado == true
                          ? "Alta probabilidade de SAOS!"
                          : "Baixa probabilidade de SAOS!",
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
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Constantes.corAzulEscuroPrincipal,
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
