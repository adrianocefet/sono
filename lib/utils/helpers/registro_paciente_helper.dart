import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sono/utils/bases_cadastros/base_cadastro_paciente.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/utils/services/firebase.dart';

class RegistroPacienteHelper {
  final List<Pergunta> perguntas =
      baseCadastroPaciente.map((e) => Pergunta.pelaBase(e)).toList();
  Map<String, dynamic> respostas = {};
  File? _fotoDePerfil;
  String? idPacientePreexistente;
  String? idPaciente;
  Paciente? paciente;

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

    respostas['hospital'] = hospital;
    respostas["imc"] = int.parse(respostas["altura"]) /
        (double.parse(respostas["peso"]) * double.parse(respostas["peso"]));
    respostas['data_de_cadastro'] = FieldValue.serverTimestamp();

    return respostas;
  }

  Future<StatusPaciente> registrarPaciente(String hospital) async {
    print(_gerarMapaDeRespostas(hospital));

    StatusPaciente status = await _checarSePacienteJaExiste();
    // if (status == StatusPaciente.pacienteNovo) {
    //   idPaciente = await _adicionarNovoPacienteAoBancoDeDados();
    // }

    return status;
  }

  Future<StatusPaciente> _checarSePacienteJaExiste() async {
    bool jaPossuiPaciente = false;

    idPacientePreexistente =
        await FirebaseService().procurarPacienteNoBancoDeDados(respostas);

    if (idPacientePreexistente != null) {
      jaPossuiPaciente = true;
    }

    if (jaPossuiPaciente) {
      return StatusPaciente.jaExistenteNoBancoDeDados;
    } else {
      return StatusPaciente.pacienteNovo;
    }
  }

  Future<String> _adicionarNovoPacienteAoBancoDeDados() async {
    return await FirebaseService()
        .uploadDadosDoPaciente(respostas, fotoDePerfil: _fotoDePerfil);
  }
}

enum StatusPaciente {
  pacienteNovo,
  jaExistenteNoBancoDeDados,
}
