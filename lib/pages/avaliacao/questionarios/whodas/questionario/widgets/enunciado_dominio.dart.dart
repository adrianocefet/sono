import 'package:flutter/material.dart';
import 'package:simple_rich_text/simple_rich_text.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/bases_questionarios/base_whodas.dart';
import '../whodas_controller.dart';

class EnunDominio extends StatefulWidget {
  final String dominio;
  final WHODASController controller;
  final void Function() questionarioSetState;
  const EnunDominio(
      {required this.dominio,
      required this.controller,
      Key? key,
      required this.questionarioSetState})
      : super(key: key);

  @override
  State<EnunDominio> createState() => _EnunDominioState();
}

class _EnunDominioState extends State<EnunDominio> {
  @override
  Widget build(BuildContext context) {
    String? tituloDominio = Constantes.titulosDominiosWHODASMap[widget.dominio];
    String nomeDominio =
        Constantes.nomesDominiosWHODASMap[widget.dominio] ?? '';
    Color cor =
        Constantes.coresDominiosWHODASMap[widget.dominio] ?? Colors.blue;
    int i = ['dom_51', 'dom_52', 'dom_6'].contains(widget.dominio) ? 1 : 0;
    bool _dominioAplicavel =
        widget.controller.estadosDosDominios[widget.dominio]!;

    return Column(
      children: [
        ListTile(
          title: Column(
            children: [
              const Divider(
                color: Colors.white,
                thickness: 2.5,
                indent: 30,
                endIndent: 30,
                height: 20,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$tituloDominio:\n$nomeDominio\n\n',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    TextSpan(
                      text: enunciadosDominios[i],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.white,
                thickness: 2.5,
                indent: 30,
                endIndent: 30,
                height: 20,
              ),
            ],
          ),
          contentPadding: const EdgeInsets.all(5),
          tileColor: cor,
        ),
        ListTile(
          leading: Switch(
            activeColor: Constantes.coresDominiosWHODASMap[widget.dominio],
            value: _dominioAplicavel,
            onChanged: (value) {
              setState(() {
                widget.controller.desabilitarDominio(!value, widget.dominio);
                _dominioAplicavel = value;
              });
              widget.questionarioSetState();
            },
          ),
          title: Text(
            _dominioAplicavel ? "Domínio aplicável" : "Domínio não aplicável",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Divider(
          color: Constantes.coresDominiosWHODASMap[widget.dominio],
          endIndent: 30,
          indent: 30,
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
          child: SimpleRichText(
            enunciadosDominiosParte2[widget.dominio]!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: Constantes.fontSizeEnunciados,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
