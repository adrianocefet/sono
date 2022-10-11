import 'package:flutter/material.dart';
import 'package:sono/pages/login/login.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/usuario.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/pagina_inicial/screen_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<Usuario>(
      model: Usuario(),
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
          navigateRoute: HomeScreen(),
          duration: 5000,
          imageSize: 500,
          imageSrc: "assets/imagens/splash.jpeg",
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
