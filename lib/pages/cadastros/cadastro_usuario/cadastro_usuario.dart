import 'package:flutter/material.dart';
import 'package:sono/utils/helpers/resposta_widget.dart';
import 'package:sono/utils/models/pergunta.dart';

import 'cadastro_usuario_controller.dart';

class CadastroDeUsuario extends StatelessWidget {
  const CadastroDeUsuario({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CadastroUsuarioController controller = CadastroUsuarioController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registrar usuário",
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: controller.senhaGerada != null
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.5,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              controller: ScrollController(),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    for (Pergunta pergunta in controller.perguntas)
                      RespostaWidget(
                        pergunta,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () async =>
                            await controller.registrarUsuario(context),
                        child: const Text(
                          'Registrar usuário',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 5.0,
                          backgroundColor: Theme.of(context).focusColor,
                          fixedSize: Size(
                            MediaQuery.of(context).size.width,
                            50,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
