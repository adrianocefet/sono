import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sono/utils/helpers/resposta_widget.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/utils/models/usuario.dart';

import 'cadastro_usuario_controller.dart';

class CadastroDeUsuario extends StatefulWidget {
  final Usuario? usuario;
  const CadastroDeUsuario({Key? key, this.usuario}) : super(key: key);

  @override
  State<CadastroDeUsuario> createState() => _CadastroDeUsuarioState();
}

class _CadastroDeUsuarioState extends State<CadastroDeUsuario> {
  final CadastroUsuarioController controller = CadastroUsuarioController();
  @override
  Widget build(BuildContext context) {
    controller.usuario = widget.usuario;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          controller.senhaGerada != null
              ? 'Profissional registrado!'
              : widget.usuario != null
                  ? "Editar profissional"
                  : "Registrar profissional",
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromRGBO(165, 166, 246, 1.0), Colors.white],
            stops: [0, 0.2],
          ),
        ),
        child: controller.senhaGerada != null
            ? Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(17)),
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(14),
                            topRight: Radius.circular(14),
                          ),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: const Center(
                          child: Text(
                            "Informações de login",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(
                                    text:
                                        "Informações de cadastro na plataforma Projeto Sono\n\nProfissional: ${controller.helper.cpfDoUsuario}\nSenha: ${controller.helper.senhaGerada}",
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        Theme.of(context).focusColor,
                                    content: const Text(
                                      'Informações copiadas!',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.copy,
                                color: Theme.of(context).focusColor,
                                size: 30,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Profissional: ',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        controller.helper.cpfDoUsuario!,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Senha: ',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        controller.helper.senhaGerada!,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      for (Pergunta pergunta in controller.perguntas)
                        RespostaWidget(
                          pergunta,
                          autoPreencher:
                              widget.usuario?.infoMap[pergunta.codigo],
                        ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (widget.usuario != null) {
                              await controller.editarUsuario(context);
                            } else {
                              await controller.registrarUsuario(context);
                            }
                          },
                          child: Text(
                            widget.usuario != null
                                ? 'Editar profissional'
                                : 'Registrar profissional',
                            style: const TextStyle(color: Colors.black),
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
      ),
    );
  }
}
