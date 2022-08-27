import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sono/utils/models/equipamento.dart';
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
          "Foto do equipamento", TipoPergunta.foto, [], '', 'url_foto'),
      Pergunta(
        'Nome do equipamento*',
        TipoPergunta.extensoCadastros,
        [],
        '',
        "nome",
        validador: (value) => value != '' ? null : 'Dado obrigatório.',
      ),
      Pergunta(
        'Fabricante*',
        TipoPergunta.extensoCadastros,
        [],
        '',
        "fabricante",
        validador: (value) => value != '' ? null : 'Dado obrigatório.',
      ),
      Pergunta(
        'Descrição*',
        TipoPergunta.multiLinhasCadastros,
        [],
        '',
        "descrição",
        validador: (value) => value != '' ? null : 'Dado obrigatório.',
      ),
      Pergunta(
        'PDF Manual',
        TipoPergunta.extensoCadastros,
        [],
        '',
        "manual",
        textoAjuda: 'Exemplo: https://www.cpaps.com.br/media/mconnect_uploadfiles/m/a/manual_cpap_airsense_resmed.pdf'
      ),
      Pergunta(
        'Vídeo instrucional',
        TipoPergunta.extensoCadastros,
        [],
        '',
        "video_instrucional",
        textoAjuda: 'Exemplo: https://youtu.be/8SnRSVeJeAY'
      ),
      Pergunta(
        'Informações técnicas e conectividade*',
        TipoPergunta.multiLinhasCadastros,
        [],
        '',
        "informacoes_tecnicas",
        textoAjuda: 'Conectividade e telemonitoramento, modos ajustáveis, dispositivos de conforto e acessórios.',
        validador: (value) => value != '' ? null : 'Dado obrigatório.',
      ),
      Pergunta(
        'Higienização e informações ao paciente',
        TipoPergunta.multiLinhasCadastros,
        [],
        '',
        "higiene_e_cuidados_paciente",
        textoAjuda: 'Higiene, cuidados pertinentes a serem apresentados ao paciente, informações sobre os filtros, fonte de energia.'
      ),
      Pergunta(
        'Observações',
        TipoPergunta.multiLinhasCadastros,
        [],
        '',
        "observacao",
        textoAjuda: 'Informações adicionais.'
      ),
      Pergunta(
        'Tamanho*',
        TipoPergunta.extensoCadastros,
        [],
        '',
        "tamanho",
        validador: (value) => value != '' ? null : 'Dado obrigatório.',
      ),
    ];
  }

  Map<String, dynamic> _gerarMapaDeRespostas(String hospital,String tipo,{String status="disponível"}) {
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
    respostas['tipo'] = tipo;
    respostas['status'] = status;

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
    bool jaPossuiEquipamento= false;

    idEquipamentoPreexistente =
        await FirebaseService().procurarEquipamentoNoBancoDeDados(respostas);

    if (idEquipamentoPreexistente != null) {
      jaPossuiEquipamento = true;
    }

    if (jaPossuiEquipamento) {
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

  Future<void> editarEquipamento(Equipamento equipamento) async {
    _gerarMapaDeRespostas(equipamento.hospital,equipamento.tipo.emStringSnakeCase,status: equipamento.status.emString);

    await _editarInformacoesDoEquipamentoNoBancoDeDados(equipamento.id);

  }

  Future<void> _editarInformacoesDoEquipamentoNoBancoDeDados(String id,) async {
    await FirebaseService().updateDadosDoEquipamento(
      respostas,
      id,
      fotoDePerfil: _fotoDePerfil,
    );
  }
}

enum StatusCadastroEquipamento {
  equipamentoNovo,
  jaExistenteNoBancoDeDados,
}
