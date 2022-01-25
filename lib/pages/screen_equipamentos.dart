import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/model.dart';

Map<String, dynamic> respostas = {};
String ID = 'Adriano';

class ScreenEquipamento extends StatefulWidget {
  ScreenEquipamento(this.idPaciente);

  final String idPaciente;

  @override
  _ScreenEquipamentoState createState() => _ScreenEquipamentoState();
}

class _ScreenEquipamentoState extends State<ScreenEquipamento> {
  @override
  Widget build(BuildContext context) {
    ID = widget.idPaciente;
    FirebaseFirestore.instance
        .collection('Equipamento')
        .doc(ID)
        .snapshots()
        .map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      respostas = data;
    }).toList();

    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Equipamento')
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
                    title: Text(respostas['Nome'] ?? 'sem nome'),
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
                                  .collection('Equipamento')
                                  .doc(widget.idPaciente)
                                  .
                              //update({'Nome':'Adriano'});
                              update(respostas);
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
                                            respostas['Foto'] ??
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
                                                  respostas['Nome'] ??
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
                                                ? questao1('Descrição')
                                                : questao('Descrição'),
                                            model.editar
                                                ? questao1('Equipamento')
                                                : questao('Equipamento'),
                                            model.editar
                                                ? questao1('Status')
                                                : questao('Status'),
                                            model.editar
                                                ? questao1('Data do Status')
                                                : questao('Data do Status'),
                                            model.editar
                                                ? questao1('ID do Status')
                                                : questao('ID do Status'),
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
              initialValue: respostas[q] ?? '',
              decoration: InputDecoration(
                hintText: respostas[q] ?? '',
                border: OutlineInputBorder(),
                labelStyle:
                TextStyle(color: Color.fromRGBO(88, 98, 143, 1), fontSize: 14),
              ),
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              onSaved: (value) => respostas[q] = value,
              onChanged: (value) => respostas[q] = value,
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
        respostas[q] ?? '',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    ],
  );
}
