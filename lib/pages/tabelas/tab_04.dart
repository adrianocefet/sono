import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/user_model.dart';

import '../pagina_inicial/widgets/widgets_drawer.dart';

class Tab04 extends StatefulWidget {
  final PageController pageController;
  const Tab04({Key? key, required this.pageController}) : super(key: key);

  @override
  _Tab04State createState() => _Tab04State();
}

class _Tab04State extends State<Tab04> {
  String adriano = 'text';

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Comunicação"),
            centerTitle: true,
          ),
          body: Container(
            color: Colors.green,
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
          ),
          drawer: CustomDrawer(widget.pageController),
          drawerEnableOpenDragGesture: true,
        );
      },
    );
  }
}
