import 'package:flutter/material.dart';
import 'package:sono/utils/models/equipamento.dart';

import '../../../../constants/constants.dart';
import 'adicionarObservacao.dart';

class Observacao extends StatefulWidget {
  final Equipamento equipamento;
  const Observacao(this.equipamento, {Key? key}) : super(key: key);

  @override
  State<Observacao> createState() => _ObservacaoState();
}

class _ObservacaoState extends State<Observacao> {
  bool clicado = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: AnimatedContainer(
        curve: Curves.easeIn,
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.1),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1)),
        duration: const Duration(milliseconds: 240),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                color: Constantes.corAzulEscuroSecundario,
              ),
              height: 30,
              child: const Text(
                "Observações",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            widget.equipamento.observacao != null
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(
                          widget.equipamento.observacao ?? 'Observação vazia!',
                          maxLines: clicado ? null : 3,
                          overflow: clicado ? null : TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                        Visibility(
                          visible: widget.equipamento.observacao!.length > 141,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    clicado = !clicado;
                                  });
                                },
                                child: Text(
                                  clicado ? 'Mostrar menos' : 'Mostrar mais',
                                  style: const TextStyle(
                                      color: Constantes.corAzulEscuroPrincipal),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(97, 253, 125, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                            onPressed: () {
                              adicionarObservacao(context, widget.equipamento);
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.add,
                              color: Colors.black,
                            ))),
                  )
          ],
        ),
      ),
    );
  }
}
