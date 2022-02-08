import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/user_model.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return Stack(
          children: [
            Image.asset(
              'assets/imagens/Home.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            ImgHospital('HGCC', 0.9),
            ImgHospital('HGF', 0.3),
            ImgHospital('HM', -0.3),
            ImgHospital('HUWC', -0.9),
          ],
        );
      },
    );
  }

  Widget ImgHospital(String hospital, double x) {
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
