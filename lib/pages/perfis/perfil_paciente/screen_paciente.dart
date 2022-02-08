import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/models/user_model.dart';

Map<String, dynamic> map_paciente = {};
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
        map_paciente = data;
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
                return Scaffold(
                  appBar: AppBar(
                    title: Text(map_paciente['Nome'] ?? 'sem nome'),
                    //Text(snapshot.data!['Nome']),
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
                                .
                                //update({'Nome':'Adriano'});
                                update(map_paciente);
                          }
                        },
                        icon: model.editar
                            ? const Icon(Icons.edit)
                            : const Icon(Icons.save),
                      )
                    ],
                  ),
                  body: LayoutBuilder(
                    builder: (BuildContext context,
                        BoxConstraints viewportConstraints) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              Form(
                                //key: _formKey,
                                child: Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          map_paciente['Foto'] ?? model.semimagem,
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.3,
                                          height:
                                              MediaQuery.of(context).size.width *
                                                  0.3,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            model.editar
                                                ? FittedBox(
                                                    child: Text(
                                                      map_paciente['Nome'] ??
                                                          'sem nome',
                                                      style: const TextStyle(
                                                        fontSize: 40,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            for (String atrib in Constants
                                                .titulosAtributosPacientes)
                                              !model.editar
                                                  ? editarAtributo(context, atrib)
                                                  : atrib == "Nome"
                                                      ? Container()
                                                      : atributo(atrib)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
            initialValue: map_paciente[q] ?? '',
            decoration: InputDecoration(
              hintText: map_paciente[q] ?? '',
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
            onSaved: (value) => map_paciente[q] = value,
            onChanged: (value) => map_paciente[q] = value,
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
        map_paciente[q] ?? '',
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    ],
  );
}
