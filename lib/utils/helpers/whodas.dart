import 'dart:math';
import 'package:sono/utils/models/pergunta.dart';

class WHODAS {
  static Map<String, dynamic> resultado = {};
  Map condicoesExtraDom51 = {};
  Map condicoesExtraDom52 = {};
  static num _somaPontuacaoTotal = 0;
  static num _somaPesosMaxTotal = 0;

  get habilitar501 => condicoesExtraDom51.values.toList().contains(true);
  get habilitar502 => condicoesExtraDom52.values.toList().contains(true);

  Future<Map<String, dynamic>> gerarResultadoDoFormulario(
      perguntas, idPaciente) async {
    //Paciente paciente = Paciente({});//await FirebaseService().getPatient(idPaciente);

    print('PONTUAÇÃO TOTAAAAAAAAAAAL $_somaPontuacaoTotal');

    Map<String, dynamic> pontuacaoDominios = {
      'dom_1': WHODAS
          .gerarPontuacaoDominio(
              perguntas.where((element) => element.dominio == "dom_1").toList())
          ?.ceil(),
      'dom_2': WHODAS
          .gerarPontuacaoDominio(
              perguntas.where((element) => element.dominio == "dom_2").toList())
          ?.ceil(),
      'dom_3': WHODAS
          .gerarPontuacaoDominio(
              perguntas.where((element) => element.dominio == "dom_3").toList())
          ?.ceil(),
      'dom_4': WHODAS
          .gerarPontuacaoDominio(
              perguntas.where((element) => element.dominio == "dom_4").toList())
          ?.ceil(),
      'dom_51': WHODAS
          .gerarPontuacaoDominio(perguntas
              .where(
                (element) =>
                    element.dominio == "dom_51" &&
                    element.tipo == TipoPergunta.marcar,
              )
              .toList())
          ?.ceil(),
      'dom_52': WHODAS
          .gerarPontuacaoDominio(perguntas
              .where(
                (element) =>
                    element.dominio == "dom_52" &&
                    element.tipo == TipoPergunta.marcar,
              )
              .toList())
          ?.ceil(),
      'dom_6': WHODAS
          .gerarPontuacaoDominio(
              perguntas.where((element) => element.dominio == "dom_6").toList())
          ?.ceil(),
      'total': _somaPontuacaoTotal < 0
          ? 0
          : (_somaPontuacaoTotal / _somaPesosMaxTotal * 100).ceil(),
    };



    gerarPerguntasMultiplas(perguntas);
    gerarPerguntasEscrever(perguntas);
    resultado.addAll(pontuacaoDominios);

    print(
        'Soma total: $_somaPontuacaoTotal\nSoma Pesos Máximos: $_somaPesosMaxTotal');

    _somaPontuacaoTotal = 0;
    _somaPesosMaxTotal = 0;

    return resultado;
  }

  static gerarPerguntasMultiplas(List<Pergunta> perguntasMultipla) {
    for (var p in perguntasMultipla) {
      if (p.tipo == TipoPergunta.multipla ||
          p.tipo == TipoPergunta.afirmativa) {
        resultado[p.codigo] = p.resposta;
      }
    }
  }

  static List<String> gerarPerguntasEscrever(List<Pergunta> perguntasEscrever) {
    List<String> perguntas = [];
    for (var p in perguntasEscrever) {
      if (p.tipo == TipoPergunta.extenso ||
          p.tipo == TipoPergunta.extensoNumerico) {
        resultado[p.codigo] = p.respostaExtenso;
        perguntas.add(p.respostaExtenso);
        print(p.respostaExtenso);
      }
    }
    return perguntas;
  }

  static num? gerarPontuacaoDominio(List<Pergunta> perguntas) {
    // Mesma função para todos os domínios
    num soma = 0;
    num somaPesosMax = 0;
    num numNaoSeAplica = 0;

    for (var item in perguntas) {
      int index = item.resposta!;
      resultado[item.codigo] = item.resposta;

      num peso = item.pesos[index];
      num pesoMax = (item.pesos).reduce(max);

      soma += peso;
      _somaPontuacaoTotal += peso;

      index != (item.pesos.length - 1)
          ? () {
              somaPesosMax += pesoMax;
            }()
          : numNaoSeAplica++;
    }

    print(soma);
    print('SOMA PESOS: $somaPesosMax');
    _somaPesosMaxTotal += somaPesosMax;
    if (numNaoSeAplica == perguntas.length) print('DOMINIO NÃO SE APLICA');
    return numNaoSeAplica == perguntas.length
        ? -1
        : (soma / somaPesosMax) * 100;
  }

  void limparDadosAnteriores() {
    condicoesExtraDom51.clear();
    condicoesExtraDom52.clear();
  }
}
