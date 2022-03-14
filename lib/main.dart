import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// metodo principal do flutter
main() {
  // metodo para o app funcionar, desenhar na tela 
  runApp(AppMyWidget());
}


//Widget global (sem estado, imutavel)
class AppMyWidget extends StatelessWidget{
  const AppMyWidget({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(                                   
      child: Center( 
        child: Text( 
          'TESTE', 
          textDirection: TextDirection.ltr,
          style: TextStyle(color: Colors.white, fontSize: 50.0),
        ),
      ),
    );
  }
}