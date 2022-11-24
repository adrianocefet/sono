import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'botao_de_login.dart';

class Credenciais extends StatelessWidget {
  const Credenciais({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, prefs) {
        List<String>? dadosSalvos = prefs.data?.getStringList('lembrarDeMim');
        TextEditingController _emailController =
            TextEditingController(text: dadosSalvos?.first);
        TextEditingController _senhaController =
            TextEditingController(text: dadosSalvos?.last);
        return Form(
          key: _formKey,
          child: Column(
            children: [
              _Credencial.email(_emailController),
              _Credencial.senha(_senhaController),
              BotaoDeLogin(
                [_emailController, _senhaController],
                formKey: _formKey,
                lembrarDeMim: dadosSalvos != null,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Credencial extends StatefulWidget {
  late final bool _senha;
  final TextEditingController controller;
  _Credencial.email(
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
            controller: widget.controller,
            obscureText: widget._senha && _obscuro,
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
              labelText: widget._senha ? 'Senha' : 'Email',
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
                      onPressed: () => setState(
                        () {
                          _obscuro = !_obscuro;
                        },
                      ),
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
