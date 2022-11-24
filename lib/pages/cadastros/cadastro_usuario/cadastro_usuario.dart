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
          controller.senhaGerada.value != null
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
        child: ValueListenableBuilder(
          valueListenable: controller.senhaGerada,
          builder: (context, value, child) =>
              controller.senhaGerada.value != null
                  ? _InfoCadastro(
                      controller: controller,
                    )
                  : SingleChildScrollView(
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            for (Pergunta pergunta in controller.perguntas)
                              widget.usuario != null &&
                                      ['email', 'cpf'].contains(pergunta.codigo)
                                  ? const SizedBox.shrink()
                                  : RespostaWidget(
                                      pergunta,
                                      autoPreencher: widget
                                          .usuario?.infoMap[pergunta.codigo],
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
      ),
    );
  }
}

class _InfoCadastro extends StatelessWidget {
  final CadastroUsuarioController controller;
  const _InfoCadastro({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
                  "Profissional cadastrado com sucesso!",
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
                              "Informações de cadastro na plataforma Projeto Sono\n\nEmail: ${controller.helper.emailDoUsuario}"
                              "\nSenha: ${controller.helper.senhaGerada}"
                              "\n\nNão compartilhe esta senha!"
                              " Recomendamos que você peça a recuperação da senha na tela de login e troque por uma que apenas você tenha conhecimento!",
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Theme.of(context).focusColor,
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
                        Text(
                          'Informações de cadastro\n',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Email: ',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              controller.helper.emailDoUsuario!,
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
    );
  }
}
