import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/base_perguntas/base_whodas.dart';

class EnunDominio extends StatelessWidget {
  final String dominio;
  const EnunDominio({required this.dominio, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? tituloDominio = Constantes.titulosDominiosWHODASMap[dominio];

    String nomeDominio = Constantes.nomesDominiosWHODASMap[dominio] ?? '';
    Color cor = Constantes.coresDominiosWHODASMap[dominio] ?? Colors.blue;
    int i = ['dom_51', 'dom_52', 'dom_6'].contains(dominio) ? 1 : 0;

    return ListTile(
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
            text: TextSpan(children: [
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
            ]),
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
    );
  }
}
