import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/atributo_equip.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/detalhe_do_status.dart';
import 'package:sono/pages/perfis/perfil_equipamento/widgets/editar_atributo_equip.dart';
import 'package:sono/utils/dialogs/selecionar_origem_foto.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/services/firebase.dart';

import '../../../constants/constants.dart';
import '../../../utils/dialogs/devolver_equipamento_dialog.dart';
import '../../../utils/dialogs/editar_foto.dart';
import '../../../utils/dialogs/escolher_paciente_dialog.dart';
import '../../../utils/models/equipamento.dart';
import '../../../utils/models/user_model.dart';
import 'widgets/editar_status.dart';

class ScreenEquipamento extends StatefulWidget {
  final String idEquipamento;
  const ScreenEquipamento(
    this.idEquipamento, {
    Key? key,
  }) : super(key: key);

  @override
  _ScreenEquipamentosState createState() => _ScreenEquipamentosState();
}

class _ScreenEquipamentosState extends State<ScreenEquipamento> {
  Paciente? _pacienteResponsavel;

  void _definirPacienteResponsavel(Paciente? novoPacienteResponsavel) =>
      setState(
        () {
          _pacienteResponsavel =
              novoPacienteResponsavel ?? _pacienteResponsavel;
        },
      );

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return StreamBuilder(
          stream: FirebaseService.streamEquipamento(
            widget.idEquipamento,
          ),
          builder: (
            context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
          ) {
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

                return Scaffold(
                  appBar: AppBar(
                    title: Text(equipamento.nome),
                    actions: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            model.editar
                                ? model.editar = false
                                : model.editar = true;
                          });
                          if (!model.editar) {
                            FirebaseService.atualizarEquipamento(equipamento);
                          }
                        },
                        icon: model.editar
                            ? const Icon(Icons.save)
                            : const Icon(Icons.edit),
                      )
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 20.0,
                              ),
                              child: Column(
                                children: [
                                  Image.network(
                                  equipamento.urlFotoDePerfil ?? model.semimagem,
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  height: MediaQuery.of(context).size.width * 0.5,
                                  fit: BoxFit.cover,
                                  frameBuilder: (context,child,frame,wasSynchronouslyLoaded){
                                    return child;
                                  },
                                  loadingBuilder: (context,child,loadingProgress){
                                    if(loadingProgress==null){
                                      return child;
                                    }else{
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                                model.editar?   
                              EditarFoto(widget.idEquipamento,"Equipamento") : SizedBox()
                                    
                                  
                                ]
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        equipamento.nome,
                                        style: const TextStyle(
                                          fontSize: 40,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                for (String atrib
                                    in Constantes.titulosAtributosEquipamentos)
                                  model.editar
                                      ? EditarAtributoEquipamento(
                                          equipamento,
                                          atrib,
                                        )
                                      : atrib == "Nome"
                                          ? Container()
                                          : atrib == "Status"
                                              ? EditarStatus(
                                                  equipamento,
                                                  "Status",
                                                  _definirPacienteResponsavel,
                                                )
                                              : AtributoEquipamento(
                                                  equipamento,
                                                  atrib,
                                                ),
                                Visibility(
                                  visible: equipamento.idPacienteResponsavel != null,
                                  child: DisplayDetalheDoStatus(
                                    equipamento: equipamento,
                                  ),
                                ),
                                Visibility(
                                  visible: equipamento.status.emString=="Disponível" && model.editar==false,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[
                                       SizedBox(height: 20,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        child: ElevatedButton(
                                    onPressed: () async{
                                      Paciente? pacienteEscolhido =
                                      await mostrarDialogEscolherPaciente(context);
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Text(
                                          "Emprestar",
                                          style: TextStyle(
                                            fontSize: 40,
                                          ),
                                        ),
                                    ),
                                   ),
                                      ),
                                      SizedBox(height: 20,),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        child: ElevatedButton(
                                    onPressed: () async{
                                      Paciente? pacienteEscolhido =
                                      await mostrarDialogEscolherPaciente(context);
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Text(
                                          "Desinfectar",
                                          style: TextStyle(
                                            fontSize: 40,
                                          ),
                                        ),
                                    ),
                                   ),
                                      ),
                                   SizedBox(height: 20,),
                                   SizedBox(
                                     width:MediaQuery.of(context).size.width,
                                     child: ElevatedButton(
                                      onPressed: () async{
                                      Paciente? pacienteEscolhido =
                                      await mostrarDialogEscolherPaciente(context);
                                    },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Text(
                                          "Manutenção",
                                          style: TextStyle(
                                            fontSize: 40,
                                          ),
                                        ),
                                      ),
                                     ),
                                   ),

                                   ] 
                                  ),
                                ),
                                
                                
                                const Divider(
                                  thickness: 5,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
            }
          },
        );
      },
    );
  }
}