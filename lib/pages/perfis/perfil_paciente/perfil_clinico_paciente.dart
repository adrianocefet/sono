import 'package:flutter/material.dart';
import 'package:sono/pages/perfis/perfil_paciente/perfil_clinico_paciente_controller.dart';
import 'package:sono/pages/perfis/perfil_paciente/terapia_com_pap/terapia_com_pap.dart';
import 'package:sono/pages/perfis/perfil_paciente/visao_geral/visao_geral.dart';
import 'package:sono/pages/perfis/perfil_paciente/visao_geral/widgets/iniciar_avaliacao.dart';
import 'package:sono/pages/perfis/perfil_paciente/visao_geral/widgets/foto_e_info.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/services/firebase.dart';

class PerfilClinicoPaciente extends StatefulWidget {
  final String idPaciente;
  final ControllerPerfilClinicoPaciente controller =
      ControllerPerfilClinicoPaciente();
  PerfilClinicoPaciente(
    this.idPaciente, {
    Key? key,
  }) : super(key: key);

  @override
  State<PerfilClinicoPaciente> createState() => _PerfilClinicoPacienteState();
}

class _PerfilClinicoPacienteState extends State<PerfilClinicoPaciente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Paciente'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromRGBO(165, 166, 246, 1.0), Colors.white],
            stops: [0, 0.2],
          ),
        ),
        child: StreamBuilder<Object>(
          stream: FirebaseService().streamInfoPacientePorID(widget.idPaciente),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Erro ao obter as informações do paciente!'),
              );
            }
            if (snapshot.hasData) {
              return FutureBuilder<Paciente>(
                future: FirebaseService().obterPacientePorID(
                  widget.idPaciente,
                  comUltimaAvaliacao: true,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    widget.controller.paciente = snapshot.data!;
                    return PageView(
                      controller: widget.controller.pageController,
                      onPageChanged: (pagina) {
                        widget.controller.paginaAtual.value = pagina;
                      },
                      children: [
                        TerapiaComPAP(controller: widget.controller),
                        VisaoGeralDoPaciente(controller: widget.controller),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Container(
                                  width: 200,
                                  height: 200,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao obter as informações do paciente!'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: widget.controller.paginaAtual,
        builder: (context, paginaAtual, _) {
          return BottomNavigationBar(
            backgroundColor: Theme.of(context).primaryColor,
            unselectedItemColor: Theme.of(context).primaryColorLight,
            selectedItemColor: Colors.white,
            currentIndex: paginaAtual,
            onTap: (index) async =>
                await widget.controller.pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
            ),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.masks,
                  color: paginaAtual == 0
                      ? Colors.white
                      : Theme.of(context).primaryColorLight,
                ),
                label: 'Terapia com PAP',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  color: paginaAtual == 1
                      ? Colors.white
                      : Theme.of(context).primaryColorLight,
                ),
                label: 'Avaliação',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.history,
                  color: paginaAtual == 2
                      ? Colors.white
                      : Theme.of(context).primaryColorLight,
                ),
                label: 'Histórico',
              ),
            ],
          );
        },
      ),
    );
  }
}
