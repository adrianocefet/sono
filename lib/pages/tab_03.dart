import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/model.dart';

class Tab03 extends StatefulWidget {
  const Tab03({Key? key}) : super(key: key);

  @override
  _Tab03State createState() => _Tab03State();
}

class _Tab03State extends State<Tab03> {
  String adriano = 'text';

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return Container(
        color: Colors.amber,
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
