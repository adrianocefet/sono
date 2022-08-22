import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sono/utils/models/solicitacao.dart';

import '../../../../utils/dialogs/carregando.dart';
import '../../../../utils/dialogs/error_message.dart';
import '../../../../utils/models/equipamento.dart';
import '../../../../utils/services/firebase.dart';

Future negarSolicitacao(BuildContext context,Solicitacao solicitacao)async{
  final TextEditingController _Textcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  return await showDialog(
    context: context, 
    builder: (BuildContext context){
      return Center(
        child: Container(
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Material(
            borderRadius: const BorderRadius.all(Radius.circular(20),),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(17),
                        topRight: Radius.circular(17),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: const Center(
                      child: Text(
                        'Adicione o motivo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:8.0),
                      child: TextFormField(
                        controller: _Textcontroller,
                        minLines: 2,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        validator: (value){
                          if(value!.isNotEmpty && value.length>5){
                            return null;
                          }else if(value.length<5){
                            return 'Digite uma justificativa mais detalhada!';
                          }else if(value.isEmpty){
                            return 'Campo vazio!';
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'Descreva o que houve para a solicitação ser negada',
                          hintStyle: TextStyle(
                            color: Colors.grey
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(17))
                          )
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:8.0),
                    child: ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          _formKey.currentState!.save();
                          mostrarDialogCarregando(context);
                          try{
                            solicitacao.infoMap['motivo']=_Textcontroller.value.text;
                            solicitacao.infoMap['confirmacao']='negado';
                            FirebaseService.atualizarSolicitacao(solicitacao);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }catch (e) {
                            Navigator.pop(context);
                            mostrarMensagemErro(context, e.toString());
                          }
                        }
                        
                      }, 
                      child: const Text('Negar',style: TextStyle(color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(97, 253, 125, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(18.0),
                        )),
                      ),
                  )
              ],
                      ),
            ),
        ),
      );
    });

}