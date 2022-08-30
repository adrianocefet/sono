import 'package:sono/utils/bases_exames/base_actigrafia.dart';
import 'package:sono/utils/bases_exames/base_espirometria.dart';
import 'package:sono/utils/bases_exames/base_manuvacuometria.dart';
import 'package:sono/utils/bases_exames/base_polissonografia.dart';
import 'package:sono/utils/bases_exames/base_sintomas.dart';
import 'package:sono/utils/bases_exames/base_sintomas_cpap.dart';
import 'package:sono/utils/models/pergunta.dart';

import 'avaliacao_controller.dart';

class Exame {
  Exame(this.tipo, {this.tipoQuestionario, this.respostas = const {}});

  TipoExame tipo;
  Map<String, dynamic> respostas;
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
