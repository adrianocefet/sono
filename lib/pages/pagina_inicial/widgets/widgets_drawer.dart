import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sono/utils/models/usuario.dart';
import 'package:sono/pages/pagina_inicial/widgets/tile_drawer.dart';
import 'package:scoped_model/scoped_model.dart';

class FuncionalidadesDrawer extends StatelessWidget {
  final PageController pageController;

  const FuncionalidadesDrawer(this.pageController, {Key? key})
      : super(key: key);

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

    return ScopedModelDescendant<Usuario>(
      builder: (context, child, usuario) {
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Projeto\nSono-UFC",
                          style: TextStyle(
                            fontSize: 34.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "\n${usuario.nomeCompleto}\n"
                              "${usuario.instituicao.emString}\n\n"
                              "Perfil ${usuario.perfil.emString}",
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Visibility(
                    visible: [PerfilUsuario.mestre].contains(usuario.perfil),
                    child: DrawerTile(
                      Icons.home,
                      "Início",
                      pageController,
                      0,
                    ),
                  ),
                  Visibility(
                    visible: [
                      PerfilUsuario.mestre,
                      PerfilUsuario.clinico,
                      PerfilUsuario.vigilancia
                    ].contains(usuario.perfil),
                    child: DrawerTile(
                      Icons.people,
                      "Pacientes",
                      pageController,
                      1,
                    ),
                  ),
                  Visibility(
                    visible: [PerfilUsuario.mestre, PerfilUsuario.dispensacao]
                        .contains(usuario.perfil),
                    child: DrawerTile(
                      Icons.masks_outlined,
                      "Controle de estoque",
                      pageController,
                      2,
                    ),
                  ),
                  Visibility(
                    visible: [PerfilUsuario.mestre, PerfilUsuario.dispensacao]
                        .contains(usuario.perfil),
                    child: DrawerTile(
                      Icons.assignment_rounded,
                      "Solicitações",
                      pageController,
                      3,
                    ),
                  ),
                  Visibility(
                    visible: usuario.perfil == PerfilUsuario.mestre,
                    child: DrawerTile(
                      FontAwesomeIcons.users,
                      "Profissionais",
                      pageController,
                      4,
                    ),
                  ),
                  DrawerTile(
                    Icons.exit_to_app,
                    "Sair",
                    pageController,
                    5,
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('usuario');
                      usuario = Usuario();
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
