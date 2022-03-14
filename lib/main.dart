import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// metodo principal do flutter
main() {
  // metodo para o app funcionar, desenhar na tela 
  runApp(Container(                                   
    child: Center( 
      child: Text( 
        'TESTE', 
        textDirection: TextDirection.ltr,
        style: TextStyle(color: Colors.white, fontSize: 50.0),
      )
    ),
  ));
}