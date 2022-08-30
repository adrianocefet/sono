import 'package:flutter/material.dart';

class AcaoExame extends StatelessWidget {
  final String tipo;
  final Function modificarEstadoExame;
  const AcaoExame(
      {Key? key, required this.tipo, required this.modificarEstadoExame})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Icon icone;
    late String nome;
    late Color cor;

    switch (tipo) {
      case 'ver':
        icone = const Icon(Icons.menu, size: 36);
        nome = 'Ver exame';
        cor = Theme.of(context).primaryColorLight;
        break;
      case 'adicionar':
        icone = const Icon(Icons.add, size: 36);
        nome = '';
        cor = Theme.of(context).focusColor;
        break;
      case 'refazer':
        icone = const Icon(Icons.redo, size: 36);
        nome = 'Refazer exame';
        cor = Colors.yellow;
        break;
      case 'excluir':
        icone = const Icon(Icons.close, size: 36);
        nome = 'Excluir exame';
        cor = Colors.red;
        break;

      default:
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(nome),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () => modificarEstadoExame(),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              shape: BoxShape.circle,
              color: cor,
            ),
            child: icone,
          ),
        )
      ],
    );
  }
}
