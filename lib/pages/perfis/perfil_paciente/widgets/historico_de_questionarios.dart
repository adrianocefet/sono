import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_rich_text/simple_rich_text.dart';
import 'package:sono/constants/constants.dart';
import 'package:sono/pages/questionarios/berlin/questionario/berlin_controller.dart';
import 'package:sono/pages/questionarios/epworth/resultado/resultado_epworth.dart';
import 'package:sono/pages/questionarios/goal/questionario/goal_controller.dart';
import 'package:sono/pages/questionarios/pittsburg/resultado/resultado_pittsburg.dart';
import 'package:sono/pages/questionarios/sacs_br/questionario/sacs_br_controller.dart';
import 'package:sono/pages/questionarios/stop_bang/resultado/resultado_stop_bang.dart';
import 'package:sono/pages/questionarios/whodas/resultado/resultado_whodas.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:sono/utils/services/firebase.dart';

class HistoricoDeQuestionarios extends StatefulWidget {
  final Paciente paciente;
  final UserModel model;
  const HistoricoDeQuestionarios(
      {required this.paciente, required this.model, Key? key})
      : super(key: key);

  @override
  State<HistoricoDeQuestionarios> createState() => _PacienteVisaoGeralState();
}

class _PacienteVisaoGeralState extends State<HistoricoDeQuestionarios> {
  final PageController _pageViewController = PageController();
  ValueNotifier<QueryDocumentSnapshot<Map<String, dynamic>>?>
      questionarioEmFoco = ValueNotifier(null);

  String _formatarData(String data) {
    return DateFormat("dd/MM/yyyy").format(DateTime.parse(data));
  }

  dynamic _gerarClasseResultadoDoQuestionario(
      String nomeQuestionario, Map<String, dynamic> mapa) {
    switch (nomeQuestionario) {
      case "Berlin":
        return ResultadoBerlin.porMapa(mapa);
      case "Stop-Bang":
        return ResultadoStopBang.porMapa(mapa);
      case "SACS-BR":
        return ResultadoSACSBR.porMapa(mapa);
      case "WHODAS":
        return ResultadoWHODAS.porMapa(mapa);
      case "GOAL":
        return ResultadoGOAL.porMapa(mapa);
      case "Pittsburg":
        return ResultadoPittsburg.porMapa(mapa);
      case "Epworth":
        return ResultadoEpworth.porMapa(mapa);
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic classeResultado;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseService().streamQuestionarios(widget.paciente.id!),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.none:
            return const Center(
              child: Text(
                "ERRO NA CONEXÃO!",
                style: TextStyle(
                  color: Constantes.corAzulEscuroPrincipal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );

          default:
            List<QueryDocumentSnapshot<Map<String, dynamic>>>
                historicosDisponiveis = snapshot.data!.docs
                    .where((historico) =>
                        Constantes.nomesQuestionarios.contains(historico.id))
                    .toList();
            List<Widget> paginas = [
              ListView.separated(
                itemCount: historicosDisponiveis.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(
                      historicosDisponiveis[i].id,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () async {
                      questionarioEmFoco.value = historicosDisponiveis[i];

                      await _pageViewController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      );
                    },
                  );
                },
                separatorBuilder: (context, i) => const Divider(
                  thickness: 2,
                  color: Constantes.corAzulEscuroSecundario,
                ),
              ),
              WillPopScope(
                onWillPop: () async {
                  await _pageViewController.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn,
                  );
                  return false;
                },
                child: ValueListenableBuilder<
                    QueryDocumentSnapshot<Map<String, dynamic>>?>(
                  valueListenable: questionarioEmFoco,
                  builder: (context, resultados, _) {
                    return ListView.separated(
                      itemCount: resultados?.data().length ?? 0,
                      itemBuilder: (context, i) {
                        classeResultado = _gerarClasseResultadoDoQuestionario(
                            resultados!.id,
                            resultados.data().values.toList()[i]);
                        return ListTile(
                          title: Text(
                            classeResultado.resultadoEmString,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            _formatarData(
                              resultados.data().keys.toList()[i].toString(),
                            ),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          onTap: () async {
                            await _pageViewController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeIn,
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, i) => const Divider(
                        thickness: 2,
                        color: Constantes.corAzulEscuroSecundario,
                      ),
                    );
                  },
                ),
              ),
              WillPopScope(
                onWillPop: () async {
                  await _pageViewController.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn,
                  );
                  return false;
                },
                child: ValueListenableBuilder<
                    QueryDocumentSnapshot<Map<String, dynamic>>?>(
                  valueListenable: questionarioEmFoco,
                  builder: (context, questionario, _) {
                    return ListView.separated(
                      itemCount: classeResultado?.perguntas.length ?? 0,
                      itemBuilder: (context, i) {
                        Pergunta? pergunta = classeResultado?.perguntas[i];
                        return ListTile(
                          title: SimpleRichText(
                            pergunta?.enunciado,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            (pergunta?.respostaExtenso ?? pergunta?.resposta)
                                .toString(),
                          ),
                        );
                      },
                      separatorBuilder: (context, i) => const Divider(
                        thickness: 1,
                        color: Constantes.corAzulEscuroSecundario,
                      ),
                    );
                  },
                ),
              ),
            ];
            return PageView(
              controller: _pageViewController,
              physics: const NeverScrollableScrollPhysics(),
              children: paginas,
            );
        }
      },
    );
  }
}
