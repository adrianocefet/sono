import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/perfis/perfil_equipamento/equipamento_controller.dart';
import 'package:sono/pages/perfis/perfil_paciente/terapia_com_pap/widgets/item_equipamento.dart';
import 'package:sono/pages/tabelas/tab_tipos_equipamento.dart';
import 'package:sono/utils/dialogs/manual_ou_qrcode.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/usuario.dart';

class EquipamentosDoPaciente extends StatelessWidget {
  final Paciente paciente;
  const EquipamentosDoPaciente({Key? key, required this.paciente})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ControllerPerfilClinicoEquipamento controller =
        ControllerPerfilClinicoEquipamento();
    List<Equipamento> equipamentosEmOrdem = [
      ...paciente.equipamentos!
          .where((equip) => equip.tipo == TipoEquipamento.cpap),
      ...paciente.equipamentos!.where(
        (equip) => equip.tipo.emStringSnakeCase.contains('mascara'),
      ),
      ...paciente.equipamentos!.where(
        (equip) =>
            equip.tipo != TipoEquipamento.cpap &&
            !equip.tipo.emStringSnakeCase.contains('mascara'),
      ),
    ];

    return ScopedModelDescendant<Usuario>(
      builder: (context, _, usuario) {
        return Container(
          margin: const EdgeInsets.only(top: 30),
          width: MediaQuery.of(context).size.width * 0.92,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              width: 2,
              color: Theme.of(context).primaryColor,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
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
                    'Equipamentos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: Scrollbar(
                  child: equipamentosEmOrdem.isNotEmpty
                      ? ListView(
                          shrinkWrap: true,
                          children: equipamentosEmOrdem
                              .map((e) =>
                                  ItemEquipamentoEmprestado(equipamento: e))
                              .toList(),
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(50),
                            child: Text(
                              "Nenhum equipamento emprestado para este paciente.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              Divider(color: Theme.of(context).primaryColor, thickness: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: ElevatedButton(
                  onPressed: () {
                    manualOuQrcode(context, paciente, controller, usuario);
                  },
                  child: const Text(
                    "Emprestar novo equipamento ao paciente",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).focusColor,
                    maximumSize: const Size(300, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
