import 'package:flutter/material.dart';
import 'package:sono/utils/models/avaliacao.dart';
import 'package:sono/utils/models/exame.dart';

class SintomasUltimaAvaliacao extends StatelessWidget {
  final Avaliacao? ultimaAvaliacao;
  const SintomasUltimaAvaliacao({Key? key, required this.ultimaAvaliacao})
      : super(key: key);

  List<Widget> _conteudo() {
    if (ultimaAvaliacao == null) {
      return [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Text(
            "Paciente ainda não foi avaliado!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ];
    }

    return [
      TipoExame.conclusao,
      TipoExame.dadosComplementares,
      TipoExame.listagemDeSintomas,
    ]
        .map(
          (e) => _ItemExameRealizado(
            ultimaAvaliacao: ultimaAvaliacao!,
            tipoExame: e,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
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
                'Notas da Última Avaliação',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ..._conteudo(),
        ],
      ),
    );
  }
}

class _ItemExameRealizado extends StatelessWidget {
  final Avaliacao ultimaAvaliacao;
  final TipoExame tipoExame;
  const _ItemExameRealizado(
      {Key? key, required this.tipoExame, required this.ultimaAvaliacao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Exame? exame = ultimaAvaliacao.examesRealizados
            .where(
              (element) => element.tipo == tipoExame,
            )
            .isNotEmpty
        ? ultimaAvaliacao.examesRealizados.firstWhere(
            (element) => element.tipo == tipoExame,
          )
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).primaryColor),
                bottom: BorderSide(color: Theme.of(context).primaryColor),
              ),
              color: Theme.of(context).primaryColorLight,
            ),
            child: Center(
              child: Text(
                tipoExame.emStringFormatada,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(
                color: Theme.of(context).primaryColor,
              ),
            ),
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: exame == null
                  ? [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          tipoExame == TipoExame.dadosComplementares
                              ? "Nenhum dado complementar adicionado"
                              : "Não foram relatados sintomas excepcionais",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ]
                  : exame.respostas.values
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
    );
  }
}
