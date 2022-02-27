import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/perfis/perfil_paciente/widgets/atributo_paciente.dart';
import 'package:sono/pages/perfis/perfil_paciente/widgets/editar_atributo_paciente.dart';
import 'package:sono/utils/models/paciente/paciente.dart';
import 'package:sono/utils/models/user_model.dart';
import 'widgets/equipamentos_emprestados.dart';

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
                return Scaffold(
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
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  paciente.urlFotoDePerfil ?? model.semimagem,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height:
                                      MediaQuery.of(context).size.width * 0.3,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    model.editar
                                        ? FittedBox(
                                            child: Text(
                                              paciente.nome,
                                              style: const TextStyle(
                                                fontSize: 40,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    for (String atrib
                                        in Constants.titulosAtributosPacientes)
                                      model.editar
                                          ? EditarAtributoPaciente(
                                              atributo: atrib,
                                              paciente: paciente,
                                            )
                                          : atrib == "Nome"
                                              ? Container()
                                              : AtributoPaciente(
                                                  atributo: atrib,
                                                  paciente: paciente,
                                                ),
                                    EquipamentosEmprestados(
                                      listaDeEquipamentos:
                                          paciente.equipamentosEmprestados,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
