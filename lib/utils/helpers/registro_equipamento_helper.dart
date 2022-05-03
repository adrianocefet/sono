import 'dart:io';
import 'package:sono/utils/models/pergunta.dart';
import 'package:sono/utils/services/firebase.dart';

class RegistroEquipamentoHelper {
  late List<Pergunta> perguntas;
  Map<String, dynamic> respostas = {};
  File? _fotoDePerfil;
  String? idEquipamentoPreexistente;
  String? idEquipamento;

  RegistroEquipamentoHelper() {
    perguntas = [
      Pergunta(
          "Foto do equipamento (opcional)", TipoPergunta.foto, [], '', 'Foto'),
      Pergunta(
        'Nome do equipamento',
        TipoPergunta.extensoCadastros,
        [],
        '',
        "Nome",
        validador: (value) => value != '' ? null : 'Dado obrigatório.',
      ),
    ];
  }

  Map<String, dynamic> _gerarMapaDeRespostas(String hospital,String tipo) {
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
    respostas['Equipamento'] = tipo;
    respostas['status'] = "Disponível";

    return respostas;
  }

  Future<StatusCadastroEquipamento> registrarEquipamento(
      String hospital,String tipo) async {
    _gerarMapaDeRespostas(hospital,tipo);

    StatusCadastroEquipamento status = await _checarSeEquipamentoJaExiste();
    if (status == StatusCadastroEquipamento.equipamentoNovo) {
      await _adicionarNovoEquipamentoAoBancoDeDados();
    }

    return status;
  }

  Future<StatusCadastroEquipamento> _checarSeEquipamentoJaExiste() async {
    bool jaPossuiPaciente = false;

    idEquipamentoPreexistente =
        await FirebaseService().procurarEquipamentoNoBancoDeDados(respostas);

    if (idEquipamentoPreexistente != null) {
      jaPossuiPaciente = true;
    }

    if (jaPossuiPaciente) {
      return StatusCadastroEquipamento.jaExistenteNoBancoDeDados;
    } else {
      return StatusCadastroEquipamento.equipamentoNovo;
    }
  }

  Future<void> _adicionarNovoEquipamentoAoBancoDeDados() async {
    idEquipamento = await FirebaseService().adicionarEquipamentoAoBancoDeDados(
      respostas,
      fotoDePerfil: _fotoDePerfil,
    );
  }
}

enum StatusCadastroEquipamento {
  equipamentoNovo,
  jaExistenteNoBancoDeDados,
}
