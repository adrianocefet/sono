import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sono/pages/perfis/perfil_paciente/perfil_clinico_paciente_controller.dart';
import 'package:sono/pages/perfis/perfil_paciente/widgets/iniciar_avaliacao.dart';
import 'package:sono/pages/perfis/perfil_paciente/widgets/visao_geral.dart';
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
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseService().streamInfoPacientePorID(widget.idPaciente),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              widget.controller.paciente =
                  Paciente.porDocumentSnapshot(snapshot.data!);
              return PageView(
                controller: widget.controller.pageController,
                onPageChanged: (pagina) {
                  widget.controller.paginaAtual.value = pagina;
                },
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            color: Colors.red,
                          )
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          VisaoGeralPaciente(
                            controller: widget.controller,
                          ),
                          IniciarAvaliacao(
                            paciente: widget.controller.paciente,
                          )
                        ],
                      ),
                    ),
                  ),
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
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('ERRO!'),
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
                label: 'Equipamentos',
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
