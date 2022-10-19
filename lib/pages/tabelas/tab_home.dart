import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/utils/models/usuario.dart';

import '../pagina_inicial/widgets/widgets_drawer.dart';

class HomeTab extends StatefulWidget {
  final PageController pageController;

  const HomeTab({Key? key, required this.pageController}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    List<Widget> _listaImagens = [
      imagemHospital(Instituicao.hgcc),
      imagemHospital(Instituicao.hgf),
      imagemHospital(Instituicao.huwc),
      imagemHospital(Instituicao.hm),
    ];

    return Scaffold(
      drawer: FuncionalidadesDrawer(widget.pageController),
      drawerEnableOpenDragGesture: true,
      body: ScopedModelDescendant<Usuario>(
        builder: (context, child, model) {
          print(model.nomeCompleto);
          return Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Image.asset(
                'assets/imagens/Home.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
              Container(
                color: Constantes.corAzulEscuroPrincipal.withOpacity(0.7),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(
                      color: Constantes.corAzulEscuroSecundario,
                      thickness: 2.5,
                      height: 1,
                    ),
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: _listaImagens,
                            ),
                          )
                        : GridView.count(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            shrinkWrap: true,
                            childAspectRatio: 1.7,
                            crossAxisSpacing: 40,
                            mainAxisSpacing: 5,
                            crossAxisCount: 2,
                            children: _listaImagens,
                          ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget imagemHospital(Instituicao hospital) {
    return ScopedModelDescendant<Usuario>(
      builder: (context, child, model) {
        bool clicado = false;
        if (hospital == model.instituicao) {
          clicado = true;
        }
        return Material(
          color: clicado
              ? const Color.fromARGB(255, 35, 39, 104)
              : Colors.transparent,
          child: InkWell(
            splashColor: Constantes.corAzulEscuroSecundario,
            highlightColor: const Color.fromARGB(255, 35, 39, 104),
            onTap: () {
              model.instituicao = hospital;
              Scaffold.of(context).openDrawer();
              setState(() {});
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
              child: Image.asset(
                'assets/imagens/${hospital.emString}.png',
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.15,
              ),
            ),
          ),
        );
      },
    );
  }
}
