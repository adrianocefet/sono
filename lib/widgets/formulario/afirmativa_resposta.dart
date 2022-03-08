import 'package:flutter/material.dart';
import 'package:simple_rich_text/simple_rich_text.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/base_perguntas/base_whodas.dart';
import 'package:sono/utils/models/pergunta.dart';

class RepostaAfirmativa extends StatefulWidget {
  final Pergunta pergunta;
  final Color? corTexto;
  final Color? corDominio;
  final oFormularioEWHODAS;

  const RepostaAfirmativa(
      {required this.pergunta,
      this.corDominio,
      this.corTexto,
      this.oFormularioEWHODAS,
      Key? key})
      : super(key: key);

  @override
  _RepostaAfirmativaState createState() => _RepostaAfirmativaState();
}

class _RepostaAfirmativaState extends State<RepostaAfirmativa> {
  Widget enunciado(String enun) {
    String enunSemCodigo = enun.replaceAll('${widget.pergunta.codigo} - ', '');
    List<InlineSpan> novoEnun = [
      TextSpan(
        text: enunSemCodigo,
        style: TextStyle(
          color: widget.corTexto,
          fontSize: Constantes.fontSizeEnunciados,
        ),
      ),
    ];

    for (Map p in baseWHODAS) {
      if (p['codigo'] == widget.pergunta.codigo) {
        novoEnun.insert(
          0,
          TextSpan(
            text: '${widget.pergunta.codigo} - ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: widget.corDominio,
              fontSize: Constantes.fontSizeEnunciados,
            ),
          ),
        );
      }
    }
    RichText enunFormat = RichText(
      text: TextSpan(
        children: novoEnun,
      ),
    );

    return enunFormat;
  }

  int? escolha;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: false,
            child: TextFormField(
              onSaved: (valor) {
                //if (escolha == null) widget.pergunta.setResposta(0);
              },
            ),
            maintainState: true,
          ),
          widget.oFormularioEWHODAS
              ? enunciado(widget.pergunta.enunciado)
              : SimpleRichText(
                  widget.pergunta.enunciado,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: widget.corTexto,
                    fontSize: Constantes.fontSizeEnunciados,
                  ),
                ),
          const SizedBox(
            height: 20.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTile(
                title: const Text("Não"),
                value: 0,
                activeColor: widget.oFormularioEWHODAS ? widget.corDominio : Colors.green,
                groupValue: widget.pergunta.resposta,
                onChanged: (int? valor) {
                  escolha = valor;
                  print("${widget.pergunta.codigo} : ${valor}");
                  setState(
                    () {
                      widget.pergunta.setResposta(valor!);
                    },
                  );
                },
              ),
              RadioListTile(
                title: const Text("Sim"),
                value: 1,
                groupValue: widget.pergunta.resposta,
                activeColor: widget.oFormularioEWHODAS ? widget.corDominio : Colors.red,
                onChanged: (int? valor) {
                  escolha = valor;
                  setState(
                    () {
                      widget.pergunta.setResposta(valor!);
                    },
                  );
                  print(
                      "${widget.pergunta.codigo} : ${widget.pergunta.resposta}");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
