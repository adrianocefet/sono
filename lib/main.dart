import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sono/pages/login/login.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/usuario.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/pagina_inicial/screen_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final Usuario? statusLogin = prefs.getString('usuario') == null
      ? null
      : Usuario.porMapJson(
          Map<String, String?>.from(jsonDecode(prefs.getString('usuario')!)));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MyApp(
      usuarioLogado: statusLogin,
    ),
  );
}

class MyApp extends StatefulWidget {
  final Usuario? usuarioLogado;
  const MyApp({Key? key, required this.usuarioLogado}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<Usuario>(
      model: widget.usuarioLogado ?? Usuario(),
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
          navigateRoute: widget.usuarioLogado == null
              ? const Login()
              : const PaginalInicial(),
          duration: 5000,
          imageSize: 500,
          imageSrc: "assets/imagens/splash.jpeg",
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
