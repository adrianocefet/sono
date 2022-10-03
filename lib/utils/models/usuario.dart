import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class Usuario extends Model {
  String nomeCompleto = 'Dra.Camila';
  DateTime dataDeCadastro = DateTime.now();
  String id = 'IDGENERICO';
  String cpf = 'CPFGENERICO';
  String? urlFotoDePerfil = 'URLFOTODEPERFIL';
  Instituicao instituicao = Instituicao.huwc;
  PerfilUsuario perfil = PerfilUsuario.mestre;
  String senha = 'SENHAGENERICA';
  String profissao = 'Médico';
  Map<String, dynamic> infoMap = {};

  Usuario();

  Usuario.porDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    Map<String, dynamic> dados = document.data()!;
    infoMap = dados;
    id = document.id;
    instituicao = _instituicaoPorString(dados['instituicao']);
    perfil = _perfilPorString(dados['perfil']);
    nomeCompleto = dados['nome_completo'];
    urlFotoDePerfil = dados['url_foto_de_perfil'];
    cpf = dados['cpf'];
    senha = dados['senha'];
    profissao = dados['profissao'] ?? 'Médico';
    dataDeCadastro = dados['data_de_cadastro'].toDate();
  }

  String get dataDeCadastroFormatada {
    return DateFormat('dd/MM/yyyy').format(dataDeCadastro);
  }

  Instituicao _instituicaoPorString(String instituicaoEmString) {
    const Map<String, Instituicao> instituicoes = {
      'HGCC': Instituicao.hgcc,
      'HGF': Instituicao.hgf,
      'HUWC': Instituicao.huwc,
      "HM": Instituicao.hm,
    };

    return instituicoes[instituicaoEmString]!;
  }

  PerfilUsuario _perfilPorString(String perfilEmString) {
    const Map<String, PerfilUsuario> perfis = {
      "Clínico": PerfilUsuario.clinico,
      "Dispensação": PerfilUsuario.dispensacao,
      "Gestão": PerfilUsuario.gestao,
      "Vigilância": PerfilUsuario.vigilancia,
    };

    return perfis[perfilEmString]!;
  }
}

enum Instituicao {
  huwc,
  hgf,
  hgcc,
  hm,
}

extension ExtensaoInstituicao on Instituicao {
  String get emString {
    const Map<Instituicao, String> strings = {
      Instituicao.hgcc: 'HGCC',
      Instituicao.hgf: 'HGF',
      Instituicao.huwc: 'HUWC',
      Instituicao.hm: "HM"
    };

    return strings[this]!;
  }
}

enum PerfilUsuario {
  mestre,
  clinico,
  dispensacao,
  gestao,
  vigilancia,
}

extension ExtensaoPerfilUsuario on PerfilUsuario {
  String get emString {
    const Map<PerfilUsuario, String> strings = {
      PerfilUsuario.mestre: "Mestre",
      PerfilUsuario.clinico: "Clínico",
      PerfilUsuario.dispensacao: "Dispensação",
      PerfilUsuario.gestao: "Gestão",
      PerfilUsuario.vigilancia: "Vigilância",
    };

    return strings[this]!;
  }
}
