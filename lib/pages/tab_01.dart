import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/model.dart';

class Tab01 extends StatefulWidget {
  const Tab01({Key? key}) : super(key: key);

  @override
  _Tab01State createState() => _Tab01State();
}

class _Tab01State extends State<Tab01> {
  String adriano = 'text';

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return Container(
        color: Colors.blue,
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
