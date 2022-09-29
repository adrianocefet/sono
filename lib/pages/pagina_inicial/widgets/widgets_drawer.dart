import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sono/utils/models/usuario.dart';
import 'package:sono/pages/pagina_inicial/widgets/tile_drawer.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  const CustomDrawer(this.pageController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 203, 236, 241), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );

    return ScopedModelDescendant<Usuario>(builder: (context, child, usuario) {
      return Drawer(
        child: Stack(
          children: <Widget>[
            _buildDrawerBack(),
            ListView(
              padding: const EdgeInsets.only(left: 32.0, top: 16.0),
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                  height: 170.0,
                  child: Stack(
                    children: <Widget>[
                      const Positioned(
                        top: 8.0,
                        left: 0.0,
                        child: Text(
                          "Projeto\nSono-UFC",
                          style: TextStyle(
                              fontSize: 34.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        left: 0.0,
                        bottom: 0.0,
                        child: ScopedModelDescendant<Usuario>(
                          builder: (context, child, model) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  model.instituicao.emString,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                DrawerTile(
                  Icons.home,
                  "Início",
                  pageController,
                  0,
                ),
                DrawerTile(
                  Icons.people,
                  "Pacientes",
                  pageController,
                  1,
                ),
                DrawerTile(
                  Icons.masks_outlined,
                  "Controle de estoque",
                  pageController,
                  2,
                ),
                DrawerTile(
                  Icons.assignment_rounded,
                  "Solicitações",
                  pageController,
                  3,
                ),
                Visibility(
                  visible: usuario.perfil == PerfilUsuario.mestre,
                  child: DrawerTile(
                    FontAwesomeIcons.users,
                    "Usuários",
                    pageController,
                    4,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
