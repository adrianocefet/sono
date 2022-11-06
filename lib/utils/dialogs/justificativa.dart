import 'package:flutter/material.dart';

Future<String?> mostrarDialogJustificativa(
    BuildContext context, String mensagem, String submensagem) async {
  final TextEditingController _Textcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  return await showDialog(
      context: context,
      builder: (contexto) => Center(
            child: Container(
              margin: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Theme.of(contexto).primaryColor,
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
                        color: Theme.of(contexto).primaryColor,
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
                        child: TextFormField(
                          controller: _Textcontroller,
                          minLines: 2,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            if (value!.isNotEmpty && value.length > 10) {
                              return null;
                            } else if (value.length < 10) {
                              return 'Digite uma descrição mais detalhada!';
                            } else if (value.isEmpty) {
                              return 'Campo vazio!';
                            }
                          },
                          decoration: const InputDecoration(
                              hintText: 'Escreva aqui',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(17)))),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(contexto),
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
                                Navigator.pop(
                                    contexto, _Textcontroller.value.text);
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
