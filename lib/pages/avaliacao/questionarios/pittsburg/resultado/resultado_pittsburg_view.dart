import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/avaliacao/questionarios/pittsburg/resultado/resultado_pittsburg.dart';

import '../../widgets/dialogs/sair_questionario.dart';

class ResultadoPittsburgView extends StatelessWidget {
  final ResultadoPittsburg resultado;
  final bool consultando;
  const ResultadoPittsburgView({
    required this.resultado,
    this.consultando = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? corResultado() {
      switch (resultado.indiceResultado) {
        case 1:
          return Colors.green;
        case 2:
          return Colors.orange;
        case 3:
          return Colors.red;
        default:
          return null;
      }
    }

    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        await mostrarDialogDesejaSairDoQuestionario(context);
        return false;
      },
      child: Scaffold(
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
                        const TextSpan(
                          text: "Qualidade do sono:\n\n",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Constantes.corAzulEscuroPrincipal,
                          ),
                        ),
                        TextSpan(
                          text: resultado.resultado,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: corResultado(),
                          ),
                        ),
                        const TextSpan(
                          text: "\n\nPontuação geral:\n\n",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                            color: Constantes.corAzulEscuroPrincipal,
                          ),
                        ),
                        TextSpan(
                          text: resultado.pontuacao.toString(),
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                            color: corResultado(),
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
                resultado.mapaDeRespostasEPontuacao,
              );
            },
          ),
        ),
      ),
    );
  }
}
