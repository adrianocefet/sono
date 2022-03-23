import 'package:flutter/material.dart';
import 'package:simple_rich_text/simple_rich_text.dart';
import 'package:sono/constants/constants.dart';

class EnunciadoRespostasDeQuestionarios extends StatelessWidget {
  final String enunciado;
  const EnunciadoRespostasDeQuestionarios({required this.enunciado, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constantes.corAzulEscuroSecundario,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.15,
        minWidth: double.infinity,
      ),
      padding: const EdgeInsets.all(8.0),
      alignment: AlignmentDirectional.center,
      child: SimpleRichText(
        enunciado,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: Constantes.fontSizeEnunciados,
        ),
      ),
    );
  }
}
