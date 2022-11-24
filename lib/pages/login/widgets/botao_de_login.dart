import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sono/pages/pagina_inicial/screen_home.dart';
import 'package:sono/pages/redefinir_senha/redefinir_senha.dart';
import 'package:sono/utils/dialogs/carregando.dart';
import 'package:sono/utils/models/usuario.dart';
import 'package:sono/utils/services/firebase.dart';

class BotaoDeLogin extends StatefulWidget {
  bool lembrarDeMim;
  final List<TextEditingController> infoLogin;
  final GlobalKey<FormState> formKey;
  BotaoDeLogin(this.infoLogin,
      {Key? key, required this.formKey, required this.lembrarDeMim})
      : super(key: key);

  @override
  State<BotaoDeLogin> createState() => _BotaoDeLoginState();
}

class _BotaoDeLoginState extends State<BotaoDeLogin> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    activeColor: Theme.of(context).focusColor,
                    value: widget.lembrarDeMim,
                    onChanged: (value) => setState(() {
                      widget.lembrarDeMim = value!;
                    }),
                  ),
                  Text(
                    'Lembrar de mim',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RedefinirSenha(),
                  ),
                ),
                child: Text(
                  "Esqueceu a senha?",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () async {
              try {
                mostrarDialogCarregando(context);
                if (!widget.formKey.currentState!.validate()) {
                  throw Exception('Credenciais inválidas.');
                }

                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                final String? idUsuario =
                    await FirebaseService().procurarUsuarioNoBancoDeDados({
                  'email': widget.infoLogin.first.text,
                });

                if (idUsuario != null) {
                  Usuario usuario =
                      await FirebaseService().obterProfissionalPorID(idUsuario);

                  await FirebaseService().logarComEmailESenha(
                    widget.infoLogin.first.text,
                    widget.infoLogin.last.text,
                  );

                  await prefs.setString(
                    'usuario',
                    json.encode(usuario.infoJsonMap),
                  );
                  if (widget.lembrarDeMim) {
                    await prefs.setStringList(
                      'lembrarDeMim',
                      [usuario.email, widget.infoLogin.last.text],
                    );
                  } else {
                    await prefs.remove('lembrarDeMim');
                  }

                  print(usuario.infoMap);

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScopedModel<Usuario>(
                        model: usuario,
                        child: const PaginalInicial(),
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
                    content: Text('Erro ao logar! ${e.toString()}'),
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
    );
  }
}
