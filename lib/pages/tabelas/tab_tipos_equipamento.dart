import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/perfis/perfil_equipamento/equipamento_controller.dart';
import 'package:sono/utils/models/equipamento.dart';
import '../../utils/models/paciente.dart';
import '../../utils/models/usuario.dart';
import '../controle_estoque/widgets/botao_tipo_equipamento.dart';

class TiposDeEquipamentos extends StatefulWidget {
  final Paciente? pacientePreEscolhido;
  final ControllerPerfilClinicoEquipamento controller;
  const TiposDeEquipamentos(
      {required this.controller, Key? key, this.pacientePreEscolhido})
      : super(key: key);

  @override
  State<TiposDeEquipamentos> createState() => _TiposDeEquipamentosState();
}

class _TiposDeEquipamentosState extends State<TiposDeEquipamentos> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Usuario>(
      builder: (context, child, model) {
        widget.pacientePreEscolhido != null
            ? widget.controller.status = StatusDoEquipamento.disponivel
            : null;
        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('equipamentos')
                .where('hospital', isEqualTo: model.instituicao.emString)
                .where('status', isEqualTo: widget.controller.status.emString)
                .snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Theme.of(context).primaryColor,
                      title: Text(widget.controller.status.emStringPlural),
                      centerTitle: true,
                    ),
                    body: const Center(
                      child: CircularProgressIndicator(
                        color: Constantes.corAzulEscuroPrincipal,
                      ),
                    ),
                  );
                default:
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(
                          '${widget.controller.status.emStringPlural} (${snapshot.data!.docs.length})'),
                      centerTitle: true,
                      backgroundColor: Constantes.corAzulEscuroPrincipal,
                    ),
                    body: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            Color.fromARGB(255, 194, 195, 255),
                            Colors.white
                          ],
                              stops: [
                            0,
                            0.4
                          ])),
                      child: GridView(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        children: [
                          for (var tipo in TipoEquipamento.values)
                            BotaoTipoEquipamento(
                                controller: widget.controller,
                                titulo: tipo,
                                imagem: tipo.imagens,
                                pacientePreEscolhido:
                                    widget.pacientePreEscolhido),
                        ],
                      ),
                    ),
                  );
              }
            });
      },
    );
  }
}
