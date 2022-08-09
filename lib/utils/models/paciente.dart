import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Paciente {
  late final Map<String, dynamic> infoMap;
  late final String nomeCompleto;
  late final String id;
  late final String idCadastrador;
  late final String numeroProntuario;
  late final String sexo;
  late final String status;
  late final String endereco;
  late final String? telefonePrincipal;
  late final String? telefoneSecundario;
  late final DateTime dataDeNascimento;
  late final DateTime dataDeCadastro;
  late final double peso;
  late final double altura;
  late final double imc;
  late final int mallampati;
  late final double circunferenciaDoPescoco;
  late final List<String>? equipamentosEmprestados;
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

  int get idade {
    return DateTime.now().difference(dataDeNascimento).inDays ~/ 365;
  }

  String get dataDeCadastroEmString {
    return DateFormat('dd/MM/yyyy').format(dataDeCadastro);
  }

  String get dataDeNascimentoEmString {
    return DateFormat('dd/MM/yyyy').format(dataDeNascimento);
  }

  String get sinalTelefonicoEstavelEmString {
    return sinalTelefonicoEstavel ? 'Sim' : 'Não';
  }

  String get temAcessoAInternetEmString {
    return temAcessoAInternet ? 'Sim' : 'Não';
  }

  String get trabalhadorDeTurnoEmString {
    return trabalhadorDeTurno ? 'Sim' : 'Não';
  }

  String? get dataDaProximaAvaliacaoEmString {
    return '01/11/2022';
  }

  bool get proximaAvaliacaoEHoje {
    return false;
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

  Paciente.porDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    infoMap = document.data() as Map<String, dynamic>;
    id = document.id;
    _setarAtributos();
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
  }
}
