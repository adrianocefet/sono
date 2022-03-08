import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_rich_text/simple_rich_text.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/services/firebase.dart';
import 'package:sono/widgets/dialogs/error_message.dart';

import '../../perfil_paciente/dialogs/devolver_equipamento_dialog.dart';

class DisplayDetalheDoStatus extends StatefulWidget {
  final Equipamento equipamento;
  const DisplayDetalheDoStatus({
    Key? key,
    required this.equipamento,
  }) : super(key: key);

  @override
  _DisplayDetalheDoStatusState createState() => _DisplayDetalheDoStatusState();
}

class _DisplayDetalheDoStatusState extends State<DisplayDetalheDoStatus> {
  // Paciente? pacienteResponsavel;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: () async {
        return await FirebaseService().obterPacientePorID(
          widget.equipamento.idPacienteResponsavel!,
        );
      }(),
      builder: (context, AsyncSnapshot<Paciente> snapshot) {
        if (snapshot.hasError) {
          mostrarMensagemErro(context, snapshot.error.toString());
          return Container();
        } else if (snapshot.hasData) {
          Paciente? pacienteResponsavel = snapshot.data;
          return Column(
            children: [
              const Divider(
                thickness: 5,
                color: Colors.black,
              ),
              Row(
                children: const [
                  Text(
                    'Detalhe do Status',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 5,
                color: Colors.black,
              ),
              Row(
                children: [
                  Image.network(
                    pacienteResponsavel != null &&
                            pacienteResponsavel.urlFotoDePerfil != null
                        ? pacienteResponsavel.urlFotoDePerfil!
                        : 'https://toppng.com/uploads/preview/app-icon-set-login-icon-comments-avatar-icon-11553436380yill0nchdm.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              Text(
                '''

Paciente Responsável: ${pacienteResponsavel!.nome}

Data de Expedicão: ${widget.equipamento.dataDeExpedicaoEmStringFormatada}

Data de Devolução: ${widget.equipamento.dataDeDevolucaoEmStringFormatada}''',
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async => await mostrarDialogDevolverEquipamento(
                    context, widget.equipamento),
                child: const Text(
                  "Cancelar empréstimo",
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
