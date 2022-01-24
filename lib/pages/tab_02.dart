import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/model.dart';

class Tab02 extends StatefulWidget {
  const Tab02({Key? key}) : super(key: key);

  @override
  _Tab02State createState() => _Tab02State();
}

class _Tab02State extends State<Tab02> {
  String adriano = 'text';

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return Container(
        color: Colors.deepPurple,
        child: Center(
          child: Row(
            children: [
              Text(
                model.texto,
                textAlign: TextAlign.center,
                //style: TextStyle(fontSize: 30),
              ),
              ElevatedButton(
                onPressed: () {
                  model.teste('Xavier');
                },
                child: Text('data'),
              )
            ],
          ),
        ),
      );
    });
  }
}
