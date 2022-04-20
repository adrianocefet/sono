import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../constants/constants.dart';
import '../helpers/registro_equipamento_helper.dart';
import '../helpers/resposta_widget.dart';
import '../models/user_model.dart';
import '../services/firebase.dart';
import 'aviso_ja_possui_equipamento.dart';
import 'carregando.dart';
import 'error_message.dart';

class EditarFoto extends StatefulWidget {
  final String identificador;
  final String idIdentificador;
  const EditarFoto(this.idIdentificador,this.identificador,{ Key? key }) : super(key: key);

  @override
  State<EditarFoto> createState() => _EditarFotoState();
}

class _EditarFotoState extends State<EditarFoto> {
  String? singleImage;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
      return StreamBuilder(
        stream: FirebaseService.streamEquipamento(
            widget.idIdentificador,
          ),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,) {
              return Column(
            children:[ 
              IconButton(
                    iconSize: widget.identificador=='Paciente'? 50 : 100 ,
                    onPressed: (){
                      showModalBottomSheet(
                        context: context, 
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text("Câmera"),
                              onTap: ()async{
                                XFile? _imagem = await FirebaseService().selecionarArquivoCamera();
                                if(_imagem!=null && _imagem.path.isNotEmpty){
                                  Navigator.pop(context);
                                  confirmarFoto(_imagem,widget.idIdentificador,widget.identificador);
                                  setState(() {});
                                }
                              },
                              ),
                            ListTile(
                              leading: Icon(Icons.photo),
                              title: Text("Galeria"),
                              onTap: ()async{
                                XFile? _imagem = await FirebaseService().selecionarArquivoGaleria();
                                if(_imagem!=null && _imagem.path.isNotEmpty){
                                  Navigator.pop(context);
                                  confirmarFoto(_imagem,widget.idIdentificador,widget.identificador);
                                  setState(() {});
                                }
                              },
                            )
                          ],
                        )
                        );
                      }, 
                    icon: Icon(Icons.camera_alt),),
                    
          ]);
          }
         
      ); },
    );
  }

  void confirmarFoto(XFile imagem,String idIdentificador,String identificador) {
    String? singleImage;
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return ScopedModelDescendant<UserModel>(
        builder: (context, child, model) => AlertDialog(
          title: const Text('Alterar foto atual?'),
          contentPadding: EdgeInsets.symmetric(vertical: 20),
          content: imagem.path!=null && imagem.path.isNotEmpty ? 
              Container(
                color: Color.fromARGB(255, 220, 220, 220),
                child: Image.file(
                  File(imagem.path),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                ),
              )
          : SizedBox.shrink(),
          actions: [
            TextButton(
              child: const Text("Alterar"),
              onPressed: ()async{
                mostrarDialogCarregando(context);
                if(identificador=="Equipamento"){
                  singleImage = await FirebaseService().uparArquivoEquipamento(imagem,idIdentificador);
                  await FirebaseService().atualizarFotoEquipamento(idIdentificador, singleImage!);
                }else{
                  singleImage = await FirebaseService().uparArquivoPaciente(imagem,idIdentificador);
                  await FirebaseService().atualizarFotoPaciente(idIdentificador, singleImage!);
                }
                Navigator.pop(context,true);
                Navigator.pop(context);
              }
            ),
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    },
  );
  }
}



