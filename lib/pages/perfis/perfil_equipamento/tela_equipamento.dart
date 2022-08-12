import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import '../../../../utils/models/equipamento.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/qrCodeGerado.dart';
import 'package:sono/pdf/pdf_api.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../pdf/tela_pdf.dart';
import '../../../utils/services/firebase.dart';

class TelaEquipamento extends StatefulWidget {
  final String id;
  const TelaEquipamento(
      {required this.id,
      Key? key})
      : super(key: key);

  @override
  State<TelaEquipamento> createState() => _TelaEquipamentoState();
}

class _TelaEquipamentoState extends State<TelaEquipamento> {
  late YoutubePlayerController controller;
  double altura=200;
  bool clicado=false;
  bool videoExiste=true;
  String link='';

  _testarUrl(String value) {
   String pattern = r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
   RegExp regExp = new RegExp(pattern);
   if (!regExp.hasMatch(value)||value=='') {
    return false;
   }
   return true;
}

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
              controller = YoutubePlayerController(
              initialVideoId: YoutubePlayer.convertUrlToId(equipamento.videoInstrucional??'')??'',
              flags: YoutubePlayerFlags(
                autoPlay: false,
                loop: false,
                hideControls: false
              )
              );
              return Scaffold(
              appBar: AppBar(
                title: Text(equipamento.nome),
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
                                            equipamento.urlFotoDePerfil??model.semimagem,
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
                                                  color: Constantes.cor[Constantes.status3.indexOf(equipamento.status.emString)],
                                                ),
                                                child: Icon(
                                                  Constantes.icone[Constantes.status3.indexOf(equipamento.status.emString)],
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
                                            equipamento.nome,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text("Status: " +
                                            equipamento.status.emStringMaiuscula)
                                      ],
                                    ),
                                    Material(
                                        child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              qrCodeGerado(
                                                                idEquipamento:equipamento.id,
                                                              )));
                                      },
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
                                  equipamento.fabricante,
                                  style: TextStyle(fontSize: 12),
                                ),
                                  Visibility(
                                    visible: model.tipo!='Aparelho PAP',
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
                                      equipamento.tamanho??'N/A',
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
                                  equipamento.descricao??'Sem descrição',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Visibility(
                                  visible: equipamento.status==StatusDoEquipamento.disponivel,
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
                                              "Reparar",
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
                                              "Desinfectar",
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
                          visible: equipamento.status!=StatusDoEquipamento.disponivel,
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
                                    visible: equipamento.status==StatusDoEquipamento.emprestado,
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
                                                    equipamento.idPacienteResponsavel??"https://cdn-icons-png.flaticon.com/512/17/17004.png",
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
                                                    equipamento.idPacienteResponsavel??"Sem nome",
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
                                          Text(equipamento.idPacienteResponsavel??"Sem nome"),
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
                                          Text(equipamento.idPacienteResponsavel??"01/01/2022"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: equipamento.status==StatusDoEquipamento.manutencao && equipamento.status==StatusDoEquipamento.desinfeccao,
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
                                                    equipamento.idEmpresaResponsavel??"Empresa sem nome",
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
                                            visible: equipamento.status==StatusDoEquipamento.desinfeccao,
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
                                          Text(equipamento.idPacienteResponsavel??"01/01/2022"),
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
                                    onPressed:_testarUrl(equipamento.manualPdf??'')?()async{
                                      final url = equipamento.manualPdf!;
                                      final arquivo = await PDFapi.carregarLink(url);
                                      abrirPDF(context, arquivo);
                                    }:null, 
                                    label: Text(_testarUrl(equipamento.manualPdf??'')?"Visualizar PDF":"PDF indisponível",style: TextStyle(color: Colors.black),)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          // ignore: unrelated_type_equality_checks
                          visible: _testarUrl(equipamento.videoInstrucional??'')==true,
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
                                  YoutubePlayerBuilder(
                                  player: YoutubePlayer(controller: controller), 
                                  builder: (context, player)=>
                                  Padding(
                                    padding: const EdgeInsets.only(bottom:30.0),
                                    child: SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.5,
                                          child: player,
                                        ),
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: equipamento.observacao==null,
                          child: Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: AnimatedContainer(
                              constraints: BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height*0.2
                              ),
                              decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 1)),
                              duration: Duration(seconds: 2),
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
                                      child: Text("Observações",style: TextStyle(fontWeight: FontWeight.bold),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                    'Se a máscara ou arnês estiverem tocando sua pele e te incomodando, você pode comprar almofadas nasais para o encaixe ser melhor e, assim, reduzir a fricção contra a pele, você não precisa ter que aguentar isto. Você pode comprar acessórios para a máscara com almofadas nasais para que se encaixe no seu nariz e assim reduzir qualquer fricção contra sua pele. Se a máscara ou arnês estiverem tocando sua pele e te incomodando, você pode comprar almofadas nasais para o encaixe ser melhor e, assim, reduzir a fricção contra a pele, você não precisa ter que aguentar isto. Você pode comprar acessórios para a máscara com almofadas nasais para que se encaixe no seu nariz e assim reduzir qualquer fricção contra sua pele.'
                                    ,maxLines: clicado==true?null:3,
                                    overflow: clicado==true?null:TextOverflow.ellipsis,
                                    textAlign: TextAlign.justify,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical:8.0),
                                    child: ElevatedButton(
                                      onPressed: mostrarMais, 
                                      child: Text(clicado==true?'Mostrar menos':'Mostrar mais',style: TextStyle(color: Colors.black),),
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
                        ),
                      ],
                    ),
                  )),
                );
            }
    });},
    );
  }

  void abrirPDF(BuildContext context, File arquivo)=> Navigator.push(context, MaterialPageRoute(builder: (context)=>TelaPDF(arquivo: arquivo)));

  void mostrarMais(){
    setState(() {
      clicado = !clicado;
      clicado==true? altura=MediaQuery.of(context).size.height*0.5: altura=MediaQuery.of(context).size.height*0.2;
    });
  }
}
