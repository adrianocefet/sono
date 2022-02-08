import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/base_perguntas/base_whodas.dart';
import 'package:sono/utils/models/paciente/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';

class RespostaExtenso extends StatefulWidget {
  final Pergunta pergunta;
  final Paciente? paciente;
  final bool? numerico;
  final Color? corTexto;
  final Color? corDominio;
  final String? autoPreencher;
  final TextEditingController _extensoController = TextEditingController();
  late final bool _enabled;

  RespostaExtenso({
    required this.pergunta,
    this.paciente,
    this.numerico,
    this.corTexto = Colors.black,
    this.corDominio = Colors.blue,
    this.autoPreencher,
    Key? key,
  }) : super(key: key) {
    _enabled = ["", 'F4'].contains(pergunta.codigo) ? false : true;

    _extensoController.text = autoPreencher!;
  }

  @override
  _RespostaExtensoState createState() => _RespostaExtensoState();
}

class _RespostaExtensoState extends State<RespostaExtenso> {
  Paciente? paciente;

  Widget enunciado(String enun) {
    String enunSemCodigo = enun.replaceAll('${widget.pergunta.codigo} - ', '');
    List<InlineSpan> novoEnun = [
      TextSpan(
        text: enunSemCodigo,
        style: TextStyle(
          color: widget.corTexto,
          fontSize: Constants.fontSizeEnunciados,
        ),
      ),
    ];

    for (Map pergunta in baseWHODAS) {
      if (pergunta['codigo'] == widget.pergunta.codigo) {
        novoEnun.insert(
          0,
          TextSpan(
            text: widget.pergunta.codigo != " "
                ? '${widget.pergunta.codigo} - '
                : "",
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

  @override
  Widget build(BuildContext context) {
    if (widget.paciente != null || widget.autoPreencher != null) {
      paciente = widget.paciente;
    }

    MaskTextInputFormatter _formatadorMascara = MaskTextInputFormatter(
      mask: '+## (##) #####-####',
      filter: {
        "#": RegExp(r'[0-9]'),
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          enunciado(widget.pergunta.enunciado),
          const SizedBox(
            height: 5.0,
          ),
          TextFormField(
            enabled: widget._enabled,
            controller: widget._extensoController,
            minLines: 1,
            maxLines: 4,
            inputFormatters:
                ['telefone', 'cid'].contains(widget.pergunta.codigo)
                    ? [_formatadorMascara]
                    : [],
            textCapitalization:
                ['F1', 'F2', 'cid'].contains(widget.pergunta.codigo)
                    ? TextCapitalization.characters
                    : ['nome_completo'].contains(widget.pergunta.codigo)
                        ? TextCapitalization.words
                        : TextCapitalization.none,
            keyboardType:
                ['A3', 'H1', 'H2', 'H3'].contains(widget.pergunta.codigo) ||
                        (widget.numerico ?? false)
                    ? TextInputType.number
                    : TextInputType.text,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              counterText: '',
              labelStyle: const TextStyle(
                color: Constants.corAzulEscuroSecundario,
                fontSize: 14,
              ),
              suffixIcon:
                  widget._enabled && widget._extensoController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              widget._extensoController.clear();
                            });
                          },
                        )
                      : null,
            ),
            onChanged: (value) {
              if (value.length <= 1 &&
                  ['cid', 'telefone'].contains(widget.pergunta.codigo) ==
                      false) {
                setState(() {});
              }
            },
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            onSaved: (String? value) {
              setState(
                () {
                  widget.pergunta.setRespostaExtenso(
                    (value!.trim()).replaceAll(
                      RegExp(' +'),
                      ' ',
                    ),
                  );
                },
              );
            },
            validator: widget.pergunta.validador,
          )
        ],
      ),
    );
  }
}
