import 'package:flutter/material.dart';
import 'package:sono/utils/dialogs/carregando.dart';
import 'package:sono/utils/dialogs/error_message.dart';
import 'package:sono/utils/models/solicitacao.dart';
import 'package:sono/utils/services/firebase.dart';

Future<String?> mostrarDialogIntegridade(
    context, String mensagem, String submensagem) async {
  List<String> opcoes = [
    'Em perfeito estado',
    'Apresentando defeito',
    'Faltando peças/acessórios'
  ];
  String? opcaoSelecionada = 'Em perfeito estado';
  final TextEditingController _Textcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  return await showDialog(
      context: context,
      builder: (context) => Center(
            child: Container(
              margin: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Material(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(17),
                          topRight: Radius.circular(17),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          mensagem,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        submensagem,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Theme.of(context)
                                                .primaryColor))),
                                items: opcoes
                                    .map((opcao) => DropdownMenuItem<String>(
                                        value: opcao,
                                        child: Text(
                                          opcao,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        )))
                                    .toList(),
                                value: opcaoSelecionada,
                                onChanged: (opcao) =>
                                    {opcaoSelecionada = opcao}),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _Textcontroller,
                              minLines: 2,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              validator: (value) {
                                if (opcaoSelecionada == opcoes[0]) {
                                  return null;
                                } else if (opcaoSelecionada == opcoes[1] &&
                                    value!.isEmpty) {
                                  return 'Detalhes sobre os defeitos!';
                                } else if (opcaoSelecionada == opcoes[2] &&
                                    value!.isEmpty) {
                                  return 'Detalhes sobre o que está faltando!';
                                }
                              },
                              decoration: const InputDecoration(
                                  hintText: 'Observações',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(17)))),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(97, 253, 125, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                mostrarDialogCarregando(context);
                                try {
                                  Navigator.pop(context);
                                  Navigator.pop(context,
                                      '${opcaoSelecionada}. ${_Textcontroller.value.text}');
                                } catch (e) {
                                  Navigator.pop(context);
                                  mostrarMensagemErro(context, e.toString());
                                }
                              }
                            },
                            child: const Text(
                              'Enviar',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(97, 253, 125, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
}
