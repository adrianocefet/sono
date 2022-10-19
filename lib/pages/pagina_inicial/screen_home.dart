import 'package:flutter/material.dart';
import 'package:sono/pages/login/login.dart';
import 'package:sono/pages/tabelas/lista_de_profissionais.dart';
import 'package:sono/pages/tabelas/tab_home.dart';
import 'package:sono/pages/tabelas/lista_de_pacientes.dart';
import 'package:sono/pages/tabelas/tab_solicitacoes.dart';
import '../controle_estoque/controle_estoque.dart';

class PaginalInicial extends StatelessWidget {
  final _pageController = PageController();

  PaginalInicial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        HomeTab(pageController: _pageController),
        ListaDePacientes(pageController: _pageController),
        ControleEstoque(pageController: _pageController),
        TabelaDeSolicitacoes(pageController: _pageController),
        ListaDeUsuarios(pageController: _pageController),
        const Login(),
      ],
    );
  }
}
