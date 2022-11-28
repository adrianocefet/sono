import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/perfis/perfil_equipamento/equipamento_controller.dart';
import 'package:sono/pages/tabelas/tab_lista_de_equipamentos.dart';
import 'package:sono/utils/models/equipamento.dart';
import '../../../constants/constants.dart';
import '../../../utils/models/paciente.dart';
import '../../../utils/models/usuario.dart';

class BotaoTipoEquipamento extends StatefulWidget {
  final String imagem;
  final TipoEquipamento titulo;
  final Paciente? pacientePreEscolhido;
  final ControllerPerfilClinicoEquipamento controller;
  const BotaoTipoEquipamento(
      {required this.imagem,
      required this.titulo,
      required this.controller,
      this.pacientePreEscolhido,
      Key? key})
      : super(key: key);

  @override
  State<BotaoTipoEquipamento> createState() => _BotaoTipoEquipamentoState();
}

class _BotaoTipoEquipamentoState extends State<BotaoTipoEquipamento> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Usuario>(builder: (context, child, model) {
      print(model.infoMap);
      MediaQueryData mediaQuery = MediaQuery.of(context);
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('equipamentos')
              .where('hospital', isEqualTo: model.instituicao.emString)
              .where('status', isEqualTo: widget.controller.status.emString)
              .where('tipo', isEqualTo: widget.titulo.emStringSnakeCase)
              .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(
                    color: Constantes.corAzulEscuroPrincipal,
                  ),
                );
              default:
                return OutlinedButton(
                    style:
                        OutlinedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () async {
                      widget.controller.tipo = widget.titulo;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListaDeEquipamentos(
                                    pacientePreEscolhido:
                                        widget.pacientePreEscolhido,
                                    controller: widget.controller,
                                  )));
                    },
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: SizedBox(
                                height: mediaQuery.size.height * 0.1,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.asset(
                                    widget.imagem,
                                    fit: BoxFit.fill,
                                  ),
                                ),
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
                                      color: Constantes.corAzulEscuroPrincipal,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color:
                                              Constantes.corAzulEscuroPrincipal,
                                        ),
                                        child: Text(
                                          snapshot.data!.docs.length.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ))))
                          ]),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            widget.titulo.emString,
                            style: TextStyle(
                                fontSize: mediaQuery.size.width * 0.03,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                        )
                      ],
                    ));
            }
          });
    });
  }
}