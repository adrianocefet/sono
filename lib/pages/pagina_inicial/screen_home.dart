import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/tabelas/tab_equipamentos.dart';
import 'package:sono/pages/tabelas/tab_home.dart';
import 'package:sono/pages/tabelas/tab_paciente.dart';
import '../../utils/models/user_model.dart';
import '../tabelas/tab_controleEstoque.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        inicializa
            ? {
                model.equipamento = 'Equipamento',
                inicializa = false,
              }
            : null;
        return PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            HomeTab(pageController: _pageController),
            TabelaDePacientes(pageController: _pageController),
            TabelaControleEstoque(pageController: _pageController),
          ],
        );
      },
    );
  }
}
