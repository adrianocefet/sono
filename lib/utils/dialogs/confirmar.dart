import 'package:flutter/material.dart';
import 'package:sono/utils/dialogs/carregando.dart';
import 'package:sono/utils/services/firebase.dart';

Future<bool?> mostrarDialogConfirmacao(
    BuildContext context, String mensagem, String submensagem) async {
  return await showDialog(
      context: context,
      builder: (context) => Center(
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
              child: Material(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
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
                      child: Center(
                        child: Text(
                          mensagem,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      submensagem,
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text(
                              'Não',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(97, 253, 125, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text(
                              'Sim',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(97, 253, 125, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
}
