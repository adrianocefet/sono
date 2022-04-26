import 'package:flutter/material.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/tamanho_equipamento.dart';
import 'editar_tamanho_item.dart';
import 'package:sono/globais/global.dart' as global;

class formTamanhos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          FormField<List<TamanhoItem>>(
            validator: (tamanhos) {
              if (tamanhos == null) return 'Insira um tamanho';
              if (tamanhos.isEmpty) return 'Insira um tamanho';
              return null;
            },
            builder: (state) {
              state.value!=null? global.tamanhos=state.value! : null;
              return Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Tamanhos',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.59),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.add),
                          color: Colors.black,
                          onPressed: () {
                            state.value == null

                                ? state.setValue(
                                    List<TamanhoItem>.empty(growable: true))
                                : null;

                            state.value!.add(TamanhoItem(nome: "", estoque: 0));
                            
                            state.didChange(state.value);

                          })
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      padding: EdgeInsets.only(top: 0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withAlpha(70))),
                    ),
                  ),
                  state.value != null
                      ? Column(
                          children: state.value!.map((cadaTamanho) {
                            return EditarTamanhoEquip(
                              key: ObjectKey(cadaTamanho),
                              tamanho: cadaTamanho,
                              removerTamanho: () {
                                state.value!.remove(cadaTamanho);
                                state.didChange(state.value);
                              },
                            );
                          }).toList(),
                        )
                      : SizedBox(),
                  if (state.hasError)
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        state.errorText.toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
