import 'package:flutter/material.dart';
import 'package:sono/utils/models/pergunta.dart';

class RespostaAfirmativaCadastro extends StatefulWidget {
  final Pergunta pergunta;
  final bool? numerico;
  final Color? corTexto;
  final Color? corDominio;
  final bool? autoPreencher;
  final TextEditingController _extensoController = TextEditingController();
  final void Function()? notificarParent;

  RespostaAfirmativaCadastro({
    required this.pergunta,
    this.numerico,
    this.corTexto = Colors.black,
    this.corDominio = Colors.blue,
    this.autoPreencher,
    Key? key,
    this.notificarParent,
  }) : super(key: key) {
    _extensoController.text = autoPreencher != null
        ? autoPreencher!
            ? "Sim"
            : "Não"
        : "";
  }

  @override
  _RespostaExtensoState createState() => _RespostaExtensoState();
}

class _RespostaExtensoState extends State<RespostaAfirmativaCadastro> {
  bool valido = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: false,
            maintainState: true,
            maintainSize: false,
            child: TextFormField(
              onSaved: (value) {
                setState(
                  () {
                    valido = (widget.pergunta.respostaExtenso ??
                                widget.autoPreencher) !=
                            null
                        ? true
                        : false;

                    widget.pergunta.setRespostaBooleana(
                        widget.pergunta.respostaBooleana ??
                            widget.autoPreencher);
                  },
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: valido ? Theme.of(context).primaryColor : Colors.red,
                  width: 1.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    widget.pergunta.enunciado,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _BotaoBinario(
                        'Sim',
                        pergunta: widget.pergunta,
                        autoPreencher: widget.autoPreencher != null
                            ? widget.autoPreencher!
                                ? "Sim"
                                : "Não"
                            : null,
                        atualizarMarcacao: () {
                          setState(() {});
                          if (widget.notificarParent != null) {
                            widget.notificarParent!();
                          }
                        },
                      ),
                      _BotaoBinario(
                        'Não',
                        pergunta: widget.pergunta,
                        autoPreencher: widget.autoPreencher != null
                            ? widget.autoPreencher!
                                ? "Sim"
                                : "Não"
                            : null,
                        atualizarMarcacao: () {
                          setState(() {});
                          if (widget.notificarParent != null) {
                            widget.notificarParent!();
                          }
                        },
                      )
                    ],
                  ),
                )
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

class _BotaoBinario extends StatefulWidget {
  final Pergunta pergunta;
  final String estado;
  final String? autoPreencher;
  final void Function() atualizarMarcacao;
  const _BotaoBinario(this.estado,
      {Key? key,
      required this.pergunta,
      required this.atualizarMarcacao,
      required this.autoPreencher})
      : super(key: key);

  @override
  State<_BotaoBinario> createState() => __BotaoBinarioState();
}

class __BotaoBinarioState extends State<_BotaoBinario> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: (widget.pergunta.respostaExtenso ?? widget.autoPreencher) ==
                  widget.estado
              ? widget.estado == 'Sim'
                  ? Theme.of(context).focusColor
                  : Colors.redAccent
              : Colors.grey,
        ),
        child: widget.estado == 'Sim'
            ? const Icon(Icons.check)
            : const Icon(Icons.close),
      ),
      onTap: () {
        if (widget.pergunta.respostaExtenso != widget.estado) {
          widget.pergunta
              .setRespostaExtenso(widget.estado == 'Sim' ? 'Sim' : 'Não');
          widget.pergunta
              .setRespostaBooleana(widget.estado == 'Sim' ? true : false);
        } else {
          widget.pergunta.setRespostaExtenso(null);
          widget.pergunta.setRespostaBooleana(null);
        }
        widget.atualizarMarcacao();
      },
    );
  }
}
