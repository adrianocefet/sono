import 'package:flutter/material.dart';

class mostrarTamanho extends StatelessWidget {
  const mostrarTamanho({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: Text(
                "Tamanho: ",
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 30),
              ),
            ),
            Container(

              padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 4),
              child: Text(
                'Estoque: ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25
                ),
              ),
            )
          ],
        ),
    );
  }
}