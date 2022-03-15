import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// metodo principal do flutter
main() {
  // metodo para o app funcionar, desenhar na tela 
  runApp(AppMyWidget(
    title: 'test sono',
  ));
}


//Widget global (sem estado, imutavel)
class AppMyWidget extends StatelessWidget{ 
  final String title;

  const AppMyWidget({Key? key, this.title="emply"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(),
      theme: ThemeData(
        primarySwatch: Colors.red 
      ),
    );
  }
}


//   @override
//   Widget build(BuildContext context) {
//     return Container(                                   
//       child: Center( 
//         child: Text( 
//           title, 
//           textDirection: TextDirection.ltr,
//           style: TextStyle(color: Colors.white, fontSize: 50.0),
//         ),
//       ),
//     );
//   }
// }