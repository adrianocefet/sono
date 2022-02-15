import 'package:flutter/material.dart';
import 'package:sono/pages/questionarios/stop_bang/questionario/stop_bang.dart';
import 'package:sono/pages/questionarios/whodas/questionario/whodas_view.dart';
import 'package:sono/utils/models/paciente/paciente.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Questionários"),
        centerTitle: true,
        backgroundColor: Constants.corPrincipalQuestionarios,
      ),
      drawer: CustomDrawer(widget.pageController),
      drawerEnableOpenDragGesture: true,
      body: ListView(
        children: [
          ListTile(
            title: const Text(
              'WHODAS',
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () async {
              Paciente? pacienteEscolhido =
                  await mostrarDialogEscolherPaciente(context);

              if (pacienteEscolhido != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    maintainState: true,
                    builder: (_) {
                      return WHODASView(
                        paciente: pacienteEscolhido,
                      );
                    },
                  ),
                );
              }
            },
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'STOP-BANG',
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () async {
              Paciente? pacienteEscolhido =
                  await mostrarDialogEscolherPaciente(context);

              if (pacienteEscolhido != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return const StopBang();
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class QuestionarioTile extends StatelessWidget {
  final String nome;
  final StatefulWidget paginaDestino;
  const QuestionarioTile(
    this.nome,
    this.paginaDestino, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        nome,
        style: const TextStyle(
          fontSize: 20,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () async {
        Paciente? pacienteEscolhido =
            await mostrarDialogEscolherPaciente(context);

        if (pacienteEscolhido != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              maintainState: true,
              builder: (_) {
                return paginaDestino;
              },
            ),
          );
        }
      },
    );
  }
}
