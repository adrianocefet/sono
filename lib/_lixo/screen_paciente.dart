import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/user_model.dart';

Map<String, dynamic> mapPaciente = {};
String ID = 'Adriano';

class ScreenPaciente extends StatefulWidget {
  const ScreenPaciente(this.idPaciente, {Key? key}) : super(key: key);

  final String idPaciente;

  @override
  _ScreenPacienteState createState() => _ScreenPacienteState();
}

class _ScreenPacienteState extends State<ScreenPaciente> {
  @override
  Widget build(BuildContext context) {
    ID = widget.idPaciente;
    FirebaseFirestore.instance.collection('Paciente').doc(ID).snapshots().map(
      (DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        mapPaciente = data;
      },
    ).toList();

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
                    title: Text(mapPaciente['Nome'] ?? 'sem nome'),
                    actions: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            model.editar
                                ? model.editar = false
                                : model.editar = true;
                          });
                          if (model.editar) {
                            FirebaseFirestore.instance
                                .collection('Paciente')
                                .doc(widget.idPaciente)
                                .update(mapPaciente);
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
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  mapPaciente['Foto'] ?? model.semimagem,
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
                                              mapPaciente['Nome'] ?? 'sem nome',
                                              style: const TextStyle(
                                                fontSize: 40,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    for (String atrib
                                        in Constantes.titulosAtributosPacientes)
                                      model.editar
                                          ? editarAtributo(context, atrib)
                                          : atrib == "Nome"
                                              ? Container()
                                              : atributo(atrib),
                                    //EquipamentosEmprestados(mapaDeEquipamentos: widget.p,),
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

Widget editarAtributo(BuildContext context, String q) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$q : ',
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .65,
          child: TextFormField(
            minLines: 1,
            maxLines: 4,
            initialValue: mapPaciente[q] ?? '',
            decoration: InputDecoration(
              hintText: mapPaciente[q] ?? '',
              border: const OutlineInputBorder(),
              labelStyle: const TextStyle(
                color: Color.fromRGBO(88, 98, 143, 1),
                fontSize: 14,
              ),
            ),
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            onSaved: (value) => mapPaciente[q] = value,
            onChanged: (value) => mapPaciente[q] = value,
            //validator: (value) => value != '' ? null : 'Dado obrigatório.',
          ),
        ),
      ],
    ),
  );
}

Widget atributo(String q) {
  return Row(
    children: [
      Text(
        '$q : ',
        style: const TextStyle(
          fontSize: 30,
        ),
      ),
      Text(
        mapPaciente[q] ?? '',
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    ],
  );
}
