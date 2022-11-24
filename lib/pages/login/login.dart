import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
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
                      Image.asset('assets/imagens/splash.jpeg'),
                      const Credenciais(),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return ScopedModel<Usuario>(
              model: usuarioLogado!,
              child: const PaginalInicial(),
            );
          }
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Image.asset("assets/imagens/splash.jpeg"),
            ),
          );
        }
      },
    );
  }
}
