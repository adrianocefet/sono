import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:sono/pages/screen_home.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/model.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

 @override
  Widget build(BuildContext context) {
    Widget example1 = SplashScreenView(
      navigateRoute: HomeScreen(),
      duration: 5000,
      imageSize: 500,
      imageSrc: "assets/imagens/splash.jpeg",
      //text: "Projeto Sono - UFC",
      //textType: TextType.TyperAnimatedText,
      //textStyle: TextStyle(fontSize: 30.0,),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );

    return ScopedModel<UserModel>(
        model: UserModel(),
        child: MaterialApp(
          title: 'Projeto Sono - UFC',
          home: example1,
        )
    );
  }
}