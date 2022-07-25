import 'package:cloud_firestore/cloud_firestore.dart';

class Paciente {
  late final Map<String, dynamic> infoMap;
  late final String nomeCompleto;
  late final String id;
  late final String idCadastrador;
  late final String numeroProntuario;
  late final String sexo;
  late final String status;
  late final String endereco;
  late final String telefone;
  late final DateTime dataDeNascimento;
  late final DateTime dataDeCadastro;
  late final double peso;
  late final int altura;
  late final double imc;
  late final int mallampati;
  late final double circunferenciaDoPescoco;
  late final List<String>? equipamentosEmprestados;
  late final List<String>? comorbidades;
  late final List<String> hospitais;
  late final bool temAcessoAInternet;
  late final bool sinalEstavelInternet;
  late final bool temWhatsApp;
  late final bool usaSmartphone;
  late final bool trabalhadorDeTurno;
  late final String? nomeDaMae;
  late final String? urlFotoDePerfil;
  late final String? cpf;
  late final String? escolaridade;
  late final String? profissao;

  Paciente(this.infoMap) {
    id = infoMap["id"];
    _setarAtributos();
  }

  Paciente.porDocumentSnapshot(DocumentSnapshot document) {
    infoMap = document.data() as Map<String, dynamic>;
    id = document.id;
    _setarAtributos();
  }

  void _setarAtributos() {
    idCadastrador = infoMap["id_cadastrador"];
    nomeCompleto = infoMap["nome_completo"];
    urlFotoDePerfil = infoMap["url_foto_perfil"];
    endereco = infoMap["endereco"];
    cpf = infoMap["cpf"];
    hospitais = infoMap["hospitais"];
    numeroProntuario = infoMap["numero_prontuario"];
    temAcessoAInternet = infoMap["tem_acesso_a_internet"];
    sinalEstavelInternet = infoMap["sinal_estavel_internet"];
    temWhatsApp = infoMap["tem_whatsapp"];
    comorbidades = infoMap['comorbidades'];
    dataDeNascimento = (infoMap["data_de_nascimento"] as Timestamp).toDate();
    dataDeCadastro = (infoMap["data_de_cadastro"] as Timestamp).toDate();
    telefone = infoMap["telefone"];
    escolaridade = infoMap["escolaridade"];
    profissao = infoMap["profissao"];
    altura = int.parse(infoMap["altura"]);
    peso = double.parse(infoMap["peso"]);
    imc = double.parse(infoMap["imc"]);
    circunferenciaDoPescoco =
        double.parse(infoMap["circunferencia_do_pescoco"]);
    mallampati = infoMap["mallampati"];
    usaSmartphone = infoMap["usa_smartphone"];
    trabalhadorDeTurno = infoMap["trabalhador_de_turno"];
  }
}
