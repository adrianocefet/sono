import 'dart:io';
import 'package:sono/utils/models/paciente/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/utils/services/firebase.dart';

class RegistroPacienteHelper {
  late List<Pergunta> perguntas;
  Map<String, dynamic> respostas = {};
  File? _fotoDePerfil;
  String? idPacientePreexistente;
  String? idPaciente;
  Paciente? paciente;

  RegistroPacienteHelper() {
    perguntas = [
      Pergunta(
          "Foto do paciente (opcional)", TipoPergunta.foto, [], '', 'Foto'),
      Pergunta('Nome do paciente', TipoPergunta.extenso, [], '', "Nome",
          validador: (value) => value != '' ? null : 'Dado obrigatório.'),
    ];
  }

  Map<String, dynamic> _gerarMapaDeRespostas(String hospital) {
    for (Pergunta p in perguntas) {
      switch (p.tipo) {
        case TipoPergunta.foto:
          _fotoDePerfil = p.respostaArquivo;
          break;
        default:
          respostas[p.codigo] = p.respostaExtenso;
      }
    }

    respostas['Hospital'] = hospital;

    return respostas;
  }

  Future<StatusPaciente> registrarPaciente(String hospital) async {
    _gerarMapaDeRespostas(hospital);

    StatusPaciente status = await _checarSePacienteJaExiste();
    if (status == StatusPaciente.pacienteNovo) {
      await _adicionarNovoPacienteAoBancoDeDados();
    }

    return status;
  }

  Future<StatusPaciente> _checarSePacienteJaExiste() async {
    bool jaPossuiPaciente = false;

    idPacientePreexistente =
        await FirebaseService().searchPatientOnDatabase(respostas);

    if (idPacientePreexistente != null) {
      jaPossuiPaciente = true;
    }

    if (jaPossuiPaciente) {
      return StatusPaciente.jaExistenteNoBancoDeDados;
    } else {
      return StatusPaciente.pacienteNovo;
    }
  }

  Future<void> _adicionarNovoPacienteAoBancoDeDados() async {
    idPaciente = await FirebaseService()
        .uploadDadosDoPaciente(respostas, fotoDePerfil: _fotoDePerfil);
  }
}

enum StatusPaciente {
  pacienteNovo,
  jaExistenteNoBancoDeDados,
}
