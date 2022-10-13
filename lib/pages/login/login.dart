import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sono/pages/pagina_inicial/screen_home.dart';
import 'package:sono/utils/services/firebase.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/imagens/splash.jpeg'),
              const _Credenciais(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Credenciais extends StatelessWidget {
  const _Credenciais({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController _cpfController = TextEditingController();
    TextEditingController _senhaController = TextEditingController();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          _Credencial.cpf(_cpfController),
          _Credencial.senha(_senhaController),
          _BotaoDeLogin(
            [_cpfController.text, _senhaController.text],
            formKey: _formKey,
          ),
        ],
      ),
    );
  }
}

class _Credencial extends StatefulWidget {
  late final bool _senha;
  final TextEditingController controller;
  _Credencial.cpf(
    this.controller, {
    Key? key,
  }) : super(key: key) {
    _senha = false;
  }

  _Credencial.senha(
    this.controller, {
    Key? key,
  }) : super(key: key) {
    _senha = true;
  }

  @override
  State<_Credencial> createState() => _CredencialState();
}

class _CredencialState extends State<_Credencial> {
  bool _obscuro = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            obscureText: widget._senha && _obscuro,
            validator: !widget._senha
                ? (value) {
                    if (value!.isEmpty) return 'Dado obrigatório.';
                    if (int.tryParse(value) == null) {
                      return 'Insira apenas números.';
                    }
                    return null;
                  }
                : (value) {
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
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: widget._senha ? 'Senha' : 'CPF',
              filled: true,
              fillColor: Colors.white,
              suffixIcon: widget._senha
                  ? IconButton(
                      icon: _obscuro
                          ? Icon(
                              Icons.visibility_off,
                              color: Theme.of(context).primaryColorLight,
                            )
                          : Icon(
                              Icons.visibility,
                              color: Theme.of(context).primaryColorLight,
                            ),
                      onPressed: () => setState(() {
                        _obscuro = !_obscuro;
                      }),
                    )
                  : null,
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
          )
        ],
      ),
    );
  }
}

class _BotaoDeLogin extends StatelessWidget {
  final List<String?> infoLogin;
  final GlobalKey<FormState> formKey;
  const _BotaoDeLogin(this.infoLogin, {Key? key, required this.formKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            final prefs = await SharedPreferences.getInstance();
            final idUsuario =
                await FirebaseService().procurarUsuarioNoBancoDeDados({
              'cpf': infoLogin.first,
              'senha': infoLogin.last,
            });

            if (idUsuario != null) {
              await FirebaseService().obterProfissionalPorID(idUsuario);
              await prefs.setBool('logado', true);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Credenciais não autorizadas!'),
                ),
              );
            }
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
    );
  }
}
