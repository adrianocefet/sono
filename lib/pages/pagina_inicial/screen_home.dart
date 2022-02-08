import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/questionarios/selecao_questionario/selecao_questionario.dart';
import 'package:sono/pages/tabelas/adicionar_paciente/adicionar_paciente.dart';
import 'package:sono/pages/tabelas/tabela_equipamentos/tab_equipamentos.dart';
import 'package:sono/pages/pagina_inicial/widgets/widgets_drawer.dart';
import 'package:sono/pages/tabelas/tabela_hospitais_home/tab_home.dart';
import 'package:sono/pages/tabelas/tab_fale.dart';
import 'package:sono/pages/tabelas/tab_04.dart';
import 'package:sono/pages/tabelas/tabela_pacientes/dialogs/adicionar_paciente_dialog.dart';
import 'package:sono/pages/tabelas/tabela_pacientes/tab_paciente.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: const HomeTab(),
          drawer: CustomDrawer(_pageController),
          drawerEnableOpenDragGesture: true,
          /*floatingActionButton: FloatingActionButton(
                onPressed: (){
                  _pageController.jumpToPage(2);
                })*/
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text("Questionários"),
            centerTitle: true,
            backgroundColor: Constants.corPrincipalQuestionarios,
          ),
          drawer: CustomDrawer(_pageController),
          drawerEnableOpenDragGesture: true,
          body: const SelecaoDeQuestionario(),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text("Pacientes"),
            centerTitle: true,
            backgroundColor: Colors.red,
          ),
          drawer: CustomDrawer(_pageController),
          drawerEnableOpenDragGesture: true,
          body: const TabelaDePacientes(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            child: const Icon(
              Icons.add,
            ),
            onPressed: () {
              mostrarDialogAdicionarPaciente(context);
            },
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text("Equipamentos"),
            centerTitle: true,
          ),
          body: const Equipamento(),
          drawer: CustomDrawer(_pageController),
          drawerEnableOpenDragGesture: true,
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text("Fale conosco"),
            centerTitle: true,
          ),
          body: const Fale(),
          drawer: CustomDrawer(_pageController),
          drawerEnableOpenDragGesture: true,
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text("Comunicação"),
            centerTitle: true,
          ),
          body: const Tab04(),
          drawer: CustomDrawer(_pageController),
          drawerEnableOpenDragGesture: true,
        )
      ],
    );
  }
}
