import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sono/pages/questionarios/whodas/questionario/widgets/enunciado_dominio.dart.dart';
import 'package:sono/pages/questionarios/whodas/questionario/widgets/resposta_ativ_trab.dart';
import 'package:sono/utils/bases_questionarios/base_whodas.dart';
import 'package:sono/utils/models/pergunta.dart';
import '../../../../utils/helpers/resposta_widget.dart';
import '../../../../utils/models/paciente.dart';
import 'widgets/enunciado_secao.dart';

class WHODASController {
  Paciente paciente;

  WHODASController(this.paciente);

  final formKey = GlobalKey<FormState>();
  final pageViewController = PageController();
  final List<Pergunta> _perguntas =
      baseWHODAS.map((e) => Pergunta.pelaBase(e)).toList();

  List<Widget> listaDePaginas = [];
  Map condicoesExtraDom51 = {};
  Map condicoesExtraDom52 = {};
  Map<String, bool> estadosDosDominios = {
    "dom_1": true,
    "dom_2": true,
    "dom_3": true,
    "dom_4": true,
    "dom_51": true,
    "dom_52": true,
    "dom_6": true,
  };

  List<Pergunta> get listaDePerguntas => _perguntas;
  bool get habilitar501 => condicoesExtraDom51.values.toList().contains(true);
  bool get habilitar502 => condicoesExtraDom52.values.toList().contains(true);

  Future<void> passarParaProximaPagina() async {
    await pageViewController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeIn,
    );
  }

  Future<void> passarParaPaginaAnterior() async {
    await pageViewController.previousPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeIn,
    );
  }

  List<Widget> gerarListaDePaginas() {
    listaDePaginas = [];
    String dominioAtual = "";

    for (Pergunta pergunta in listaDePerguntas) {
      if (dominioAtual != pergunta.dominio) {
        dominioAtual = pergunta.dominio;
        if (dominioAtual == "dom_1") {
          listaDePaginas.addAll(
            [
              const EnunSecao(indiceSecao: 3),
              EnunDominio(
                dominio: pergunta.dominio,
                controller: this,
              ),
            ],
          );
        } else if(dominioAtual != ""){
          listaDePaginas.add(
            EnunDominio(
              dominio: pergunta.dominio,
              controller: this,
            ),
          );
        }
      }

      listaDePaginas.add(
        pergunta.codigo == "A5"
            ? RespostaAtividadeTrabalho(
                pergunta: pergunta,
                passarPagina: passarParaProximaPagina,
                formKey: formKey,
              )
            : RespostaWidget(
                pergunta,
                notifyParent: passarParaProximaPagina,
                autoPreencher: _autoPreencher(pergunta, paciente),
              ),
      );
    }

    listaDePaginas.insert(
      listaDePaginas.indexWhere((resposta) =>
              resposta.runtimeType == RespostaWidget &&
              (resposta as RespostaWidget).pergunta.codigo == "F1") -
          1,
      const EnunSecao(indiceSecao: 0),
    );

    listaDePaginas.insert(
      listaDePaginas.indexWhere((resposta) =>
          resposta.runtimeType == RespostaWidget &&
          (resposta as RespostaWidget).pergunta.codigo == "A1"),
      const EnunSecao(indiceSecao: 1),
    );

    listaDePaginas.insertAll(
      listaDePaginas.indexWhere(
              (resposta) => resposta.runtimeType == RespostaAtividadeTrabalho) +
          1,
      [
        const EnunSecao(indiceSecao: 2),
      ],
    );

    return listaDePaginas;
  }

  dynamic _autoPreencher(Pergunta pergunta, Paciente paciente) {
    switch (pergunta.codigo) {
      case "nome":
        return paciente.nome;
      case "F4":
        return DateFormat("dd/MM/yyyy").format(DateTime.now());
      case "A2":
      case "A3":
        return "30";
      default:
        return null;
    }
  }

  void mudarEstadoDominio(bool remover, String codigoDominio) {
    if (remover) {
      for (Pergunta pergunta in listaDePerguntas) {
        if (pergunta.dominio == codigoDominio) {
          pergunta.resposta =
              pergunta.opcoes == null ? 0 : pergunta.opcoes!.length - 1;
          pergunta.respostaExtenso = pergunta.opcoes!.last;
        }
      }

      listaDePaginas.removeWhere(
        (pagina) =>
            pagina.runtimeType == RespostaWidget &&
            (pagina as RespostaWidget).pergunta.dominio == codigoDominio,
      );

      estadosDosDominios[codigoDominio] = false;
    } else {
      for (Pergunta pergunta in listaDePerguntas) {
        if (pergunta.dominio == codigoDominio) {
          pergunta.resposta = null;
          pergunta.respostaExtenso = null;
        }
      }

      listaDePaginas.insertAll(
        listaDePaginas.indexWhere((pagina) =>
            pagina.runtimeType == EnunDominio &&
            (pagina as EnunDominio).dominio == codigoDominio),
        [
          for (Pergunta pergunta in listaDePerguntas.where(
            (pergunta) => pergunta.dominio == codigoDominio,
          ))
            RespostaWidget(
              pergunta,
              notifyParent: passarParaProximaPagina,
              autoPreencher: _autoPreencher(pergunta, paciente),
            ),
        ],
      );

      estadosDosDominios[codigoDominio] = true;
    }
  }

  ResultadoWHODAS? validarFormulario(GlobalKey<FormState> formKey) {
    bool respostasEstaoValidas = formKey.currentState!.validate();

    if (respostasEstaoValidas) formKey.currentState!.save();

    bool respostasNaoEstaoNulas = !_perguntas.any(
      (element) {
        return element.tipo == TipoPergunta.extensoNumerico
            ? element.respostaExtenso == null
            : element.resposta == null;
      },
    );

    if (respostasNaoEstaoNulas && respostasEstaoValidas) {
      return ResultadoWHODAS(_perguntas);
    }

    return null;
  }
}

class ResultadoWHODAS {
  static Map<String, dynamic> resultado = {};
  static num _somaPontuacaoTotal = 0;
  static num _somaPesosMaxTotal = 0;

  ResultadoWHODAS(List<Pergunta> perguntas) {
    _gerarResultadoDoFormulario(perguntas);
  }

  Map<String, dynamic> _gerarResultadoDoFormulario(perguntas) {
    Map<String, dynamic> pontuacaoDominios = {
      'dom_1': gerarPontuacaoDominio(
              perguntas.where((element) => element.dominio == "dom_1").toList())
          ?.ceil(),
      'dom_2': gerarPontuacaoDominio(
              perguntas.where((element) => element.dominio == "dom_2").toList())
          ?.ceil(),
      'dom_3': gerarPontuacaoDominio(
              perguntas.where((element) => element.dominio == "dom_3").toList())
          ?.ceil(),
      'dom_4': gerarPontuacaoDominio(
              perguntas.where((element) => element.dominio == "dom_4").toList())
          ?.ceil(),
      'dom_51': gerarPontuacaoDominio(perguntas
              .where(
                (element) =>
                    element.dominio == "dom_51" &&
                    element.tipo == TipoPergunta.marcar,
              )
              .toList())
          ?.ceil(),
      'dom_52': gerarPontuacaoDominio(perguntas
              .where(
                (element) =>
                    element.dominio == "dom_52" &&
                    element.tipo == TipoPergunta.marcar,
              )
              .toList())
          ?.ceil(),
      'dom_6': gerarPontuacaoDominio(
              perguntas.where((element) => element.dominio == "dom_6").toList())
          ?.ceil(),
      'total': _somaPontuacaoTotal < 0
          ? 0
          : (_somaPontuacaoTotal / _somaPesosMaxTotal * 100).ceil(),
    };

    _gerarPontuacaoPerguntasMultiplas(perguntas);
    _gerarPontuacaoPerguntasEscrever(perguntas);
    resultado.addAll(pontuacaoDominios);

    _somaPontuacaoTotal = 0;
    _somaPesosMaxTotal = 0;

    return resultado;
  }

  static _gerarPontuacaoPerguntasMultiplas(List<Pergunta> perguntasMultipla) {
    for (var p in perguntasMultipla) {
      if (p.tipo == TipoPergunta.multipla ||
          p.tipo == TipoPergunta.afirmativa) {
        resultado[p.codigo] = p.resposta;
      }
    }
  }

  static List<String> _gerarPontuacaoPerguntasEscrever(
      List<Pergunta> perguntasEscrever) {
    List<String> perguntas = [];
    for (var p in perguntasEscrever) {
      if (p.tipo == TipoPergunta.extenso ||
          p.tipo == TipoPergunta.extensoNumerico) {
        resultado[p.codigo] = p.respostaExtenso;
        perguntas.add(p.respostaExtenso!);
      }
    }
    return perguntas;
  }

  static num? gerarPontuacaoDominio(List<Pergunta> perguntas) {
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

    _somaPesosMaxTotal += somaPesosMax;
    return numNaoSeAplica == perguntas.length
        ? -1
        : (soma / somaPesosMax) * 100;
  }
}
