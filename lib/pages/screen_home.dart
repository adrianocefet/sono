import 'package:flutter/material.dart';
import 'package:sono/pages/widgets_drawer.dart';
import 'package:sono/pages/tab_home.dart';
//import 'package:sono/pages/tab_01.dart';
import 'package:sono/pages/tab_paciente.dart';
//import 'package:sono/pages/tab_02.dart';
import 'package:sono/pages/tab_equipamentos.dart';
//import 'package:sono/pages/tab_03.dart';
import 'package:sono/pages/tab_fale.dart';
import 'package:sono/pages/tab_04.dart';


class HomeScreen extends StatelessWidget {

  final _pageController = PageController();


  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          drawerEnableOpenDragGesture: true,
          /*floatingActionButton: FloatingActionButton(
              onPressed: (){
                _pageController.jumpToPage(2);
              })*/
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Pacientes"),
            centerTitle: true,
            backgroundColor: Colors.red,
          ),
          drawer: CustomDrawer(_pageController),
          drawerEnableOpenDragGesture: true,
          body: Paciente(),
          //floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Equipamentos"),
            centerTitle: true,
          ),
          body: Equipamento(),
          drawer: CustomDrawer(_pageController),
          drawerEnableOpenDragGesture: true,
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Fale conosco"),
            centerTitle: true,
          ),
          body: Fale(),
          drawer: CustomDrawer(_pageController),
          drawerEnableOpenDragGesture: true,
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Comunicação"),
            centerTitle: true,
          ),
          body: Tab04(),
          drawer: CustomDrawer(_pageController),
          drawerEnableOpenDragGesture: true,
        )
      ],
    );
  }
}
