import 'package:flutter/material.dart';
import 'package:sono/pages/questionarios/berlin/questionario/berlin.dart';
import 'package:sono/pages/questionarios/sacs_br/questionario/sacs_br.dart';
import 'package:sono/pages/questionarios/stop_bang/questionario/stop_bang.dart';
import 'package:sono/pages/questionarios/whodas/questionario/whodas_view.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/widgets/dialogs/escolher_paciente_dialog.dart';

import '../../../constants/constants.dart';
import '../../pagina_inicial/widgets/widgets_drawer.dart';

class SelecaoDeQuestionario extends StatefulWidget {
  final PageController pageController;
  const SelecaoDeQuestionario({Key? key, required this.pageController})
      : super(key: key);

  @override
  _SelecaoDeQuestionarioState createState() => _SelecaoDeQuestionarioState();
}

class _SelecaoDeQuestionarioState extends State<SelecaoDeQuestionario> {
  Paciente? _pacienteEscolhido;

  List tiposDeQuestionarios = [
    StopBang,
    Berlin,
    SacsBR,
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
        _pacienteEscolhido = await mostrarDialogEscolherPaciente(context);

        if (_pacienteEscolhido != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                return () {
                  switch (tipoDeQuestionario) {
                    case Berlin:
                      return Berlin(paciente: _pacienteEscolhido!);
                    case SacsBR:
                      return SacsBR(paciente: _pacienteEscolhido!);
                    default:
                      return StopBang(paciente: _pacienteEscolhido!);
                  }
                }();
              },
            ),
          );
        }
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
      drawer: CustomDrawer(widget.pageController),
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
