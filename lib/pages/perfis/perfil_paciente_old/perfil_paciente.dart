import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/perfis/perfil_paciente/widgets/historico_de_questionarios.dart';
import 'package:sono/pages/perfis/perfil_paciente/widgets/uso_do_cpap.dart';
import 'package:sono/pages/perfis/perfil_paciente/widgets/visao_geral.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/user_model.dart';

class PerfilDoPaciente extends StatefulWidget {
  const PerfilDoPaciente(this.idPaciente, {Key? key}) : super(key: key);

  final String idPaciente;

  @override
  _PerfilDoPacienteState createState() => _PerfilDoPacienteState();
}

class _PerfilDoPacienteState extends State<PerfilDoPaciente> {


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Paciente')
              .doc(widget.idPaciente)
              .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                Paciente paciente =
                    Paciente.porDocumentSnapshot(snapshot.data!);
                debugPrint(snapshot.data!.data().toString());

                return DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(paciente.nome),
                      actions: [
                        IconButton(
                          onPressed: () {
                            if (model.editar) {
                              FirebaseFirestore.instance
                                  .collection('Paciente')
                                  .doc(widget.idPaciente)
                                  .update(paciente.infoMap);
                            }
                            setState(() {
                              model.editar
                                  ? model.editar = false
                                  : model.editar = true;
                            });
                          },
                          icon: model.editar
                              ? const Icon(Icons.save)
                              : const Icon(Icons.edit),
                        )
                      ],
                      bottom: const TabBar(
                        labelPadding: EdgeInsets.only(bottom: 10),
                        tabs: [
                          Text(
                            "Visão Geral",
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Uso do CPAP",
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Histórico de Questionários",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        PacienteVisaoGeral(
                          paciente: paciente,
                          model: model,
                        ),
                        UsoDoCPAP(
                          paciente: paciente,
                          model: model,
                        ),
                        HistoricoDeQuestionarios(
                          paciente: paciente,
                          model: model,
                        )
                      ],
                    ),
                  ),
                );
            }
          },
        );
      },
    );
  }
}