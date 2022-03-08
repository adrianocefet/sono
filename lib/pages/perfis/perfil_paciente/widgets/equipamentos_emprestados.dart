import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/perfis/perfil_paciente/dialogs/devolver_equipamento_dialog.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/services/firebase.dart';

class EquipamentosEmprestados extends StatefulWidget {
  final List<String> listaDeEquipamentos;
  const EquipamentosEmprestados({required this.listaDeEquipamentos, Key? key})
      : super(key: key);

  @override
  _EquipamentosEmprestadosState createState() =>
      _EquipamentosEmprestadosState();
}

class _EquipamentosEmprestadosState extends State<EquipamentosEmprestados> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.listaDeEquipamentos.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Equipamentos emprestados",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (String idEquipamento in widget.listaDeEquipamentos)
                FutureBuilder(
                  future:
                      FirebaseService().obterEquipamentoPorID(idEquipamento),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Equipamento equipamento = snapshot.data as Equipamento;
                      return Column(
                        children: [
                          Wrap(
                            children: [
                              Text(
                                equipamento.nome,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 4,
                                  color: Constantes.corAzulEscuroSecundario,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              child: InkWell(
                                onTap: (() async =>
                                    await mostrarDialogDevolverEquipamento(
                                      context,
                                      equipamento,
                                    )),
                                child: Image.network(
                                  equipamento.urlFotoDePerfil != null
                                      ? equipamento.urlFotoDePerfil!
                                      : 'https://toppng.com/uploads/preview/app-icon-set-login-icon-comments-avatar-icon-11553436380yill0nchdm.png',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "Data de Devolução: ${equipamento.dataDeDevolucaoEmStringFormatada}",
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
