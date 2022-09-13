import 'package:flutter/material.dart';
import 'package:sono/utils/models/avaliacao.dart';
import 'package:sono/utils/models/exame.dart';
import '../../exame_detalhe/exame_detalhe.dart';

class SelecionarQuestionarioEmDetalhe extends StatefulWidget {
  final Avaliacao avaliacao;
  const SelecionarQuestionarioEmDetalhe({Key? key, required this.avaliacao})
      : super(key: key);

  @override
  State<SelecionarQuestionarioEmDetalhe> createState() =>
      _SelecionarQuestionarioEmDetalheState();
}

class _SelecionarQuestionarioEmDetalheState
    extends State<SelecionarQuestionarioEmDetalhe> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.avaliacao.examesRealizados
          .where((element) => element.tipoQuestionario != null)
          .isNotEmpty,
      child: Padding(
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
            mainAxisAlignment: MainAxisAlignment.start,
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
                    "Questionários",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...widget.avaliacao.examesRealizados
                      .where(
                          (element) => element.tipo == TipoExame.questionario)
                      .map(
                        (e) => _QuestionarioRealizado(
                          avaliacao: widget.avaliacao,
                          exame: e,
                        ),
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuestionarioRealizado extends StatefulWidget {
  final Avaliacao avaliacao;
  final Exame exame;
  const _QuestionarioRealizado(
      {Key? key, required this.avaliacao, required this.exame})
      : super(key: key);

  @override
  State<_QuestionarioRealizado> createState() => _QuestionarioRealizadoState();
}

class _QuestionarioRealizadoState extends State<_QuestionarioRealizado> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Theme.of(context).primaryColor),
            ),
            color: Theme.of(context).primaryColorLight,
          ),
          child: Center(
            child: Text(
              widget.exame.nomeDoQuestionario!,
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
              const Text('Ver teste'),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExameEmDetalhe(
                        exame: widget.exame,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  child: const Icon(
                    Icons.menu,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        )
      ],
    );
  }
}
