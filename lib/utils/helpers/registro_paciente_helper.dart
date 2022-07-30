import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sono/utils/bases_cadastros/base_cadastro_paciente.dart';
import 'package:sono/utils/models/paciente.dart';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/utils/models/user_model.dart';
import 'package:sono/utils/services/firebase.dart';

class RegistroPacienteHelper {
  final List<Pergunta> perguntas =
      baseCadastroPaciente.map((e) => Pergunta.pelaBase(e)).toList();
  UserModel usuario = UserModel();
  Map<String, dynamic> respostas = {};
  File? _fotoDePerfil;
  String? idPacientePreexistente;
  String? idPaciente;
  Paciente? paciente;

  Map<String, dynamic> _gerarMapaDeRespostas() {
    for (Pergunta p in perguntas) {
      switch (p.tipo) {
        case TipoPergunta.foto:
          _fotoDePerfil = p.respostaArquivo;
          break;
        case TipoPergunta.comorbidades:
          respostas[p.codigo] = p.respostaLista;
          break;
        case TipoPergunta.afirmativaCadastros:
          respostas[p.codigo] = p.respostaBooleana;
          break;
        case TipoPergunta.extensoNumericoCadastros:
          respostas[p.codigo] = double.parse(p.respostaExtenso!);
          break;
        default:
          respostas[p.codigo] = p.respostaExtenso;
      }
    }

    respostas['status'] = 'aguardando_cpap';
    respostas['id_cadastrador'] = usuario.id;
    respostas['hospitais_vinculados'] = [usuario.hospital];
    respostas["imc"] = _gerarIMC(respostas['altura'], respostas['peso']);
    respostas['data_de_cadastro'] = FieldValue.serverTimestamp();

    return respostas;
  }

  double _gerarIMC(String alturaEmString, String pesoEmString) {
    double altura = double.parse(alturaEmString.trim().replaceAll(",", "."));
    double peso = double.parse(pesoEmString.trim().replaceAll(",", "."));

    return peso / (altura * altura);
  }

  Future<StatusPaciente> registrarPaciente() async {
    print(_gerarMapaDeRespostas());

    StatusPaciente status = await _checarSePacienteJaExiste();
    if (status == StatusPaciente.pacienteNovo) {
      idPaciente = await _adicionarNovoPacienteAoBancoDeDados();
    }

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
