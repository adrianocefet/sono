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
    List<Widget> _listaDeBotoes = [
      botaoHospital(Instituicao.hgcc),
      botaoHospital(Instituicao.hgf),
      botaoHospital(Instituicao.huwc),
      botaoHospital(Instituicao.hm),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constantes.corAzulEscuroPrincipal,
      ),
      drawer: FuncionalidadesDrawer(widget.pageController),
      drawerEnableOpenDragGesture: true,
      body: ScopedModelDescendant<Usuario>(
        builder: (context, child, model) {
          return Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                color: Constantes.corAzulEscuroPrincipal,
                height: double.infinity,
              ),
              Positioned(
                  top: 10,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.17,
                    child: Image.asset(
                      'assets/imagens/HomeTab.png',
                      fit: BoxFit.contain,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 235, 235, 235),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.circular(50))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Bem vindo, ${model.nomeCompleto}",
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Selecione uma instituição para gerenciar.",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Wrap(
                            runSpacing: 20,
                            spacing: 20,
                            direction: Axis.horizontal,
                            children: _listaDeBotoes),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget botaoHospital(Instituicao hospital) {
    return ScopedModelDescendant<Usuario>(
      builder: ((context, child, model) {
        bool clicado = false;
        if (hospital == model.instituicao) {
          clicado = true;
        }
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            elevation: 5,
            backgroundColor:
                clicado ? Constantes.corAzulEscuroPrincipal : Colors.white,
          ),
          onPressed: () {
            model.instituicao = hospital;
            Scaffold.of(context).openDrawer();
            setState(() {});
          },
          child: Image.asset(
            clicado
                ? 'assets/imagens/${hospital.emString}PNGBRANCO.png'
                : 'assets/imagens/${hospital.emString}PNG.png',
            fit: BoxFit.contain,
            width: 150,
            height: 150,
          ),
        );
      }),
    );
  }
}
