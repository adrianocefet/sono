import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/questionarios/berlin/questionario/berlin.dart';
import 'package:sono/pages/questionarios/berlin/questionario/berlin_controller.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/services/firebase.dart';

import '../../../pagina_inicial/screen_home.dart';

class TelaResultadoBerlin extends StatefulWidget {
  final ResultadoBerlin resultadoBerlin;
  final Paciente paciente;

  const TelaResultadoBerlin({
    Key? key,
    required this.paciente,
    required this.resultadoBerlin,
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
      body: Column(
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
            _TextoResultadoDaCategoria(resultadoDaCategoria: resultado)
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Constantes.corAzulEscuroPrincipal,
              minimumSize: const Size(0, 140),
            ),
            child: const Text(
              "Salvar resultado no perfil do paciente",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () async {
              await FirebaseService().salvarQuestionarioDoPaciente(
                widget.paciente,
                Berlin,
                widget.resultadoBerlin.mapaDeRespostasEPontuacao,
              );
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
          ),
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
