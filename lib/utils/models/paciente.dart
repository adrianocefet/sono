import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:sono/utils/models/avaliacao.dart';
import 'package:sono/utils/models/equipamento.dart';

class Paciente {
  late final Map<String, dynamic> infoMap;
  late final String nomeCompleto;
  late final String id;
  late final String idCadastrador;
  late final String numeroProntuario;
  late final String sexo;
  late final String status;
  late final String endereco;
  late final String? email;
  late final String? telefonePrincipal;
  late final String? telefoneSecundario;
  late final DateTime dataDeNascimento;
  late final DateTime dataDeCadastro;
  late final double peso;
  late final double altura;
  late final double imc;
  late final int mallampati;
  late final double circunferenciaDoPescoco;
  late final List<Equipamento>? equipamentos;
  late final List<String>? comorbidades;
  late final List<String> hospitaisVinculados;
  late final bool temAcessoAInternet;
  late final bool sinalTelefonicoEstavel;
  late final bool temWhatsApp;
  late final bool usaSmartphone;
  late final bool trabalhadorDeTurno;
  late final String? nomeDaMae;
  late final String? urlFotoDePerfil;
  late final String? cpf;
  late final String? escolaridade;
  late final String? profissao;
  late final List<Avaliacao>? avaliacoes;
  late final Map<String, Timestamp>? datasUltimosExames;

  Paciente.porDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> document,
      {this.avaliacoes, this.equipamentos}) {
    infoMap = Map<String, dynamic>.from(document.data()!);
    id = document.id;

    _setarAtributos();
  }

  int get idade => DateTime.now().difference(dataDeNascimento).inDays ~/ 365;

  String get dataDeCadastroEmString =>
      DateFormat('dd/MM/yyyy').format(dataDeCadastro);

  String get dataDeNascimentoEmString =>
      DateFormat('dd/MM/yyyy').format(dataDeNascimento);

  String get sinalTelefonicoEstavelEmString =>
      sinalTelefonicoEstavel ? 'Sim' : 'Não';

  String get temAcessoAInternetEmString => temAcessoAInternet ? 'Sim' : 'Não';

  String get trabalhadorDeTurnoEmString => trabalhadorDeTurno ? 'Sim' : 'Não';

  String? get dataDaUltimaAvaliacaoEmString {
    if (datasUltimosExames == null) return null;
    return DateFormat('dd/MM/yyyy  HH:mm').format(dataDaUltimaAvaliacao!);
  }

  DateTime? get dataDaUltimaAvaliacao {
    if (datasUltimosExames == null) return null;
    List<Timestamp> datasUltimosExamesEmOrdemCronologica =
        datasUltimosExames!.values.toList();
    datasUltimosExamesEmOrdemCronologica.sort((a, b) => a.compareTo(b));
    return datasUltimosExamesEmOrdemCronologica.last.toDate();
  }

  bool get ultimaAvaliacaoFoiHoje {
    if (dataDaUltimaAvaliacao == null) return false;
    DateTime now = DateTime.now();
    int comparacao = dataDaUltimaAvaliacao!
        .compareTo(DateTime(now.year, now.month, now.day));

    return comparacao > 0;
  }

  Avaliacao? obterAvaliacaoPorID(String id) {
    if (avaliacoes == null) return null;
    if (avaliacoes!.where((element) => element.id == id).isNotEmpty) {
      return avaliacoes!.firstWhere((element) => element.id == id);
    } else {
      return null;
    }
  }

  String get statusFormatado {
    switch (status) {
      case 'aguardando_cpap':
        return 'Aguardando CPAP';
      case 'em_adaptacao':
        return 'Em adaptação';
      case 'acomp_servico_terciario':
        return 'Acompanhando em serviço terciário';
      case 'acomp_servico_secundario':
        return 'Acompanhando em serviço secundário';
      case 'nao_aderente':
        return 'Não aderente';
      default:
        return 'Em assistência hospitalar';
    }
  }

  String get sexoReduzido {
    switch (sexo) {
      case 'Masculino':
        return 'Masc.';
      default:
        return 'Fem.';
    }
  }

  Paciente(this.infoMap) {
    id = infoMap["id"];
    _setarAtributos();
  }

  DateTime? dataDaUltimaRealizacaoDoExamePorCodigo(String codigo) {
    return datasUltimosExames?[codigo]?.toDate();
  }

  String dataFormatadaDaUltimaRealizacaoDoExamePorCodigo(String codigo) {
    if (dataDaUltimaRealizacaoDoExamePorCodigo(codigo) == null) {
      return "Nunca realizado";
    }

    return DateFormat('dd/MM/yyyy  HH:mm')
        .format(dataDaUltimaRealizacaoDoExamePorCodigo(codigo)!);
  }

  void _setarAtributos() {
    nomeDaMae = infoMap['nome_da_mae'];
    sexo = infoMap['sexo'];
    status = infoMap["status"];
    idCadastrador = infoMap["id_cadastrador"];
    nomeCompleto = infoMap["nome_completo"];
    urlFotoDePerfil = infoMap["url_foto_de_perfil"];
    endereco = infoMap["endereco"];
    cpf = infoMap["cpf"];
    hospitaisVinculados = List<String>.from(infoMap['hospitais_vinculados']);
    numeroProntuario = infoMap["numero_prontuario"];
    temAcessoAInternet = infoMap["acesso_a_internet"];
    sinalTelefonicoEstavel = infoMap["sinal_telefonico_estavel"];
    temWhatsApp = infoMap["tem_whatsapp"];
    comorbidades = List<String>.from(infoMap['comorbidades']);
    dataDeNascimento = DateTime.parse(DateFormat('dd/MM/yyyy')
        .parse(infoMap["data_de_nascimento"])
        .toString());
    dataDeCadastro = (infoMap["data_de_cadastro"] as Timestamp).toDate();
    email = infoMap["email"];
    telefonePrincipal = infoMap["telefone_principal"];
    telefoneSecundario = infoMap["telefone_secundario"];
    escolaridade = infoMap["escolaridade"];
    profissao = infoMap["profissao"];
    altura = infoMap["altura"];
    peso = infoMap["peso"];
    imc = infoMap["imc"];
    circunferenciaDoPescoco = infoMap["circunferencia_do_pescoco"];
    mallampati = infoMap["mallampati"];
    usaSmartphone = infoMap["usa_smartphone"];
    trabalhadorDeTurno = infoMap["trabalhador_de_turno"];
    datasUltimosExames = infoMap['datas_ultimos_exames'] != null
        ? Map<String, Timestamp>.from(infoMap['datas_ultimos_exames'])
        : null;
  }
}
