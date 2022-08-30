import 'package:flutter/cupertino.dart';
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
import 'exame.dart';

class ControllerAvaliacao {
  final Paciente paciente;
  ControllerAvaliacao(this.paciente);

  final GlobalKey<FormState> keyExamesDescritivos = GlobalKey<FormState>();
  final ValueNotifier<List<Exame>> _examesRealizados =
      ValueNotifier<List<Exame>>(List.empty(growable: true));

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

  void salvarExame(Exame exame) => _examesRealizados.value += [exame];

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

  String nomeDoQuestionario(TipoQuestionario tipoQuestionario) {
    switch (tipoQuestionario) {
      case TipoQuestionario.berlin:
        return "Berlin";
      case TipoQuestionario.stopBang:
        return "Stop-Bang";
      case TipoQuestionario.sacsBR:
        return "SACS-BR";
      case TipoQuestionario.whodas:
        return "WHODAS";
      case TipoQuestionario.goal:
        return "GOAL";
      case TipoQuestionario.pittsburg:
        return "Pittsburg";
      case TipoQuestionario.epworth:
        return "Epworth";
    }
  }

  dynamic gerarObjetoQuestionario(TipoQuestionario tipoQuestionario) {
    switch (tipoQuestionario) {
      case TipoQuestionario.berlin:
        return Berlin(
          paciente: paciente,
        );
      case TipoQuestionario.sacsBR:
        return SacsBR(
          paciente: paciente,
        );
      case TipoQuestionario.whodas:
        return WHODAS(
          paciente: paciente,
        );
      case TipoQuestionario.goal:
        return GOAL(
          paciente: paciente,
        );
      case TipoQuestionario.epworth:
        return Epworth(
          paciente: paciente,
        );
      case TipoQuestionario.pittsburg:
        return Pittsburg(
          paciente: paciente,
        );
      default:
        return StopBang(
          paciente: paciente,
        );
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
          paciente: paciente,
          resultadoBerlin: gerarObjetoResultadoDoQuestionario(exame),
        );
      case TipoQuestionario.sacsBR:
        return ResultadoSACSBRView(
          paciente: paciente,
          resultadoSACSBR: gerarObjetoResultadoDoQuestionario(exame),
        );
      case TipoQuestionario.whodas:
        return ResultadoWHODASView(
          paciente: paciente,
          resultado: gerarObjetoResultadoDoQuestionario(exame),
        );
      case TipoQuestionario.goal:
        return ResultadoGOALView(
          paciente: paciente,
          resultadoGOAL: gerarObjetoResultadoDoQuestionario(exame),
        );
      case TipoQuestionario.epworth:
        return ResultadoEpworthView(
          paciente: paciente,
          resultado: gerarObjetoResultadoDoQuestionario(exame),
        );
      case TipoQuestionario.pittsburg:
        return ResultadoPittsburgView(
          paciente: paciente,
          resultado: gerarObjetoResultadoDoQuestionario(exame),
        );
      default:
        return TelaResultadoStopBang(
          gerarObjetoResultadoDoQuestionario(exame),
          paciente: paciente,
        );
    }
  }
}

enum TipoQuestionario {
  stopBang,
  berlin,
  sacsBR,
  whodas,
  goal,
  epworth,
  pittsburg,
}
