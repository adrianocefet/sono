import 'package:flutter/material.dart';
import 'package:sono/utils/models/tamanho_equipamento.dart';

class EditarTamanhoEquip extends StatelessWidget {
  const EditarTamanhoEquip({
    required Key key,
    required this.tamanho,
    required this.removerTamanho,
  }) : super(key: key);

  final TamanhoItem tamanho;
  final VoidCallback removerTamanho;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 30,
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Tamanho',
              isDense: true,
            ),
            validator: (nome) {
              if (nome == null) return 'Inválido';
              if (nome.isEmpty) return 'Inválido';
              return null;
            },
            onChanged: (nome) => tamanho.nome = nome,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 30,
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Estoque',
              isDense: true,
            ),
            validator: (estoque) {
              if (estoque == null) return 'Inválido';
              if (estoque.isEmpty) return 'Inválido';
              return null;
            },
            onChanged: (estoque) => tamanho.estoque = int.tryParse(estoque) ?? 0,
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        IconButton(
          onPressed: removerTamanho,
          icon: Icon(Icons.remove_circle),
          color: Colors.red,
        ),
      ],
    );
  }
}
