import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/helpers/respostas.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/paciente/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:sono/widgets/dialogs/escolher_paciente_dialog.dart';
import '../../../constants/constants.dart';

Map<String, dynamic> map_equipamento = {};
Map<String, dynamic> map_paciente = {};

class ScreenEquipamento extends StatefulWidget {
  const ScreenEquipamento(this.idEquipamento, {Key? key}) : super(key: key);

  final String idEquipamento;

  @override
  _ScreenEquipamentoState createState() => _ScreenEquipamentoState();
}

class _ScreenEquipamentoState extends State<ScreenEquipamento> {
  void _recarregarPagina() => setState(() {});

  @override
  Widget build(BuildContext context) {
    //late Equipamento equipamento;

    FirebaseFirestore.instance
        .collection('Equipamento')
        .doc(widget.idEquipamento)
        .snapshots()
        .map(
      (DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        map_equipamento = map_equipamento.isEmpty ? data : map_equipamento;
        //equipamento = Equipamento.fromMap(data);
      },
    ).toList();

    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Equipamento')
              .doc(widget.idEquipamento)
              .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                print('equipamento');
                print(map_equipamento.toString());
                print('paciente');
                print(map_paciente.toString());
                return Scaffold(
                  appBar: AppBar(
                    title: Text(map_equipamento['Nome'] ?? "Sem nome"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          setState(
                            () {
                              model.editar
                                  ? model.editar = false
                                  : model.editar = true;
                            },
                          );
                          if (model.editar) {
                            FirebaseFirestore.instance
                                .collection('Equipamento')
                                .doc(widget.idEquipamento)
                                .update(map_equipamento);
                            print(map_equipamento.toString());
                          }
                        },
                        icon: model.editar
                            ? const Icon(Icons.save)
                            : const Icon(Icons.edit),
                      )
                    ],
                  ),
                  body: LayoutBuilder(
                    builder: (BuildContext context,
                        BoxConstraints viewportConstraints) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Form(
                                child: Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: FittedBox(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10.0,
                                              ),
                                              child: Image.network(
                                                map_equipamento['Foto'] ??
                                                    model.semimagem,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FittedBox(
                                                  child: Text(
                                                    map_equipamento['Nome'] ??
                                                        "Sem nome",
                                                    style: const TextStyle(
                                                      fontSize: 40,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            for (String atrib in Constants
                                                .titulosAtributosEquipamentos)
                                              model.editar
                                                  ? editarAtributo(
                                                      context, atrib)
                                                  : atrib == "Nome"
                                                      ? Container()
                                                      : atrib == "Status"
                                                          ? EditarStatus(
                                                              "Status",
                                                              _recarregarPagina,
                                                            )
                                                          : atributo(atrib),
                                            const DetalheDoStatus(),
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
    mainAxisSize: MainAxisSize.max,
    children: [
      Text(
        '$q : ',
        style: const TextStyle(
          fontSize: 30,
        ),
      ),
      Text(
        map_equipamento[q] ?? '',
        style: const TextStyle(
          fontSize: 25,
        ),
      ),
    ],
  );
}

class DetalheDoStatus extends StatefulWidget {
  const DetalheDoStatus({Key? key}) : super(key: key);

  @override
  _DetalheDoStatusState createState() => _DetalheDoStatusState();
}

class _DetalheDoStatusState extends State<DetalheDoStatus> {
  @override
  Widget build(BuildContext context) {
    print(map_equipamento);
    print(map_equipamento['ID do Status'] ?? "sem paciente");
    FirebaseFirestore.instance
        .collection('Paciente')
        .doc(map_equipamento['ID do Status'] ?? 'IdSemPaciente')
        .snapshots()
        .map(
      (DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

        map_paciente = data;
        print(map_paciente);
      },
    ).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
              map_paciente['Foto'] ??
                  'https://toppng.com/uploads/preview/app-icon-set-login-icon-comments-avatar-icon-11553436380yill0nchdm.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              'Nome : ',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Text(
              map_paciente['Nome'] ?? 'Sem Nome',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class EditarStatus extends StatefulWidget {
  //final Equipamento equipamento;
  final String q;
  final Function() recarregarPagina;

  const EditarStatus(
    //this.equipamento,
    this.q,
    this.recarregarPagina, {
    Key? key,
  }) : super(key: key);

  @override
  _EditarStatusState createState() => _EditarStatusState();
}

class _EditarStatusState extends State<EditarStatus> {
  @override
  Widget build(BuildContext context) {
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
              value: map_equipamento[widget.q] ?? 'Disponível',
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
                if (newValue == "Emprestado") {
                  Paciente? pacienteEscolhido =
                      await mostrarDialogEscolherPaciente(context);
                  newValue =
                      pacienteEscolhido != null ? newValue : "Disponível";
                  map_equipamento['ID do Status'] = pacienteEscolhido?.id;
                  map_paciente = pacienteEscolhido?.infoMap ?? {};
                  //await Equipamento.fromMap(map_equipamento);
                } else {
                  map_equipamento['ID do Status'] = null;
                  map_paciente.clear();
                }

                map_equipamento['Status'] = newValue!;
                print(map_equipamento.toString());
                widget.recarregarPagina();
                //map_equipamento[q] = newValue!;
              },
              items: <String>[
                'Disponível',
                'Emprestado',
                'Desinfecção',
                'Manutenção'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
