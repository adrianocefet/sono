import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/base_perguntas/base_whodas.dart';
import 'package:sono/utils/models/pergunta.dart';

class RepostaMultipla extends StatefulWidget {
  final Pergunta pergunta;
  final Color corTexto;
  final Color corDominio;
  const RepostaMultipla(
      {required this.pergunta,
      this.corTexto = Colors.black,
      this.corDominio = Colors.blue,
      Key? key})
      : super(key: key);

  @override
  _RepostaMultiplaState createState() => _RepostaMultiplaState();
}

class _RepostaMultiplaState extends State<RepostaMultipla> {
  int _groupValue = 0;

  @override
  Widget build(BuildContext context) {
    Widget enunciado(String enun) {
      String enunSemCodigo =
          enun.replaceAll('${widget.pergunta.codigo} - ', '');
      List<InlineSpan> novoEnun = [
        TextSpan(
          text: enunSemCodigo,
          style: TextStyle(
            color: widget.corTexto,
            fontSize: Constants.fontSizeEnunciados,
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
                fontSize: Constants.fontSizeEnunciados,
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              enunciado(widget.pergunta.enunciado),
              const SizedBox(
                height: 20.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.pergunta.opcoes!
                    .map(
                      (opcao) => RadioListTile(
                        title: Text(
                          opcao,
                          style: const TextStyle(
                            fontSize: 15.5,
                          ),
                        ),
                        value: widget.pergunta.opcoes!.indexOf(opcao),
                        groupValue: _groupValue,
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            _groupValue = value as int;
                            widget.pergunta.setResposta(value);
                          });
                        },
                        activeColor: widget.corDominio,
                      ),
                    )
                    .toList(),
              ),
              (() {
                {
                  return widget.pergunta.codigo.contains('A5') &&
                          _groupValue == 8
                      ? TextFormField(
                          validator: (value) =>
                              value != '' ? null : 'Dado obrigatório.',
                          minLines: 1,
                          maxLines: 4,
                          // expands: true,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: const OutlineInputBorder(),
                            labelStyle: TextStyle(
                                color: const Color.fromRGBO(88, 98, 143, 1),
                                fontSize: 14),
                          ),
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                          onSaved: (value) => value != null
                              ? widget.pergunta.setRespostaExtenso(value)
                              : widget.pergunta.setRespostaExtenso(
                                  'Outros (não especificado)'),
                        )
                      : Container();
                }
              }())
            ],
          ),
        ),
      ],
    );
  }
}
