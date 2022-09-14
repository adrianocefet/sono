import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'exame.dart';

class Avaliacao {
  Avaliacao(
      {required this.examesRealizados,
      required this.id,
      required this.idAvaliador,
      required this.dataDaAvaliacao});

  final String id;
  final String idAvaliador;
  final Timestamp dataDaAvaliacao;
  final List<Exame> examesRealizados;

  String get dataDaAvaliacaoFormatada =>
      DateFormat('dd/MM/yyyy  HH:mm').format(dataDaAvaliacao.toDate());

  String get dataDaAvaliacaoFormatadaReduzida =>
      DateFormat('dd/MM/yy').format(dataDaAvaliacao.toDate());

  bool verificarSeOExameFoiRealizado(Exame exame) =>
      examesRealizados.contains(exame);

  bool verificarSeOQuestionarioFoiRealizado(
          TipoQuestionario tipoQuestionario) =>
      examesRealizados
          .where(
            (exame) =>
                exame.tipo == TipoExame.questionario &&
                exame.tipoQuestionario == tipoQuestionario,
          )
          .isNotEmpty;

  List<TipoQuestionario> listarQuestionariosRealizados() {
    return examesRealizados
        .where(
          (exame) => exame.tipo == TipoExame.questionario,
        )
        .map((e) => e.tipoQuestionario!)
        .toList();
  }

  void salvarExame(Exame exame) {
    if (examesRealizados.contains(exame) == false) {
      examesRealizados.add(exame);
    }
  }

  void removerExame(Exame exame) => examesRealizados.remove(exame);

  void modificarExame(Exame exame) {
    //remove duplicata, se houver
    if (exame.tipo == TipoExame.questionario) {
      examesRealizados.removeWhere((exameRealizado) =>
          exame.tipoQuestionario == exameRealizado.tipoQuestionario);
    } else {
      examesRealizados
          .removeWhere((exameRealizado) => exameRealizado.tipo == exame.tipo);
    }

    examesRealizados.add(exame);
  }

  Exame obterExamePorTipoGeral(TipoExame tipoExame) =>
      examesRealizados.firstWhere(
        (exameRealizado) => exameRealizado.tipo == tipoExame,
        orElse: () => Exame(tipoExame),
      );

  Exame obterExamePorTipoDeQuestionario(TipoQuestionario tipoQuestionario) =>
      examesRealizados.firstWhere(
        (exameRealizado) => exameRealizado.tipoQuestionario == tipoQuestionario,
        orElse: () =>
            Exame(TipoExame.questionario, tipoQuestionario: tipoQuestionario),
      );
}
