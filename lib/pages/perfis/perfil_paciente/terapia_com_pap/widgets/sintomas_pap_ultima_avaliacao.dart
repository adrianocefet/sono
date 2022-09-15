import 'package:flutter/material.dart';
import 'package:sono/utils/models/avaliacao.dart';
import 'package:sono/utils/models/exame.dart';

class SintomasPAPUltimaAvaliacao extends StatelessWidget {
  final Avaliacao? ultimaAvaliacao;
  const SintomasPAPUltimaAvaliacao({Key? key, required this.ultimaAvaliacao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ultimaAvaliacao == null) return const SizedBox.shrink();

    Exame? sintomas = ultimaAvaliacao!.examesRealizados
            .where((element) =>
                element.tipo == TipoExame.listagemDeSintomasDoUsoDoCPAP)
            .isNotEmpty
        ? ultimaAvaliacao!.examesRealizados
            .where((element) =>
                element.tipo == TipoExame.listagemDeSintomasDoUsoDoCPAP)
            .single
        : null;

    if (sintomas == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 30),
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
                'Sintomas relacionados ao PAP relatados na última avaliação',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: sintomas.respostas.values
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                e,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
