import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/user_model.dart';

import '../../../../constants/constants.dart';
import '../../../../utils/models/equipamento.dart';
import '../../../../utils/services/firebase.dart';
import '../tela_equipamento.dart';

class ItemEquipamento extends StatefulWidget {

  final String id;
  const ItemEquipamento({required this.id,Key? key}) : super(key: key);

  @override
  State<ItemEquipamento> createState() => _ItemEquipamentoState();
}

class _ItemEquipamentoState extends State<ItemEquipamento> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
      return StreamBuilder(
        stream: FirebaseService.streamEquipamento(
            widget.id
          ),
        builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,) {
          switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                Map<String, dynamic> dadosEquipamento = snapshot.data!.data()!;
                dadosEquipamento["id"] = snapshot.data!.id;

                Equipamento equipamento = Equipamento.porMap(dadosEquipamento);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: InkWell(
                    splashColor: Constantes.corAzulEscuroSecundario,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TelaEquipamento(id:widget.id)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 2,color: Constantes.corAzulEscuroPrincipal),
                              color: Colors.white
                            ),
                      //height: MediaQuery.of(context).size.height * 0.2,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight: Radius.circular(7),
                              ),
                              color: Constantes.corAzulEscuroSecundario,
                            ),
                            height: 25,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal:10.0),
                              child: Text(equipamento.nome,
                              maxLines: 1,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                                ),),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        equipamento.urlFotoDePerfil??model.semimagem,
                                        width: MediaQuery.of(context).size.width * 0.26,
                                        height: MediaQuery.of(context).size.height * 0.14,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: Constantes.corAzulEscuroPrincipal,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            color: Constantes.cor[Constantes.status3.indexOf(equipamento.status.emString)],
                                          ),
                                          child: Icon(
                                            Constantes.icone[Constantes.status3.indexOf(equipamento.status.emString)],
                                            size: 20,
                                            color: Constantes.corAzulEscuroPrincipal,),
                                        ),
                                      ))
                                  ],
                                  
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                    child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            model.tipo==Constantes.tipo[0]||model.tipo==Constantes.tipo[1]||model.tipo==Constantes.tipo[2]||model.tipo==Constantes.tipo[3]?
                                            Column(
                                              children: [
                                                Text("Tamanho",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Color.fromARGB(221, 137, 137, 137),decoration: TextDecoration.underline),),
                                                SizedBox(height: 8,),                    
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 1,color: Constantes.corAzulEscuroPrincipal,),
                                                    color: Constantes.corAzulEscuroSecundario,
                                                  ),
                                                  alignment: Alignment.center,
                                                  height: 15,
                                                  width: 30,
                                                  child: Text(equipamento.tamanho??"N/A",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 10),),
                                                ),
                                              ],
                                            ):Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Fabricante",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Color.fromARGB(221, 137, 137, 137),decoration: TextDecoration.underline),),
                                                    Text(equipamento.fabricante,style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300,color: Colors.black),),
                                                  ],
                                                ),   
                                            
                                            Visibility(
                                              visible: equipamento.idPacienteResponsavel!=null,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top:8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Paciente emprestado",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Color.fromARGB(221, 137, 137, 137),decoration: TextDecoration.underline),),
                                                    Text(equipamento.idPacienteResponsavel??"Sem nome",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300,color: Colors.black),),
                                                  ],
                                                ),
                                              )),
                                            Visibility(
                                              visible: Constantes.status3.indexOf(equipamento.status.emString)>1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top:8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Empresa responsável",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Color.fromARGB(221, 137, 137, 137),decoration: TextDecoration.underline),),
                                                    Text(equipamento.idEmpresaResponsavel??"Sem nome",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300,color: Colors.black),),
                                                  ],
                                                ),
                                              )),
                                            Visibility(
                                              visible: Constantes.status3.indexOf(equipamento.status.emString)!=0,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top:8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Data de despache",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Color.fromARGB(221, 137, 137, 137),decoration: TextDecoration.underline),),
                                                    Text(equipamento.idPacienteResponsavel??"Sem data",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300,color: Colors.black),),
                                                  ],
                                                ),
                                              )),
                                            Visibility(
                                              visible: Constantes.status3.indexOf(equipamento.status.emString)==1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top:8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Médico responsável",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Color.fromARGB(221, 137, 137, 137),decoration: TextDecoration.underline),),
                                                    Text(equipamento.idPacienteResponsavel??"Sem nome",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300,color: Colors.black),),
                                                  ],
                                                ),
                                              )),
                                          ],
                                        ),
                                      ),
                                Icon(Icons.arrow_forward_ios,color: Constantes.corAzulEscuroPrincipal,)
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                    ),
                );}
        }
      );},
    );
  }
}