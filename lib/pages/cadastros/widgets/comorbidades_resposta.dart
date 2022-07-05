import 'package:flutter/material.dart';
import 'package:sono/utils/models/pergunta.dart';

class RespostaComorbidades extends StatefulWidget {
  final Pergunta pergunta;
  final List autoPreencher;
  const RespostaComorbidades(
      {Key? key, required this.pergunta, required this.autoPreencher})
      : super(key: key);

  @override
  State<RespostaComorbidades> createState() => _RespostaComorbidadesState();
}

class _RespostaComorbidadesState extends State<RespostaComorbidades> {
  @override
  Widget build(BuildContext context) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                widget.pergunta.enunciado,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            ...widget.pergunta.opcoes!.map(
              (e) => OpcaoComorbidade(
                pergunta: widget.pergunta,
                enunciadoOpcao: e,
              ),
            ),
            OutrasComorbidades(
              pergunta: widget.pergunta,
              autoPreencher: widget.autoPreencher,
            ),
          ],
        ),
      ),
    );
  }
}

class OpcaoComorbidade extends StatefulWidget {
  final Pergunta pergunta;
  final String enunciadoOpcao;
  const OpcaoComorbidade(
      {Key? key, required this.pergunta, required this.enunciadoOpcao})
      : super(key: key);

  @override
  State<OpcaoComorbidade> createState() => _OpcaoComorbidadeState();
}

class _OpcaoComorbidadeState extends State<OpcaoComorbidade> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (widget.pergunta.respostaLista.contains(widget.enunciadoOpcao)) {
              widget.pergunta.respostaLista.remove(widget.enunciadoOpcao);
            } else {
              widget.pergunta.respostaLista.add(widget.enunciadoOpcao);
            }
          });
        },
        child: Text(widget.enunciadoOpcao, style: const TextStyle(color: Colors.black),),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(42),
          primary: widget.pergunta.respostaLista.contains(widget.enunciadoOpcao)
              ? Theme.of(context).primaryColorLight
              : Colors.grey[400],
        ),
      ),
    );
  }
}

class OutrasComorbidades extends StatelessWidget {
  final Pergunta pergunta;
  final List autoPreencher;
  final TextEditingController _controller = TextEditingController();
  OutrasComorbidades(
      {Key? key, required this.pergunta, required this.autoPreencher})
      : super(key: key) {
    List respostaOutros = autoPreencher
        .where((element) => pergunta.opcoes!.contains(element) == false)
        .toList();
    _controller.text = respostaOutros.isNotEmpty ? respostaOutros.single : '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextField(
        controller: _controller,
        minLines: 5,
        maxLines: 5,
        decoration: InputDecoration(
          labelText: 'Outros',
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 1.2),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.2),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.2),
          ),
          labelStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
