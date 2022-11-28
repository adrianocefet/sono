import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/tabelas/widgets/item_usuario.dart';
import 'package:sono/utils/models/usuario.dart';
import 'package:sono/pages/pagina_inicial/widgets/tile_drawer.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/services/firebase.dart';

class FuncionalidadesDrawer extends StatelessWidget {
  final PageController pageController;

  const FuncionalidadesDrawer(this.pageController, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Usuario>(
      builder: (context, child, usuario) {
        return Drawer(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Constantes.corAzulEscuroPrincipal,
              automaticallyImplyLeading: false,
              toolbarHeight: 100,
              title: const Text(
                "Projeto\nSono-UFC",
                style: TextStyle(
                  fontSize: 34.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 8.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 32.0, top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FotoDoUsuarioThumbnail(usuario.urlFotoDePerfil),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      usuario.nomeCompleto,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      usuario.instituicao.emString,
                                      style: const TextStyle(
                                        color:
                                            Constantes.corAzulEscuroSecundario,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Text(
                          "Perfil ${usuario.perfil.emString}",
                          style: const TextStyle(
                            color: Constantes.corAzulEscuroPrincipal,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Column(
                  children: [
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
                        PerfilUsuario.vigilancia,
                        PerfilUsuario.gestao
                      ].contains(usuario.perfil),
                      child: DrawerTile(
                        Icons.people,
                        "Pacientes",
                        pageController,
                        1,
                      ),
                    ),
                    Visibility(
                      visible: [
                        PerfilUsuario.mestre,
                        PerfilUsuario.dispensacao,
                        PerfilUsuario.gestao,
                        PerfilUsuario.vigilancia
                      ].contains(usuario.perfil),
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
                        await FirebaseService().deslogarUsuario();
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('usuario');
                        usuario = Usuario();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
