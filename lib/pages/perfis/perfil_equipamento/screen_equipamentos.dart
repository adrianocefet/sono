import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/atributo_equip.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/detalhe_do_status.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/editar_atributo_equip.dart';
import 'package:sono/utils/models/paciente/paciente.dart';
import 'package:sono/utils/services/firebase.dart';

import '../../../constants/constants.dart';
import '../../../utils/models/equipamento/equipamento.dart';
import '../../../utils/models/user_model.dart';
import 'widgets/editar_status.dart';

class ScreenEquipamento extends StatefulWidget {
  final String idEquipamento;
  const ScreenEquipamento(
    this.idEquipamento, {
    Key? key,
  }) : super(key: key);

  @override
  _ScreenEquipamentosState createState() => _ScreenEquipamentosState();
}

class _ScreenEquipamentosState extends State<ScreenEquipamento> {
  Paciente? _pacienteResponsavel;

  void _definirPacienteResponsavel(Paciente? novoPacienteResponsavel) =>
      setState(
        () {
          _pacienteResponsavel =
              novoPacienteResponsavel ?? _pacienteResponsavel;
        },
      );

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return StreamBuilder(
          stream: FirebaseService.streamEquipamento(
            widget.idEquipamento,
          ),
          builder: (
            context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
          ) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                Map<String, dynamic> dadosEquipamento = snapshot.data!.data()!;
                dadosEquipamento["id"] = snapshot.data!.id;

                Equipamento equipamento = Equipamento.fromMap(dadosEquipamento);

                return Scaffold(
                  appBar: AppBar(
                    title: Text(equipamento.nome),
                    actions: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            model.editar
                                ? model.editar = false
                                : model.editar = true;
                          });
                          if (!model.editar) {
                            print(equipamento.infoMap);
                            FirebaseService.atualizarEquipamento(equipamento);
                          }
                        },
                        icon: model.editar
                            ? const Icon(Icons.save)
                            : const Icon(Icons.edit),
                      )
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 10.0,
                              ),
                              child: Image.network(
                                equipamento.urlFotoDePerfil ?? model.semimagem,
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.width * 0.5,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        equipamento.nome,
                                        style: const TextStyle(
                                          fontSize: 40,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                for (String atrib
                                    in Constants.titulosAtributosEquipamentos)
                                  model.editar
                                      ? EditarAtributoEquipamento(
                                          equipamento,
                                          atrib,
                                        )
                                      : atrib == "Nome"
                                          ? Container()
                                          : atrib == "Status"
                                              ? EditarStatus(
                                                  equipamento,
                                                  "Status",
                                                  _definirPacienteResponsavel,
                                                )
                                              : AtributoEquipamento(
                                                  equipamento,
                                                  atrib,
                                                ),
                                Visibility(
                                  visible: equipamento.idPacienteResponsavel != null,
                                  child: DisplayDetalheDoStatus(
                                    equipamento: equipamento,
                                  ),
                                ),
                                const Divider(
                                  thickness: 5,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ],
                        ),
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
