import 'dart:io';
import 'package:sono/utils/bases_exames/base_actigrafia.dart';
import 'package:sono/utils/bases_exames/base_espirometria.dart';
import 'package:sono/utils/bases_exames/base_manuvacuometria.dart';
import 'package:sono/utils/bases_exames/base_polissonografia.dart';
import 'package:sono/utils/bases_exames/base_sintomas.dart';
import 'package:sono/utils/bases_exames/base_sintomas_cpap.dart';
import 'package:sono/utils/bases_questionarios/base_berlin.dart';
import 'package:sono/utils/bases_questionarios/base_epworth.dart';
import 'package:sono/utils/bases_questionarios/base_goal.dart';
import 'package:sono/utils/bases_questionarios/base_pittsburg.dart';
import 'package:sono/utils/bases_questionarios/base_sacs_br.dart';
import 'package:sono/utils/bases_questionarios/base_stopbang.dart';
import 'package:sono/utils/bases_questionarios/base_whodas.dart';
import 'package:sono/utils/models/pergunta.dart';

class Exame {
  Exame(this.tipo,
      {this.tipoQuestionario,
      Map<String, dynamic>? respostas,
      this.pdf,
      this.urlPdf}) {
    this.respostas = respostas ?? {};
  }

  TipoExame tipo;
  File? pdf;
  String? urlPdf;
  late Map<String, dynamic> respostas;
  TipoQuestionario? tipoQuestionario;

  late final List<Pergunta> perguntas =
      _base.map((e) => Pergunta.pelaBase(e)).toList();

  void salvarRespostas() {
    for (Pergunta pergunta in perguntas) {
      respostas[pergunta.codigo] = pergunta.respostaPadrao;
    }
  }

  String get nome {
    switch (tipo) {
      case TipoExame.polissonografia:
        return 'Polissonografia';
      case TipoExame.dadosComplementares:
        return 'Dados Complementares';
      case TipoExame.espirometria:
        return 'Espirometria';
      case TipoExame.actigrafia:
        return 'Actigrafia';
      case TipoExame.listagemDeSintomas:
        return 'Listagem de sintomas';
      case TipoExame.listagemDeSintomasDoUsoDoCPAP:
        return 'Listagem de sintomas do uso do PAP';
      case TipoExame.manuvacuometria:
        return 'Manuvacuometria';
      case TipoExame.questionario:
        return 'Questionários';
      case TipoExame.conclusao:
        return 'Conclusão';
    }
  }

  String get codigo {
    const Map codigos = {
      TipoExame.polissonografia: 'polissonografia',
      TipoExame.dadosComplementares: 'dados_complementares',
      TipoExame.espirometria: 'espirometria',
      TipoExame.actigrafia: 'actigrafia',
      TipoExame.listagemDeSintomas: 'listagem_de_sintomas',
      TipoExame.listagemDeSintomasDoUsoDoCPAP: 'listagem_de_sintomas_pap',
      TipoExame.manuvacuometria: 'manuvacuometria',
      TipoExame.questionario: 'questionarios',
      TipoExame.conclusao: 'conclusao',
    };

    const Map codigosQuestionarios = {
      TipoQuestionario.berlin: 'berlin',
      TipoQuestionario.epworth: 'epworth',
      TipoQuestionario.goal: 'goal',
      TipoQuestionario.pittsburg: 'pittsburg',
      TipoQuestionario.sacsBR: 'sacs_br',
      TipoQuestionario.stopBang: 'stop_bang',
      TipoQuestionario.whodas: 'whodas',
    };

    return tipo != TipoExame.questionario
        ? codigos[tipo]
        : codigosQuestionarios[tipoQuestionario];
  }

  String? get nomeDoQuestionario {
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
      default:
        return null;
    }
  }

  List<dynamic> get _base {
    Map bases = {
      TipoExame.polissonografia: basePolissonografia,
      TipoExame.espirometria: baseEspirometria,
      TipoExame.actigrafia: baseActigrafia,
      TipoExame.listagemDeSintomas: baseSintomas,
      TipoExame.listagemDeSintomasDoUsoDoCPAP: baseSintomasCPAP,
      TipoExame.manuvacuometria: baseManuvacuometria,
      TipoQuestionario.berlin: baseBerlin,
      TipoQuestionario.epworth: baseEpworth,
      TipoQuestionario.goal: baseGOAL,
      TipoQuestionario.pittsburg: basePittsburg,
      TipoQuestionario.sacsBR: baseSacsBR,
      TipoQuestionario.stopBang: baseStopBang,
      TipoQuestionario.whodas: baseWHODAS,
    };

    return tipo != TipoExame.questionario
        ? bases[tipo]
        : bases[tipoQuestionario];
  }
}

enum TipoExame {
  polissonografia,
  espirometria,
  manuvacuometria,
  actigrafia,
  listagemDeSintomas,
  listagemDeSintomasDoUsoDoCPAP,
  questionario,
  dadosComplementares,
  conclusao
}

extension ExtensaoTipoExame on TipoExame {
  String get emString {
    const Map<TipoExame, String> nomes = {
      TipoExame.polissonografia: "polissonografia",
      TipoExame.espirometria: "espirometria",
      TipoExame.manuvacuometria: "manuvacuometria",
      TipoExame.actigrafia: "actigrafia",
      TipoExame.listagemDeSintomas: "listagemDeSintomas",
      TipoExame.listagemDeSintomasDoUsoDoCPAP: "listagemDeSintomasDoUsoDoCPAP",
      TipoExame.questionario: "questionario",
      TipoExame.dadosComplementares: "dadosComplementares",
      TipoExame.conclusao: "conclusao",
    };

    return nomes[this]!;
  }

  String get emStringFormatada {
    const Map<TipoExame, String> nomes = {
      TipoExame.polissonografia: "Polissonografia",
      TipoExame.espirometria: "Espirometria",
      TipoExame.manuvacuometria: "Manuvacuometria",
      TipoExame.actigrafia: "Actigrafia",
      TipoExame.listagemDeSintomas: "Listagem De Sintomas",
      TipoExame.listagemDeSintomasDoUsoDoCPAP:
          "Listagem De Sintomas Do Uso Do CPAP",
      TipoExame.questionario: "Questionário",
      TipoExame.dadosComplementares: "Dados Complementares",
      TipoExame.conclusao: "Conclusão",
    };

    return nomes[this]!;
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
