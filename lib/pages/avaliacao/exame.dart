import 'package:sono/utils/bases_exames/base_actigrafia.dart';
import 'package:sono/utils/bases_exames/base_espirometria.dart';
import 'package:sono/utils/bases_exames/base_manuvacuometria.dart';
import 'package:sono/utils/bases_exames/base_polissonografia.dart';
import 'package:sono/utils/bases_exames/base_sintomas.dart';
import 'package:sono/utils/bases_exames/base_sintomas_cpap.dart';
import 'package:sono/utils/models/pergunta.dart';


class Exame {
  Exame(this.tipo, {this.tipoQuestionario, respostas}) {
    this.respostas = respostas ?? {};
  }

  TipoExame tipo;
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
        return 'Listagem de sintomas do uso do CPAP';
      case TipoExame.manuvacuometria:
        return 'Manuvacuometria';
      case TipoExame.questionario:
        return 'Questionários';
      case TipoExame.conclusao:
        return 'Conclusão';
    }
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
    switch (tipo) {
      case TipoExame.polissonografia:
        return basePolissonografia;
      case TipoExame.espirometria:
        return baseEspirometria;
      case TipoExame.actigrafia:
        return baseActigrafia;
      case TipoExame.listagemDeSintomas:
        return baseSintomas;
      case TipoExame.listagemDeSintomasDoUsoDoCPAP:
        return baseSintomasCPAP;
      case TipoExame.manuvacuometria:
        return baseManuvacuometria;
      default:
        return [];
    }
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

enum TipoQuestionario {
  stopBang,
  berlin,
  sacsBR,
  whodas,
  goal,
  epworth,
  pittsburg,
}
