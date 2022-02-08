import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/paciente/paciente.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:sono/widgets/dialogs/escolher_paciente_dialog.dart';

Map<String, dynamic> map_equipamento = {};
Map<String, dynamic> map_paciente = {};
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
      map_equipamento = data;
    }).toList();

    /*
    FirebaseFirestore.instance
        .collection('Paciente')
        //.where('Hospital',isEqualTo: model.hospital)
        //.where('Hospital',isEqualTo: 'HUWC')
        .snapshots()
        .map((QuerySnapshot document) {
      Map<String, dynamic> data = document.docs as Map<String, dynamic>;
      map_paciente = data;
    }).toList();*/

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
              //print('equipamento');
              //print(map_equipamento.toString());
              //print('paciente');
              //print(map_paciente.toString());
              return Scaffold(
                appBar: AppBar(
                  title: Text(map_equipamento['Nome'] ?? 'sem nome'),
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
                                update(map_equipamento);
                            print(map_equipamento.toString());
                          }
                        },
                        icon:
                            model.editar ? Icon(Icons.edit) : Icon(Icons.save))
                  ],
                ),
                body: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints viewportConstraints) {
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Image.network(
                                    map_equipamento['Foto'] ?? model.semimagem,
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: MediaQuery.of(context).size.width *
                                        0.25,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                              //Scrollable(viewportBuilder: viewportBuilder),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          map_equipamento['Nome'] ?? 'sem nome',
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
                                    //Divider(thickness: 5,color: Colors.black,),
                                    model.editar
                                        ? questao1('Status')
                                        : questao2('Status'),
                                    fazPaciente(),
                                    model.editar
                                        ? questao1('Data do Status')
                                        : questao1('Data do Status'),
                                    Divider(
                                      thickness: 5,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ) //coluna
                      );
                }),
              );
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
          initialValue: map_equipamento[q] ?? '',
          decoration: InputDecoration(
            hintText: map_equipamento[q] ?? '',
            border: OutlineInputBorder(),
            labelStyle:
                TextStyle(color: Color.fromRGBO(88, 98, 143, 1), fontSize: 14),
          ),
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          onSaved: (value) => map_equipamento[q] = value,
          onChanged: (value) => map_equipamento[q] = value,
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
        map_equipamento[q] ?? '',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    ],
  );
}

Widget fazPaciente() {
  FirebaseFirestore.instance
      .collection('Paciente')
      .doc(map_equipamento['ID do Status'] ?? 'IdSemPaciente')
      .snapshots()
      .map((DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    map_paciente = data;
  }).toList();

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Divider(
        thickness: 5,
        color: Colors.black,
      ),
      Row(
        children: [
          const Text(
            'Detalhe do Status',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ],
      ),
      Divider(
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
          Text(
            'Nome : ',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          Text(
            map_paciente['Nome'] ?? 'Sem Nome',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    ],
  );
}

class questao2 extends StatefulWidget {
  final String q = '';

  const questao2(q, {Key? key}) : super(key: key);

  @override
  _questao2State createState() => _questao2State();
}

class _questao2State extends State<questao2> {
  @override
  Widget build(BuildContext context) {
    Widget questao2(String q) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            '$q : ',
          ),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropdownButton<String>(
                    value: map_equipamento[q] ?? 'Disponível',
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() async {
                        map_equipamento['Status'] = newValue!;
                        Paciente? pacienteEscolhido = await mostrarDialogEscolherPaciente(context);
                        map_equipamento['ID do Status'] = pacienteEscolhido?.id;
                        print(map_equipamento.toString());
                        
                      });
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
                        child: Text(value),
                      );
                    }).toList(),
                  ))),
        ],
      );
    }

    return questao2(widget.q);
  }
}

Widget questao3(String q) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    children: [
      Text(
        '$q : ',
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: DropdownButton<String>(
            value: map_equipamento[q] ?? 'Disponível',
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? newValue) {
              map_equipamento[q] = newValue!;
            },
            items: <String>[
              'Disponível',
              'Emprestado',
              'Desinfecção',
              'Manutenção'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    ],
  );
}
