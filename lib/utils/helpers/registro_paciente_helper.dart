import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sono/utils/base_perguntas/base_registro_pacientes.dart';
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

  RegistroPacienteHelper(context) {
    perguntas = baseRegistroPaciente.map(
      (e) {
        return Pergunta(e['enunciado'], e['tipo'], [], '', e['codigo'],
            opcoes: e['opcoes'], validador: e['validador']);
      },
    ).toList();
  }

  Map<String, dynamic> _gerarMapaDeRespostas() {
    print(perguntas);
    for (Pergunta p in perguntas) {
      switch (p.tipo) {
        case TipoPergunta.foto:
          _fotoDePerfil = p.respostaArquivo;
          if (paciente != null) {
            respostas[p.codigo] =
                p.respostaArquivo ?? paciente?.urlFotoDePerfil;
          }
          break;
        case TipoPergunta.dropdown:
          respostas[p.codigo] = p.resposta;
          break;
        default:
          respostas[p.codigo] = p.respostaExtenso;
      }
    }

    return respostas;
  }

  Future<StatusPaciente> registrarPaciente() async {
    _gerarMapaDeRespostas();

    StatusPaciente status = await _checarSePacienteJaExiste();
    if (status == StatusPaciente.pacienteNovo) {
      await _adicionarNovoPacienteAoBancoDeDados();
    }

    return status;
  }

  Future<StatusPaciente> editarPaciente() async {
    _gerarMapaDeRespostas();

    respostas['usuarios'] = paciente!.infoMap['usuarios'];
    respostas['id'] = paciente?.id;

    if (paciente != null && mapEquals(respostas, paciente!.infoMap)) {
      return StatusPaciente.pacienteNaoEditado;
    }

    respostas.remove('foto_perfil');

    StatusPaciente status = await _checarSePacienteJaExiste();
    print('$idPacientePreexistente ${paciente!.id}');
    if ((status == StatusPaciente.jaExistenteNoPerfilDoUsuario &&
            idPacientePreexistente == paciente?.id) ||
        status == StatusPaciente.pacienteNovo) {
      await _atualizarPacienteNoBancoDeDados();

      return StatusPaciente.pacienteEditado;
    }

    return status;
  }

  Future<StatusPaciente> _checarSePacienteJaExiste() async {
    bool jaPossuiPaciente = false;

    idPacientePreexistente =
        await FirebaseService().searchPatientOnDatabase(respostas);

    print(idPacientePreexistente);

    if (idPacientePreexistente != null) {
      jaPossuiPaciente =
          true; //await Usuario().checkIfAlreadyHasPatient(idPacientePreexistente);
    }

    if (jaPossuiPaciente) {
      return StatusPaciente.jaExistenteNoPerfilDoUsuario;
    } else if (idPacientePreexistente != null) {
      return StatusPaciente.jaExistenteNoBancoDeDados;
    } else {
      return StatusPaciente.pacienteNovo;
    }
  }

  Future<void> _atualizarPacienteNoBancoDeDados() async {
    await _registrarFotoDePerfil();

    idPaciente =
        await FirebaseService().updatePatientData(respostas, paciente!.id!);
  }

  Future<void> _adicionarNovoPacienteAoBancoDeDados() async {
    await _registrarFotoDePerfil();

    idPaciente = await FirebaseService().uploadPatientData(respostas);
  }

  Future<void> _registrarFotoDePerfil() async {
    if (_fotoDePerfil != null) {
      await FirebaseService().uploadImageToFirebaseStorage(
        imageFile: _fotoDePerfil!,
        idPaciente: idPaciente!,
      );
    }
  }
}

enum StatusPaciente {
  pacienteEditado,
  pacienteNaoEditado,
  pacienteNovo,
  jaExistenteNoPerfilDoUsuario,
  jaExistenteNoBancoDeDados,
}
