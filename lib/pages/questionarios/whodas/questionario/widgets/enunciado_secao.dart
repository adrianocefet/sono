import 'package:flutter/material.dart';
import 'package:simple_rich_text/simple_rich_text.dart';
import '../../../../../constants/constants.dart';
import '../../../../../utils/bases_questionarios/base_whodas.dart';

class EnunSecao extends StatelessWidget {
  final int indiceSecao;
  const EnunSecao({required this.indiceSecao, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Constantes.corAzulEscuroSecundario,
              width: 4,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: Constantes.corAzulEscuroPrincipal,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SimpleRichText(
              titulosSecoes[indiceSecao],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
        const Divider(
          color: Constantes.corAzulEscuroSecundario,
          thickness: 2.5,
          indent: 30,
          endIndent: 30,
          height: 20,
        ),
        Visibility(
          visible: indiceSecao != 3,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 5,
                ),
                child: SimpleRichText(
                  indiceSecao == 3 ? "" : enunciadosSecoes[indiceSecao],
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: Constantes.fontSizeEnunciados),
                ),
              ),
              const Divider(
                color: Constantes.corAzulEscuroSecundario,
                thickness: 2.5,
                indent: 30,
                endIndent: 30,
                height: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
