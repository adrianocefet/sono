import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/bases_questionarios/base_whodas.dart';
import 'package:sono/utils/models/pergunta.dart';

class RepostaMarcar extends StatefulWidget {
  final Pergunta pergunta;
  final Color corTexto;
  final Color corDominio;
  final Function() refreshParent;
  const RepostaMarcar(
      {required this.pergunta,
      required this.refreshParent,
      this.corTexto = Colors.black,
      this.corDominio = Colors.blue,
      Key? key})
      : super(key: key);

  @override
  _RepostaMarcarState createState() => _RepostaMarcarState();
}

class _RepostaMarcarState extends State<RepostaMarcar> {
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

    List opcoes = [
      "Nenhuma",
      "Leve",
      "Moderada",
      "Grave",
      "Extrema ou não consegue fazer",
      "Não se aplica"
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          enunciado(
            widget.pergunta.enunciado,
          ),
          const SizedBox(
            height: 20.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ...(() {
                var list = <Widget>[];
                for (var opcao in opcoes) {
                  list.add(
                    RadioListTile(
                      title: Text(
                        opcao,
                        style: const TextStyle(
                          fontSize: 15.5,
                        ),
                      ),
                      visualDensity: VisualDensity(
                        vertical: VisualDensity.comfortable.vertical,
                      ),
                      value: opcoes.indexOf(opcao),
                      groupValue: widget.pergunta.respostaNumerica,
                      onChanged: (valor) {
                        setState(
                          () {
                            widget.pergunta.setRespostaNumerica(valor! as int);
                            widget.refreshParent();
                          },
                        );
                      },
                      activeColor: widget.corDominio,
                    ),
                  );
                }
                return list;
              }()),
            ],
          ),
        ],
      ),
    );
  }
}
