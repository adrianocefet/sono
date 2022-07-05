import 'package:flutter/material.dart';
import 'package:sono/pages/questionarios/berlin/questionario/berlin.dart';
import 'package:sono/pages/questionarios/epworth/questionario/epworth_view.dart';
import 'package:sono/pages/questionarios/pittsburg/questionario/pittsburg_view.dart';
import 'package:sono/pages/questionarios/sacs_br/questionario/sacs_br.dart';
import 'package:sono/pages/questionarios/stop_bang/questionario/stop_bang.dart';
import 'package:sono/pages/questionarios/whodas/questionario/whodas_view.dart';
import 'package:sono/utils/models/paciente.dart';
import '../../../constants/constants.dart';
import '../goal/questionario/goal.dart';

class SelecaoDeQuestionarios extends StatefulWidget {
  final Paciente paciente;
  const SelecaoDeQuestionarios({Key? key, required this.paciente})
      : super(key: key);

  @override
  _SelecaoDeQuestionariosState createState() => _SelecaoDeQuestionariosState();
}

class _SelecaoDeQuestionariosState extends State<SelecaoDeQuestionarios> {
  List tiposDeQuestionarios = [
    StopBang,
    Berlin,
    SacsBR,
    WHODAS,
    GOAL,
    Epworth,
    Pittsburg,
  ];

  ListTile tileQuestionario({required dynamic tipoDeQuestionario}) {
    late String nomeDoQuestionario;

    switch (tipoDeQuestionario) {
      case Berlin:
        nomeDoQuestionario = "Berlin";
        break;
      case StopBang:
        nomeDoQuestionario = "Stop-Bang";
        break;
      case SacsBR:
        nomeDoQuestionario = "SACS-BR";
        break;
      case WHODAS:
        nomeDoQuestionario = "WHODAS";
        break;
      case GOAL:
        nomeDoQuestionario = "GOAL";
        break;
      case Pittsburg:
        nomeDoQuestionario = "Pittsburg";
        break;
      case Epworth:
        nomeDoQuestionario = "Epworth";
        break;
    }

    return ListTile(
      title: Text(
        nomeDoQuestionario,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return () {
                switch (tipoDeQuestionario) {
                  case Berlin:
                    return Berlin(paciente: widget.paciente);
                  case SacsBR:
                    return SacsBR(paciente: widget.paciente);
                  case WHODAS:
                    return WHODAS(paciente: widget.paciente);
                  case GOAL:
                    return GOAL(paciente: widget.paciente);
                  case Epworth:
                    return Epworth(paciente: widget.paciente);
                  case Pittsburg:
                    return Pittsburg(paciente: widget.paciente);
                  default:
                    return StopBang(paciente: widget.paciente);
                }
              }();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Questionários"),
        centerTitle: true,
        backgroundColor: Constantes.corAzulEscuroPrincipal,
      ),
      drawerEnableOpenDragGesture: true,
      body: ListView.separated(
        itemCount: tiposDeQuestionarios.length,
        itemBuilder: (context, i) => tileQuestionario(
          tipoDeQuestionario: tiposDeQuestionarios[i],
        ),
        separatorBuilder: (context, i) => const Divider(
          thickness: 2,
          color: Constantes.corAzulEscuroSecundario,
        ),
      ),
    );
  }
}
