import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/equipamento.dart';
import '../../../constants/constants.dart';
import '../../../utils/models/paciente.dart';
import '../../../utils/models/user_model.dart';
import '../../tabelas/tab_lista_de_equipamentos.dart';

class BotaoTipoEquipamento extends StatefulWidget {
  final String imagem;
  final TipoEquipamento titulo;
  final Paciente? pacientePreEscolhido;
  const BotaoTipoEquipamento({required this.imagem,required this.titulo,this.pacientePreEscolhido,Key? key}) : super(key: key);

  @override
  State<BotaoTipoEquipamento> createState() => _BotaoTipoEquipamentoState();
}

class _BotaoTipoEquipamentoState extends State<BotaoTipoEquipamento> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder:(context, child, model) {     
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('equipamentos')
            .where('hospital',isEqualTo: model.hospital)
            .where('status',isEqualTo: model.status.emString)
            .where('tipo',isEqualTo: widget.titulo.emStringSnakeCase)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                      child: CircularProgressIndicator(color: Constantes.corAzulEscuroPrincipal,),
                  );
                default:
          return OutlinedButton(
                  style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () async{
                    model.tipo=widget.titulo;                
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ListaDeEquipamentos(pacientePreEscolhido: widget.pacientePreEscolhido,)));
                  }, 
                  child: Column(
                    children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1,),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                widget.imagem,
                                width: MediaQuery.of(context).size.width * 0.25,
                                height: MediaQuery.of(context).size.height * 0.1,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                alignment: Alignment.center,
                                height: 20,
                                width: 20,
                                decoration: const BoxDecoration(
                                  color: Constantes
                                      .corAzulEscuroPrincipal,
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(25),
                                    color: Constantes.corAzulEscuroPrincipal,
                                  ),
                                  child:
                                    Text(snapshot.data!.docs.length.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white,fontSize: 12),)
                              )))
                            ]
                          ),
                        ),
                    const SizedBox(
                      height: 3,
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        widget.titulo.emString,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.w300,
                          color: Colors.black
                        ),
                      ),
                    )
                    ],
                  )
                  );
        }
  });});
  }
}