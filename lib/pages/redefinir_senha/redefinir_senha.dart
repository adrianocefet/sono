import 'package:flutter/material.dart';
import 'package:sono/utils/dialogs/carregando.dart';
import 'package:sono/utils/services/firebase.dart';

class RedefinirSenha extends StatelessWidget {
  const RedefinirSenha({Key? key}) : super(key: key);
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Redefinir senha"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/imagens/login.jpg',
              width: 350,
              height: 350,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.2,
                  ),
                  child: Text(
                    "Insira seu email para redefinir sua senha",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: controller,
                          validator: (value) {
                            if (value!.isEmpty) return 'Dado obrigatório.';
                            return null;
                          },
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1.2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1.2,
                              ),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1.2,
                              ),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1.2,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    mostrarDialogCarregando(context);
                    if (!_formKey.currentState!.validate()) {
                      throw Exception('Credenciais inválidas.');
                    }

                    final String? idUsuario =
                        await FirebaseService().procurarUsuarioNoBancoDeDados({
                      'email': controller.text,
                    });

                    if (idUsuario != null) {
                      await FirebaseService().enviarEmailDeRedefinicaoDeSenha(
                        controller.text,
                      );
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Theme.of(context).focusColor,
                          content: const Text(
                            'Email de redefinição de senha enviado com sucesso!',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    } else {
                      throw Exception('Usuário não encontrado!');
                    }
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content:
                            Text('Erro ao enviar o email! ${e.toString()}'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Login',
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
    );
  }
}
