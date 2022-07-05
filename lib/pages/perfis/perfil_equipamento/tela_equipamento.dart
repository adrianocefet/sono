import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/perfis/perfil_equipamento/relatorio/DadosTeste/classeEquipamentoteste.dart';
import 'package:sono/pdf/pdf_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../pdf/tela_pdf.dart';

class TelaEquipamento extends StatefulWidget {
  final Equipamento equipamento;
  const TelaEquipamento(
      {required this.equipamento,
      Key? key})
      : super(key: key);

  @override
  State<TelaEquipamento> createState() => _TelaEquipamentoState();
}

class _TelaEquipamentoState extends State<TelaEquipamento> {
  late YoutubePlayerController controller;
  

  @override
  Widget build(BuildContext context) {
    controller = YoutubePlayerController(
    initialVideoId: YoutubePlayer.convertUrlToId(widget.equipamento.video??'https://www.youtube.com/watch?v=8SnRSVeJeAY&t=3s')!,
    flags: YoutubePlayerFlags(
      autoPlay: false,
      loop: false,
      hideControls: false
    )
    );
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: controller), 
      builder: (context, player)=>Scaffold(
      appBar: AppBar(
        title: Text(widget.equipamento.nome),
        centerTitle: true,
        backgroundColor: Constantes.corAzulEscuroPrincipal,
      ),
      body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromARGB(255, 194, 195, 255), Colors.white],
                  stops: [0, 0.4])),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    widget.equipamento.foto,
                                    width: MediaQuery.of(context).size.width *
                                        0.26,
                                    height: MediaQuery.of(context).size.height *
                                        0.14,
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
                                        color:
                                            Constantes.corAzulEscuroPrincipal,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: Constantes.cor[Constantes.status2.indexOf(widget.equipamento.status)],
                                        ),
                                        child: Icon(
                                          Constantes.icone[Constantes.status2.indexOf(widget.equipamento.status)],
                                          size: 20,
                                          color:
                                              Constantes.corAzulEscuroPrincipal,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Text(
                                    widget.equipamento.nome,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text("Status: " +
                                    Constantes.status2[Constantes.status2.indexOf(widget.equipamento.status)])
                              ],
                            ),
                            Material(
                                child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.qr_code,
                                color: Constantes.corAzulEscuroPrincipal,
                                size: 30,
                              ),
                              splashColor: Constantes.corAzulEscuroPrincipal,
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Fabricante",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(221, 171, 171, 171)),
                        ),
                        Divider(),
                        Text(
                          widget.equipamento.fabricante??'Sem nome',
                          style: TextStyle(fontSize: 12),
                        ),
                          Visibility(
                            visible: widget.equipamento.tipo!='Aparelho PAP',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                              Text(
                            "Tamanho",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(221, 171, 171, 171)),
                                                  ),
                                                  Divider(),
                                                  Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Constantes.corAzulEscuroPrincipal,
                              ),
                              color: Constantes.corAzulEscuroSecundario,
                            ),
                            alignment: Alignment.center,
                            height: 20,
                            width: 40,
                            child: Text(
                              widget.equipamento.tamanho,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize: 15),
                            ),
                                                  ),
                            ],
                                                  ),
                          ),
                        
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Descrição",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(221, 171, 171, 171)),
                        ),
                        Divider(),
                        Text(
                          "${widget.equipamento.nome} foi desenvolvido pela fabricante ${widget.equipamento.fabricante} para oferecer conforto e facilidade de uso. Com design diferenciado, o produto é leve e foi projetada para tornar tudo mais simples e mais confortável.",
                          style: TextStyle(fontSize: 12),
                        ),
                        Visibility(
                          visible: Constantes.status2.indexOf(widget.equipamento.status) == 0,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: const Color.fromRGBO(97, 253, 125, 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        )),
                                    onPressed: () {},
                                    child: const Text(
                                      "Solicitar empréstimo",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: const Color.fromRGBO(97, 253, 125, 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        )),
                                    onPressed: () {},
                                    child: const Text(
                                      "Solicitar reparo",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width, 
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: const Color.fromRGBO(97, 253, 125, 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        )),
                                    onPressed: () {},
                                    child: const Text(
                                      "Solicitar desinfecção",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: Constantes.status2.indexOf(widget.equipamento.status)>0,
                  child: Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  color: Constantes.corAzulEscuroSecundario,
                                ),
                                height: 30,
                                child: Text(
                                  "Detalhes",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),
                                  ),
                            ),
                          Visibility(
                            visible: Constantes.status2.indexOf(widget.equipamento.status)==1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(25),
                                          child: Image.network(
                                            widget.equipamento.imagempaciente??"https://cdn-icons-png.flaticon.com/512/17/17004.png",
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: 20,),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width * 0.6,
                                          child: Text(
                                            widget.equipamento.paciente??"Sem nome",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                  const Padding(
                                    padding: EdgeInsets.only(top:8.0),
                                    child: Text("Médico responsável",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Constantes.corAzulEscuroSecundario ,
                                        decoration: TextDecoration.underline
                                    ),
                                    ),
                                  ),
                                  Text(widget.equipamento.medico??"Sem nome"),
                                  const Padding(
                                    padding: EdgeInsets.only(top:8.0),
                                    child: Text("Data expedição",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Constantes.corAzulEscuroSecundario,
                                        decoration: TextDecoration.underline
                                    ),
                                    ),
                                  ),
                                  Text(widget.equipamento.data??"01/01/2022"),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: Constantes.status2.indexOf(widget.equipamento.status)>1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(25),
                                          child: Image.network(
                                            "https://www.onze.com.br/blog/wp-content/uploads/2019/11/shutterstock_1413966269.jpg",
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(width: 20,),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width * 0.6,
                                          child: Text(
                                            widget.equipamento.empresa??"Empresa sem nome",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                  Visibility(
                                    visible: Constantes.status2.indexOf(widget.equipamento.status)==3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top:8.0),
                                          child: Text("Previsão de entrega",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Constantes.corAzulEscuroSecundario ,
                                              decoration: TextDecoration.underline
                                          ),
                                          ),
                                        ),
                                        Text("01/10/2022"),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top:8.0),
                                    child: Text("Data expedição",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Constantes.corAzulEscuroSecundario,
                                        decoration: TextDecoration.underline
                                    ),
                                    ),
                                  ),
                                  Text(widget.equipamento.data??"01/01/2022"),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: const Color.fromRGBO(97, 253, 125, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0),
                                    )),
                                onPressed: () {},
                                child: const Text(
                                  "Disponibilizar",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                      ]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1)),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: const 
                            BoxDecoration(
                              borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            color: Constantes.corAzulEscuroSecundario,),
                            height: 30,
                            child: Text("Manual do equipamento",style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:4.0),
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.picture_as_pdf,color: Colors.black,),
                            style: ElevatedButton.styleFrom(
                                          primary: const Color.fromRGBO(97, 253, 125, 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          )),
                            onPressed:widget.equipamento.manual!=null?()async{
                              final url = widget.equipamento.manual!;
                              final arquivo = await PDFapi.carregarLink(url);
                              abrirPDF(context, arquivo);
                            }:null, 
                            label: Text(widget.equipamento.manual!=null?"Visualizar PDF":"PDF indisponível",style: TextStyle(color: Colors.black),)),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.equipamento.video!=null,
                  child: Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Constantes.corAzulEscuroSecundario,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1)),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: const 
                              BoxDecoration(
                                borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              color: Constantes.corAzulEscuroSecundario,),
                              height: 30,
                              child: Text("Modo de uso",style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom:30.0),
                            child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  child: player,
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    ));
  }

  void abrirPDF(BuildContext context, File arquivo)=> Navigator.push(context, MaterialPageRoute(builder: (context)=>TelaPDF(arquivo: arquivo)));
}
