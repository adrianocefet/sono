import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sono/pages/perfis/perfil_equipamento/relatorio/DadosTeste/classeEquipamentoteste.dart';

import '../../../../constants/constants.dart';
import '../tela_equipamento.dart';

class ItemEquipamento extends StatefulWidget {

  final Equipamento equipamento;
  const ItemEquipamento({required this.equipamento,Key? key}) : super(key: key);

  @override
  State<ItemEquipamento> createState() => _ItemEquipamentoState();
}

class _ItemEquipamentoState extends State<ItemEquipamento> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        splashColor: Constantes.corAzulEscuroSecundario,
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>TelaEquipamento(equipamento:widget.equipamento)));
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
                  child: Text(widget.equipamento.tipo=='Aparelho PAP'?'${widget.equipamento.tipoPap} ${widget.equipamento.nome}':widget.equipamento.nome,
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
                            widget.equipamento.foto,
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
                                color: Constantes.cor[Constantes.status2.indexOf(widget.equipamento.status)],
                              ),
                              child: Icon(
                                Constantes.icone[Constantes.status2.indexOf(widget.equipamento.status)],
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
                                widget.equipamento.tipo!='Aparelho PAP'?
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
                                      child: Text(widget.equipamento.tamanho,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 10),),
                                    ),
                                  ],
                                ):Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Fabricante",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Color.fromARGB(221, 137, 137, 137),decoration: TextDecoration.underline),),
                                        Text(widget.equipamento.fabricante??"Sem nome",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300,color: Colors.black),),
                                      ],
                                    ),   
                                
                                Visibility(
                                  visible: Constantes.status2.indexOf(widget.equipamento.status)==1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Paciente emprestado",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Color.fromARGB(221, 137, 137, 137),decoration: TextDecoration.underline),),
                                        Text(widget.equipamento.paciente??"Sem nome",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300,color: Colors.black),),
                                      ],
                                    ),
                                  )),
                                Visibility(
                                  visible: Constantes.status2.indexOf(widget.equipamento.status)>1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Empresa da ${widget.equipamento.status}",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Color.fromARGB(221, 137, 137, 137),decoration: TextDecoration.underline),),
                                        Text(widget.equipamento.empresa??"Sem nome",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300,color: Colors.black),),
                                      ],
                                    ),
                                  )),
                                Visibility(
                                  visible: Constantes.status2.indexOf(widget.equipamento.status)!=0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Data de despache",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Color.fromARGB(221, 137, 137, 137),decoration: TextDecoration.underline),),
                                        Text(widget.equipamento.data??"Sem data",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300,color: Colors.black),),
                                      ],
                                    ),
                                  )),
                                Visibility(
                                  visible: Constantes.status2.indexOf(widget.equipamento.status)==1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Médico responsável",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Color.fromARGB(221, 137, 137, 137),decoration: TextDecoration.underline),),
                                        Text(widget.equipamento.medico??"Sem nome",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w300,color: Colors.black),),
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
    );
  }
}