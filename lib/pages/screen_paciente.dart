import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/model.dart';

Map<String, dynamic> map_paciente = {};
String ID = 'Adriano';

class ScreenPaciente extends StatefulWidget {
  ScreenPaciente(this.idPaciente);

  final String idPaciente;

  @override
  _ScreenPacienteState createState() => _ScreenPacienteState();
}

class _ScreenPacienteState extends State<ScreenPaciente> {
  @override
  Widget build(BuildContext context) {
    ID = widget.idPaciente;
    FirebaseFirestore.instance
        .collection('Paciente')
        .doc(ID)
        .snapshots()
        .map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      map_paciente = data;
    }).toList();

    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Paciente')
            .doc(widget.idPaciente)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
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
                              ? Icon(Icons.edit)
                              : Icon(Icons.save))
                    ],
                  ),
                  body: LayoutBuilder(builder: (BuildContext context,
                      BoxConstraints viewportConstraints) {
                    return SingleChildScrollView(
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Form(
                              //key: _formKey,
                              child: Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Image.network(
                                            map_paciente['Foto'] ??
                                                model.semimagem,
                                            width:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                0.25,
                                            height:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                0.25,
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
                                      //Scrollable(viewportBuilder: viewportBuilder),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  map_paciente['Nome'] ??
                                                      'sem nome',
                                                  style: TextStyle(
                                                    fontSize: 40,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            model.editar
                                                ? Container()
                                                : questao('Nome'),
                                            model.editar
                                                ? questao1('Modo')
                                                : questao('Modo'),
                                            model.editar
                                                ? questao1('Pressão definida')
                                                : questao('Pressão definida'),
                                            model.editar
                                                ? questao1('EPR')
                                                : questao('EPR'),
                                            model.editar
                                                ? questao1('Utilização')
                                                : questao('Utilização'),
                                            model.editar
                                                ? questao1('Fuga mediana')
                                                : questao('Fuga mediana'),
                                            model.editar
                                                ? questao1('Fuga %95')
                                                : questao('Fuga %95'),
                                            model.editar
                                                ? questao1('Fuga máxima')
                                                : questao('Fuga máxima'),
                                            model.editar
                                                ? questao1('IAH')
                                                : questao('IAH'),
                                            model.editar
                                                ? questao1('IA')
                                                : questao('IA'),
                                            model.editar
                                                ? questao1('IH')
                                                : questao('IH'),
                                            model.editar
                                                ? questao1(
                                                'Índice de apneia central')
                                                : questao(
                                                'Índice de apneia central'),
                                            model.editar
                                                ? questao1(
                                                'Índice de apneia obstrutiva')
                                                : questao(
                                                'Índice de apneia obstrutiva'),
                                            model.editar
                                                ? questao1(
                                                'Índice de apneia desconhecida')
                                                : questao(
                                                'Índice de apneia desconhecida'),
                                            model.editar
                                                ? questao1('RERA')
                                                : questao('RERA'),
                                            model.editar
                                                ? questao1(
                                                'Respiração de Cheyne-Stockes')
                                                : questao(
                                                'Respiração de Cheyne-Stockes'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ) //coluna
                    );
                  })); //Scaffold
          }
        },
      );
    });
  } //build
} //class

Widget questao(String q) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    children: [
      Text(
        '$q : ',
      ),
      Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              minLines: 1,
              maxLines: 4,
              // expands: true,
              initialValue: map_paciente[q] ?? '',
              decoration: InputDecoration(
                hintText: map_paciente[q] ?? '',
                border: OutlineInputBorder(),
                labelStyle:
                TextStyle(color: Color.fromRGBO(88, 98, 143, 1), fontSize: 14),
              ),
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              onSaved: (value) => map_paciente[q] = value,
              onChanged: (value) => map_paciente[q] = value,
              //validator: (value) => value != '' ? null : 'Dado obrigatório.',
            ),
          )),
    ],
  );
}

Widget questao1(String q) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    children: [
      Text(
        '$q : ',
        style: TextStyle(
          fontSize: 30,
        ),
      ),
      Text(
        map_paciente[q] ?? '',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    ],
  );
}
