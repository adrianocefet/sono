import 'package:flutter/material.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';

class RespostaAfirmativaCadastro extends StatefulWidget {
  final Pergunta pergunta;
  final Paciente? paciente;
  final bool? numerico;
  final Color? corTexto;
  final Color? corDominio;
  final String? autoPreencher;
  final TextEditingController _extensoController = TextEditingController();
  late final bool _enabled;

  RespostaAfirmativaCadastro({
    required this.pergunta,
    this.paciente,
    this.numerico,
    this.corTexto = Colors.black,
    this.corDominio = Colors.blue,
    this.autoPreencher,
    Key? key,
  }) : super(key: key) {
    _extensoController.text = autoPreencher ?? "";
    _enabled = true;
  }

  @override
  _RespostaExtensoState createState() => _RespostaExtensoState();
}

class _RespostaExtensoState extends State<RespostaAfirmativaCadastro> {
  Paciente? paciente;

  @override
  Widget build(BuildContext context) {
    if (widget.paciente != null || widget.autoPreencher != null) {
      paciente = widget.paciente;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Theme.of(context).primaryColor, width: 1.2),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        padding: const EdgeInsets.all(5),
        child: Row(
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
                    atualizarMarcacao: () => setState(() {}),
                  ),
                  _BotaoBinario(
                    'Não',
                    pergunta: widget.pergunta,
                    atualizarMarcacao: () => setState(() {}),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BotaoBinario extends StatefulWidget {
  final Pergunta pergunta;
  final String estado;
  final void Function() atualizarMarcacao;
  const _BotaoBinario(this.estado,
      {Key? key, required this.pergunta, required this.atualizarMarcacao})
      : super(key: key);

  @override
  State<_BotaoBinario> createState() => __BotaoBinarioState();
}

class __BotaoBinarioState extends State<_BotaoBinario> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: widget.pergunta.respostaExtenso == widget.estado
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
        } else {
          widget.pergunta.setRespostaExtenso(null);
        }
        widget.atualizarMarcacao();
      },
    );
  }
}
