import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/questionarios/selecao_questionario/selecao_questionario.dart';
import 'package:sono/pages/tabelas/tabela_equipamentos/tab_equipamentos.dart';
import 'package:sono/pages/tabelas/tabela_hospitais_home/tab_home.dart';
import 'package:sono/pages/tabelas/tab_fale.dart';
import 'package:sono/pages/tabelas/tab_04.dart';
import 'package:sono/pages/tabelas/tabela_pacientes/tab_paciente.dart';
import '../../utils/models/user_model.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        inicializa
            ? {model.Equipamento = 'Equipamento', inicializa = false}
            : null;
        return PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            HomeTab(pageController: _pageController),
            SelecaoDeQuestionario(pageController: _pageController),
            TabelaDePacientes(pageController: _pageController),
            TabelaDeEquipamentos(pageController: _pageController),
            Fale(pageController: _pageController),
            Tab04(pageController: _pageController),
          ],
        );
      },
    );
  }
}
