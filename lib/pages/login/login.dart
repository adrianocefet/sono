import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/pagina_inicial/screen_home.dart';
import 'package:sono/utils/dialogs/error_message.dart';
import 'package:sono/utils/models/usuario.dart';
import 'package:sono/utils/services/firebase.dart';
import 'widgets/credenciais.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Usuario? usuarioLogado;

    Future<bool> verificarLogin() async {
      if (FirebaseService().usuarioEstaLogado) {
        try {
          usuarioLogado = await FirebaseService()
              .obterProfissionalPorID(FirebaseService().idUsuario!);

          final prefs = await SharedPreferences.getInstance();
          await prefs.remove("usuario");
          await prefs.setString(
              "usuario", json.encode(usuarioLogado!.infoJsonMap));
        } catch (e) {
          mostrarMensagemErro(context, e.toString());
        }
      }

      return true;
    }

    return FutureBuilder<bool>(
      future: verificarLogin(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (usuarioLogado == null) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/imagens/login.jpg'),
                      const Credenciais(),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return ScopedModelDescendant<Usuario>(
              builder: (context, _, usuario) {
                return PaginalInicial(usuarioLogado!);
              },
            );
          }
        } else {
          return Scaffold(
            backgroundColor: Constantes.corAzulEscuroPrincipal,
            body: Center(
              child: Image.asset("assets/imagens/splash.jpg"),
            ),
          );
        }
      },
    );
  }
}
