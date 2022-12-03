import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sono/pages/login/login.dart';
import 'package:sono/utils/models/usuario.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    Phoenix(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Usuario? usuario;
  Future<bool> obterUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonUsuario = prefs.getString("usuario");
    usuario = jsonUsuario != null
        ? Usuario.porMapJson(Map<String, String>.from(jsonDecode(jsonUsuario)))
        : null;
    return usuario == null ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: obterUsuario(),
      builder: (context, snapshot) {
        return ScopedModel<Usuario>(
          model: usuario ?? Usuario(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Projeto Sono - UFC',
            theme: ThemeData(
              primaryColor: const Color.fromRGBO(65, 69, 168, 1.0),
              primaryColorLight: const Color.fromRGBO(165, 166, 246, 1.0),
              focusColor: const Color.fromRGBO(97, 253, 125, 1.0),
              highlightColor: const Color.fromRGBO(97, 253, 125, 1.0),
            ),
            home: SplashScreenView(
              navigateRoute: const Login(),
              duration: 3000,
              imageSize: 500,
              imageSrc: "assets/imagens/splash.jpeg",
              backgroundColor: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
