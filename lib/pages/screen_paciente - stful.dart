import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/model.dart';

class ScreenPaciente extends StatefulWidget {
  //const ScreenPaciente({Key? key}) : super(key: key);
  ScreenPaciente(this.idPaciente);
  final String idPaciente;


  @override
  _ScreenPacienteState createState() => _ScreenPacienteState();
}

class _ScreenPacienteState extends State<ScreenPaciente> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return StreamBuilder<DocumentSnapshot>(
        stream:
        FirebaseFirestore.instance.collection('Paciente').doc(widget.idPaciente).snapshots(),
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
                    title: Text(snapshot.data!['Nome']),
                    actions: [
                      IconButton(
                          onPressed: (){
                            //if model.hospital == 'HAVC' Then model.hospital = 'teste';

                            FirebaseFirestore.instance.collection('Paciente').doc(widget.idPaciente).
                            update({
                              'teste':'teste'
                            });
                          },
                          icon: Icon(Icons.edit))
                    ],
                  ),
                  body: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text(snapshot.data!['Hospital']),
                        Text(' - Nome: '),
                        Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration.collapsed(hintText: snapshot.data!['Nome']),
                              onChanged: (text){
                              },
                              onSubmitted: (text){
                              },
                            )
                        ),
                        /*IconButton(
                            onPressed: (){
                            },
                            icon: Icon(Icons.send)
                        )*/
                      ]
                  )
              );
          }
        },
      );
    });
  }
}



