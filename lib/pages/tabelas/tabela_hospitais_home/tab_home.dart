import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/user_model.dart';

import '../../pagina_inicial/widgets/widgets_drawer.dart';

class HomeTab extends StatefulWidget {
  final PageController pageController;

  const HomeTab({Key? key, required this.pageController}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(widget.pageController),
      drawerEnableOpenDragGesture: true,
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return Stack(
            children: [
              Image.asset(
                'assets/imagens/Home.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
              imagemHospital('HGCC', 0.9),
              imagemHospital('HGF', 0.3),
              imagemHospital('HM', -0.3),
              imagemHospital('HUWC', -0.9),
            ],
          );
        },
      ),
    );
  }

  Widget imagemHospital(String hospital, double x) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return Align(
          alignment: AlignmentDirectional(x, .9),
          child: InkWell(
            onTap: () {
              model.hospital = hospital;
              model.Equipamento = 'Equipamento';
              Scaffold.of(context).openDrawer();
            },
            child: Image.asset(
              'assets/imagens/$hospital.png',
              width: MediaQuery.of(context).size.width * 0.2,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
