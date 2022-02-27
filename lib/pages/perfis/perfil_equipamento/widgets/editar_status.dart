import 'package:flutter/material.dart';
import 'package:sono/widgets/dialogs/error_message.dart';
import 'package:sono/widgets/dialogs/escolher_paciente_dialog.dart';
import '../../../../utils/models/equipamento/equipamento.dart';
import '../../../../utils/models/paciente/paciente.dart';

class EditarStatus extends StatefulWidget {
  final Equipamento equipamento;
  final String q;
  final Function(Paciente?) definirPacienteResponsavel;

  const EditarStatus(
    this.equipamento,
    this.q,
    this.definirPacienteResponsavel, {
    Key? key,
  }) : super(key: key);

  @override
  _EditarStatusState createState() => _EditarStatusState();
}

class _EditarStatusState extends State<EditarStatus> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> map_equipamento = widget.equipamento.infoMap;

    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Row(
        children: [
          Text(
            '${widget.q} : ',
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: DropdownButton<String>(
              value: widget.equipamento.status.emString,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(
                color: Colors.deepPurple,
                fontSize: 30,
              ),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) async {
                map_equipamento['Status'] = newValue!;
                if (newValue == "Emprestado") {
                  Paciente? pacienteEscolhido =
                      await mostrarDialogEscolherPaciente(context);
                  newValue =
                      pacienteEscolhido != null ? newValue : "Disponível";
                  if (pacienteEscolhido != null) {
                    try {
                      widget.equipamento.status =
                          StatusDoEquipamento.emprestado;
                      await widget.equipamento.emprestarPara(pacienteEscolhido);
                    } catch (erro) {
                      widget.equipamento.status =
                          StatusDoEquipamento.disponivel;
                      mostrarMensagemErro(context, erro.toString());
                    }

                    widget.definirPacienteResponsavel(pacienteEscolhido);
                  }
                } else {
                  try {
                    await widget.equipamento.devolver();
                    widget.equipamento.idPacienteResponsavel = null;
                    widget.definirPacienteResponsavel(null);
                  } catch (e) {
                    mostrarMensagemErro(context, e.toString());
                  }
                }
              },
              items: <String>[
                'Disponível',
                'Emprestado',
                'Desinfecção',
                'Manutenção',
              ].map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
