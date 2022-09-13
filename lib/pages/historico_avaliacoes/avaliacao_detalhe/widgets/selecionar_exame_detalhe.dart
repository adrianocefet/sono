import 'package:flutter/material.dart';
import 'package:sono/pages/historico_avaliacoes/exame_detalhe/exame_detalhe.dart';
import 'package:sono/utils/models/exame.dart';

class SelecionarExameEmDetalhe extends StatelessWidget {
  final Exame exame;
  const SelecionarExameEmDetalhe({Key? key, required this.exame})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width * 0.92,
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
              child: Center(
                child: Text(
                  exame.nome,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Ver exame'),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExameEmDetalhe(
                            exame: exame,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      child: const Icon(
                        Icons.menu,
                        size: 36,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
