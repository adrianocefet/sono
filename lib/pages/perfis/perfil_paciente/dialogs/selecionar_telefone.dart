import 'package:flutter/material.dart';
import 'package:sono/utils/models/paciente.dart';

class DialogSelecionarTelefone extends StatelessWidget {
  final Paciente paciente;
  const DialogSelecionarTelefone({Key? key, required this.paciente})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            width: 2,
            color: Theme.of(context).primaryColor,
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
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
                  "Selecione o número a ser contactado",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).focusColor,
                minimumSize: const Size(120, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context, paciente.telefonePrincipal!);
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "Telefone principal:\n\n${paciente.telefonePrincipal!}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).focusColor,
                minimumSize: const Size(120, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context, paciente.telefoneSecundario!);
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "Telefone secundário:\n\n${paciente.telefoneSecundario!}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
