import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/controle_estoque/widgets/grafico_relatorio.dart';
import 'package:sono/pages/relatorio/relatorio.dart';
import 'package:sono/pages/controle_estoque/tela_status_selecionado.dart';
import '../../utils/models/equipamento.dart';
import '../../utils/models/usuario.dart';
import '../pagina_inicial/widgets/widgets_drawer.dart';
import '../perfis/perfil_equipamento/equipamento_controller.dart';

class ControleEstoque extends StatefulWidget {
  final PageController pageController;
  const ControleEstoque({required this.pageController, Key? key})
      : super(key: key);

  @override
  State<ControleEstoque> createState() => _ControleEstoqueState();
}

class _ControleEstoqueState extends State<ControleEstoque> {
  ControllerPerfilClinicoEquipamento controller =
      ControllerPerfilClinicoEquipamento();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Controle de estoque"),
        backgroundColor: Constantes.corAzulEscuroPrincipal,
        centerTitle: true,
      ),
      drawer: FuncionalidadesDrawer(widget.pageController),
      drawerEnableOpenDragGesture: true,
      body: ScopedModelDescendant<Usuario>(builder: (context, child, model) {
        return Container(
          // ignore: prefer_const_constructors
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromARGB(255, 194, 195, 255), Colors.white],
              stops: [0, 0.4],
            ),
          ),
          child: ListView(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Visibility(
                      visible: model.perfil != PerfilUsuario.gestao,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        direction: Axis.horizontal,
                        spacing: 50,
                        runSpacing: 20,
                        children: [
                          for (StatusDoEquipamento status
                              in StatusDoEquipamento.values)
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor: Colors.white),
                                onPressed: () {
                                  controller.status = status;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ScopedModel<Usuario>(
                                                model: model,
                                                child: TiposEquipamentos(
                                                  controller: controller,
                                                ),
                                              )));
                                },
                                child: SizedBox(
                                  height: 50,
                                  width: 90,
                                  child: Column(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      Icon(
                                        status.icone,
                                        size: 34,
                                        color: const Color.fromRGBO(
                                            97, 253, 125, 1),
                                      ),
                                      Text(
                                        status.emStringPlural,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 2,
                                color: Constantes.corAzulEscuroPrincipal),
                            color: Colors.white),
                        width: MediaQuery.of(context).size.width,
                        child: Column(children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                topRight: Radius.circular(7),
                              ),
                              color: Constantes.corAzulEscuroSecundario,
                            ),
                            height: 50,
                            child: const Text(
                              "Visão Geral",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          const GraficoRelatorio(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(97, 253, 125, 1),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ScopedModel<Usuario>(
                                        model: model,
                                        child: const TelaRelatorio(),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Gerar relatório",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]),
        );
      }),
    );
  }
}
