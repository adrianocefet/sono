import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/pages/cadastros/cadastro_paciente/cadastro_paciente_controller.dart';
import 'package:sono/utils/helpers/resposta_widget.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/utils/models/user_model.dart';

class CadastroPaciente extends StatefulWidget {
  const CadastroPaciente({Key? key}) : super(key: key);

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
    return ScopedModelDescendant<UserModel>(
      builder: (context, _, model) {
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
            extendBody: true,
            appBar: AppBar(
              title: const Text("Registrar paciente"),
              centerTitle: true,
              backgroundColor: Theme.of(context).primaryColor,
              bottom: PreferredSize(
                preferredSize: Size.zero,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    value: (controller.paginaAtual + 1) / 3,
                    color: Theme.of(context).focusColor,
                  ),
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
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.pageController,
                onPageChanged: (index) {
                  controller.paginaAtual = index;
                  setState(() {});
                },
                children: [
                  for (String index in ['1', '2', '3'])
                    SingleChildScrollView(
                      controller: ScrollController(),
                      child: Form(
                        key: controller.formKeys[int.parse(index) - 1],
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            for (Pergunta pergunta in controller.perguntas)
                              if (pergunta.dominio == index)
                                RespostaWidget(pergunta),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (/*controller.salvarRespostasDaPaginaAtual()*/ true) {
                                    await controller.pageController.nextPage(
                                      curve: Curves.easeIn,
                                      duration:
                                          const Duration(milliseconds: 400),
                                    );
                                  }
                                },
                                child: Text(
                                  controller.paginaAtual == 2
                                      ? "Registrar paciente"
                                      : "Avançar",
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  shadowColor: Colors.transparent,
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width,
                                      50),
                                  primary: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
