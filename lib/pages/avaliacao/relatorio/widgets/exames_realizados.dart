import 'package:flutter/material.dart';
import 'package:sono/pages/avaliacao/exame.dart';

class ExamesRealizados extends StatelessWidget {
  final List<Exame> listaDeExamesRealizados;
  const ExamesRealizados({Key? key, required this.listaDeExamesRealizados})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Exame> listaDeQuestionariosRealizados = listaDeExamesRealizados
        .where((exame) => exame.tipo == TipoExame.questionario)
        .toList();

    List<Exame> listaDeExamesASeremListados = listaDeExamesRealizados
        .where((element) => ![
              TipoExame.conclusao,
              TipoExame.dadosComplementares,
              TipoExame.questionario
            ].contains(element.tipo))
        .toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 275, horizontal: 25),
      padding: const EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width * 0.92,
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          width: 2,
          color: Theme.of(context).primaryColor,
        ),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.fromRGBO(165, 166, 246, 1.0), Colors.white],
          stops: [0, 0.2],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
                'Exames realizados',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),

            ),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              for (Exame exame in listaDeExamesASeremListados)
                ListTile(
                  leading: Icon(
                    Icons.radio_button_checked,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    exame.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Visibility(
                visible: listaDeQuestionariosRealizados.isNotEmpty,
                child: ListTile(
                  leading: Icon(
                    Icons.radio_button_checked,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text(
                    'Questionários',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (Exame questionario in listaDeQuestionariosRealizados)
                        Text(
                          questionario.nomeDoQuestionario!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: listaDeExamesRealizados
                    .where((element) =>
                        element.tipo == TipoExame.dadosComplementares)
                    .isNotEmpty,
                child: ListTile(
                  leading: Icon(
                    Icons.radio_button_checked,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text(
                    'Dados complementares',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listaDeExamesRealizados
                                .where((element) =>
                                    element.tipo ==
                                    TipoExame.dadosComplementares)
                                .isNotEmpty
                            ? listaDeExamesRealizados
                                .firstWhere(
                                  (element) =>
                                      element.tipo ==
                                      TipoExame.dadosComplementares,
                                )
                                .respostas
                                .values
                                .first
                            : '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.radio_button_checked,
                  color: Theme.of(context).primaryColor,
                ),
                title: const Text(
                  'Conclusão',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listaDeExamesRealizados
                          .firstWhere(
                              (element) => element.tipo == TipoExame.conclusao)
                          .respostas
                          .values
                          .first,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
