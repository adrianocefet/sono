import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sono/pages/avaliacao/questionarios/berlin/questionario/berlin_controller.dart';
import 'package:sono/pages/avaliacao/questionarios/berlin/resultado/resultado_berlin_view.dart';
import 'package:sono/pages/avaliacao/questionarios/epworth/resultado/resultado_epworth.dart';
import 'package:sono/pages/avaliacao/questionarios/epworth/resultado/resultado_epworth_view.dart';
import 'package:sono/pages/avaliacao/questionarios/goal/questionario/goal_controller.dart';
import 'package:sono/pages/avaliacao/questionarios/goal/resultado/resultado_goal_view.dart';
import 'package:sono/pages/avaliacao/questionarios/pittsburg/resultado/resultado_pittsburg.dart';
import 'package:sono/pages/avaliacao/questionarios/pittsburg/resultado/resultado_pittsburg_view.dart';
import 'package:sono/pages/avaliacao/questionarios/sacs_br/questionario/sacs_br_controller.dart';
import 'package:sono/pages/avaliacao/questionarios/sacs_br/resultado/resultado_sacs_br_view.dart';
import 'package:sono/pages/avaliacao/questionarios/stop_bang/resultado/resultado_stop_bang.dart';
import 'package:sono/pages/avaliacao/questionarios/stop_bang/resultado/resultado_stop_bang_view.dart';
import 'package:sono/pages/avaliacao/questionarios/whodas/resultado/resultado_whodas.dart';
import 'package:sono/pages/avaliacao/questionarios/whodas/resultado/resultado_whodas_view.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/pages/avaliacao/questionarios/berlin/questionario/berlin.dart';
import 'package:sono/pages/avaliacao/questionarios/epworth/questionario/epworth_view.dart';
import 'package:sono/pages/avaliacao/questionarios/goal/questionario/goal.dart';
import 'package:sono/pages/avaliacao/questionarios/pittsburg/questionario/pittsburg_view.dart';
import 'package:sono/pages/avaliacao/questionarios/sacs_br/questionario/sacs_br.dart';
import 'package:sono/pages/avaliacao/questionarios/stop_bang/questionario/stop_bang.dart';
import 'package:sono/pages/avaliacao/questionarios/whodas/questionario/whodas_view.dart';
import 'package:sono/utils/services/firebase.dart';
import 'exame.dart';

class Avaliacao {
  Avaliacao({
    required this.idAvaliador,
    required this.paciente,
  });
  final String idAvaliador;
  final Paciente paciente;
  final Timestamp dataDaAvaliacao = Timestamp.now();
  final GlobalKey<FormState> keyExamesDescritivos = GlobalKey<FormState>();
  final ValueNotifier<List<Exame>> _examesRealizados =
      ValueNotifier<List<Exame>>(List.empty(growable: true));

  String get dataDaAvaliacaoFormatada =>
      DateFormat('dd, MMM, yyyy hh:mm').format(dataDaAvaliacao.toDate());

  ValueNotifier<List<Exame>> get examesRealizadoNotifier => _examesRealizados;

  List<Exame> get listaDeExamesRealizados => _examesRealizados.value;

  bool verificarSeOExameFoiRealizado(Exame exame) =>
      _examesRealizados.value.contains(exame);

  bool verificarSeOQuestionarioFoiRealizado(
          TipoQuestionario tipoQuestionario) =>
      _examesRealizados.value
          .where(
            (exame) =>
                exame.tipo == TipoExame.questionario &&
                exame.tipoQuestionario == tipoQuestionario,
          )
          .isNotEmpty;

  List<TipoQuestionario> listarQuestionariosRealizados() {
    return listaDeExamesRealizados
        .where(
          (exame) => exame.tipo == TipoExame.questionario,
        )
        .map((e) => e.tipoQuestionario!)
        .toList();
  }

  Future<void> salvarAvaliacaoNoBancoDeDados() async {
    await FirebaseService().salvarAvaliacao(this);
  }

  void salvarExame(Exame exame) {
    if (listaDeExamesRealizados.contains(exame) == false) {
      _examesRealizados.value += [exame];
    }
  }

  void removerExame(Exame exame) {
    List<Exame> exameRealizados = _examesRealizados.value;
    exameRealizados.remove(exame);
    _examesRealizados.value = exameRealizados;
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    _examesRealizados.notifyListeners();
  }

  void modificarExame(Exame exame) {
    List<Exame> exameRealizados = listaDeExamesRealizados;
    //remove duplicata, se houver
    if (exame.tipo == TipoExame.questionario) {
      exameRealizados.removeWhere((exameRealizado) =>
          exame.tipoQuestionario == exameRealizado.tipoQuestionario);
    } else {
      exameRealizados
          .removeWhere((exameRealizado) => exameRealizado.tipo == exame.tipo);
    }

    exameRealizados.add(exame);
    _examesRealizados.value = exameRealizados;
  }

  Exame obterExamePorTipoGeral(TipoExame tipoExame) =>
      _examesRealizados.value.firstWhere(
        (exameRealizado) => exameRealizado.tipo == tipoExame,
        orElse: () => Exame(tipoExame),
      );

  Exame obterExamePorTipoDeQuestionario(TipoQuestionario tipoQuestionario) =>
      _examesRealizados.value.firstWhere(
        (exameRealizado) => exameRealizado.tipoQuestionario == tipoQuestionario,
        orElse: () =>
            Exame(TipoExame.questionario, tipoQuestionario: tipoQuestionario),
      );

  String nomeDoQuestionarioPorTipo(TipoQuestionario tipoQuestionario) {
    const Map nomeDoQuestionarioPorTipo = {
      TipoQuestionario.berlin: "Berlin",
      TipoQuestionario.stopBang: "Stop-Bang",
      TipoQuestionario.sacsBR: "SACS-BR",
      TipoQuestionario.whodas: "WHODAS",
      TipoQuestionario.goal: "GOAL",
      TipoQuestionario.pittsburg: "Pittsburg",
      TipoQuestionario.epworth: "Epworth",
    };

    return nomeDoQuestionarioPorTipo[tipoQuestionario];
  }

  dynamic gerarObjetoQuestionario(TipoQuestionario tipoQuestionario,
      {bool refazer = false}) {
    Map<String, dynamic>? autoPreencher = refazer
        ? null
        : obterExamePorTipoDeQuestionario(tipoQuestionario).respostas;

    switch (tipoQuestionario) {
      case TipoQuestionario.berlin:
        return Berlin(autoPreencher: autoPreencher);
      case TipoQuestionario.sacsBR:
        return SacsBR(autoPreencher: autoPreencher);
      case TipoQuestionario.whodas:
        return WHODAS(autoPreencher: autoPreencher);
      case TipoQuestionario.goal:
        return GOAL(autoPreencher: autoPreencher);
      case TipoQuestionario.epworth:
        return Epworth(autoPreencher: autoPreencher);
      case TipoQuestionario.pittsburg:
        return Pittsburg(autoPreencher: autoPreencher);
      default:
        return StopBang(autoPreencher: autoPreencher);
    }
  }

  dynamic gerarObjetoResultadoDoQuestionario(Exame exame) {
    switch (exame.tipoQuestionario) {
      case TipoQuestionario.berlin:
        return ResultadoBerlin.porMapa(exame.respostas);
      case TipoQuestionario.sacsBR:
        return ResultadoSACSBR.porMapa(exame.respostas);
      case TipoQuestionario.whodas:
        return ResultadoWHODAS.porMapa(exame.respostas);
      case TipoQuestionario.goal:
        return ResultadoGOAL.porMapa(exame.respostas);
      case TipoQuestionario.epworth:
        return ResultadoEpworth.porMapa(exame.respostas);
      case TipoQuestionario.pittsburg:
        return ResultadoPittsburg.porMapa(exame.respostas);
      default:
        return ResultadoStopBang.porMapa(exame.respostas);
    }
  }

  dynamic gerarViewResultadoDoQuestionario(Exame exame) {
    switch (exame.tipoQuestionario) {
      case TipoQuestionario.berlin:
        return TelaResultadoBerlin(
          resultadoBerlin: gerarObjetoResultadoDoQuestionario(exame),
          consultando: true,
        );
      case TipoQuestionario.sacsBR:
        return ResultadoSACSBRView(
          resultadoSACSBR: gerarObjetoResultadoDoQuestionario(exame),
          consultando: true,
        );
      case TipoQuestionario.whodas:
        return ResultadoWHODASView(
          resultado: gerarObjetoResultadoDoQuestionario(exame),
          consultando: true,
        );
      case TipoQuestionario.goal:
        return ResultadoGOALView(
          resultadoGOAL: gerarObjetoResultadoDoQuestionario(exame),
          consultando: true,
        );
      case TipoQuestionario.epworth:
        return ResultadoEpworthView(
          resultado: gerarObjetoResultadoDoQuestionario(exame),
          consultando: true,
        );
      case TipoQuestionario.pittsburg:
        return ResultadoPittsburgView(
          resultado: gerarObjetoResultadoDoQuestionario(exame),
          consultando: true,
        );
      default:
        return TelaResultadoStopBang(
          gerarObjetoResultadoDoQuestionario(exame),
          consultando: true,
        );
    }
  }
}
