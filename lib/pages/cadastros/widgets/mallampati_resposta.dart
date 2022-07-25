import 'package:flutter/material.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';

class RespostaMallampati extends StatefulWidget {
  final Pergunta pergunta;
  final Paciente? paciente;
  final int? autoPreencher;

  const RespostaMallampati({
    required this.pergunta,
    this.paciente,
    this.autoPreencher,
    Key? key,
  }) : super(key: key);

  @override
  _RespostaExtensoState createState() => _RespostaExtensoState();
}

class _RespostaExtensoState extends State<RespostaMallampati> {
  Paciente? paciente;
  bool valido = true;
  @override
  Widget build(BuildContext context) {
    if (widget.paciente != null || widget.autoPreencher != null) {
      paciente = widget.paciente;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: valido ? Theme.of(context).primaryColor : Colors.red,
                width: 1.2,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: false,
                  maintainState: true,
                  child: TextFormField(
                    onSaved: (value) {
                      setState(
                        () {
                          valido =
                              widget.pergunta.resposta != null ? true : false;
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Text(
                    widget.pergunta.enunciado,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      for (int indice = 1; indice <= 4; indice++)
                        _SelecionarMallampati(
                          pergunta: widget.pergunta,
                          indice: indice,
                          atualizarWidget: () => setState(() {}),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !valido,
            child: const Padding(
              padding: EdgeInsets.only(left: 10, top: 5),
              child: Text(
                'Dado obrigatório.',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelecionarMallampati extends StatefulWidget {
  final Pergunta pergunta;
  final int indice;
  final void Function() atualizarWidget;
  const _SelecionarMallampati({
    Key? key,
    required this.pergunta,
    required this.indice,
    required this.atualizarWidget,
  }) : super(key: key);

  @override
  State<_SelecionarMallampati> createState() => _SelecionarMallampatiState();
}

class _SelecionarMallampatiState extends State<_SelecionarMallampati> {
  String get obterImagem {
    switch (widget.indice) {
      case 1:
        return 'assets/imagens/Mallampati-mod-I.png';
      case 2:
        return 'assets/imagens/Mallampati-mod-II.png';
      case 3:
        return 'assets/imagens/Mallampati-mod-III.png';
      default:
        return 'assets/imagens/Mallampati-mod-IV.png';
    }
  }

  bool get estaSelecionado => widget.pergunta.resposta == widget.indice;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            width: 2,
            color: estaSelecionado
                ? Theme.of(context).focusColor
                : Theme.of(context).primaryColorLight,
          ),
        ),
        child: Image.asset(
          obterImagem,
          width: 400,
          height: 500,
        ),
      ),
      onTap: () {
        widget.pergunta.setResposta(widget.indice);
        widget.atualizarWidget();
      },
    );
  }
}
