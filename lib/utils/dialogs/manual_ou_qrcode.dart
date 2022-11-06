import 'package:flutter/material.dart';
import 'package:sono/pages/perfis/perfil_equipamento/equipamento_controller.dart';
import 'package:sono/pages/perfis/perfil_equipamento/qr_code/ler_qrcode.dart';

import '../../pages/tabelas/tab_tipos_equipamento.dart';
import '../models/paciente.dart';

Future<void> manualOuQrcode(BuildContext context, Paciente paciente,
    ControllerPerfilClinicoEquipamento controller) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
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
                    'Selecione uma forma',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).focusColor,
                        minimumSize: const Size(250, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LerQrCode(
                              controller: controller,
                              pacientePreEscolhido: paciente,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Ler QrCode',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).focusColor,
                        minimumSize: const Size(250, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TiposDeEquipamentos(
                              pacientePreEscolhido: paciente,
                              controller: controller,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Procurar equipamento',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
