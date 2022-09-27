import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/cadastros/cadastro_paciente/cadastro_paciente_controller.dart';
import 'package:sono/utils/dialogs/carregando.dart';
import 'package:sono/utils/helpers/resposta_widget.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/utils/models/usuario.dart';

import '../../perfis/perfil_paciente/perfil_clinico_paciente.dart';

class CadastroPaciente extends StatefulWidget {
  final Paciente? pacienteJaCadastrado;
  const CadastroPaciente({Key? key, this.pacienteJaCadastrado})
      : super(key: key);

  @override
  State<CadastroPaciente> createState() => _CadastroPacienteState();
}

class _CadastroPacienteState extends State<CadastroPaciente> {
  final CadastroPacienteController controller = CadastroPacienteController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.helper.paciente = widget.pacienteJaCadastrado;

    return ScopedModelDescendant<Usuario>(
      builder: (context, _, model) {
        controller.helper.usuario = model;
        return WillPopScope(
          onWillPop: () async {
            if (controller.paginaAtual == 0) {
              Navigator.pop(context);
              return true;
            } else {
              await controller.pageController.previousPage(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 400),
              );
              return false;
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                widget.pacienteJaCadastrado == null
                    ? "Registrar paciente"
                    : "Editar paciente",
              ),
              centerTitle: true,
              backgroundColor: Theme.of(context).primaryColor,
              bottom: PreferredSize(
                preferredSize: Size.zero,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  value: (controller.paginaAtual + 1) / 2,
                  color: Theme.of(context).focusColor,
                ),
              ),
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
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.pageController,
                onPageChanged: (index) {
                  controller.paginaAtual = index;
                  setState(() {});
                },
                itemCount: 2,
                itemBuilder: (context, i) {
                  String dominio = ['conversa', 'exame fisico'][i];

                  return SingleChildScrollView(
                    controller: ScrollController(),
                    child: Form(
                      key: controller.formKeys[dominio == 'conversa' ? 0 : 1],
                      child: Column(
                        children: [
                          for (Pergunta pergunta in controller.perguntas)
                            if (pergunta.dominio == dominio)
                              RespostaWidget(
                                pergunta,
                                autoPreencher:
                                    widget.pacienteJaCadastrado != null
                                        ? widget.pacienteJaCadastrado!
                                            .infoMap[pergunta.codigo]
                                        : null,
                              ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (controller.salvarRespostasDaPaginaAtual()) {
                                  if (controller.paginaAtual == 1) {
                                    try {
                                      mostrarDialogCarregando(context);
                                      if (widget.pacienteJaCadastrado != null) {
                                        await controller.helper
                                            .editarPaciente();
                                      } else {
                                        await controller.helper
                                            .registrarPaciente();
                                      }
                                      Navigator.pop(context);
                                      if (widget.pacienteJaCadastrado == null) {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PerfilClinicoPaciente(
                                              controller.helper.idPaciente!,
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    } catch (e) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Erro ao ${widget.pacienteJaCadastrado == null ? "registrar paciente!" : "editar paciente!"}',
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    await controller.pageController.nextPage(
                                      curve: Curves.easeIn,
                                      duration:
                                          const Duration(milliseconds: 400),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                controller.paginaAtual == 1
                                    ? widget.pacienteJaCadastrado == null
                                        ? "Registrar paciente"
                                        : "Editar paciente"
                                    : "Avançar",
                                style: const TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 5.0,
                                backgroundColor: Theme.of(context).focusColor,
                                fixedSize: Size(
                                  MediaQuery.of(context).size.width,
                                  50,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
