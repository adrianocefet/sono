import 'package:flutter/material.dart';
import 'package:sono/pages/questionarios/whodas/questionario/whodas_view.dart';
import 'package:sono/utils/models/paciente/paciente.dart';
import 'package:sono/widgets/dialogs/escolher_paciente_dialog.dart';

class SelecaoDeQuestionario extends StatefulWidget {
  const SelecaoDeQuestionario({Key? key}) : super(key: key);

  @override
  _SelecaoDeQuestionarioState createState() => _SelecaoDeQuestionarioState();
}

class _SelecaoDeQuestionarioState extends State<SelecaoDeQuestionario> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text(
            'WHODAS',
            style: TextStyle(
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
                    return WHODASView(
                      paciente: pacienteEscolhido,
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
