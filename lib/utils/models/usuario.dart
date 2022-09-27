import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/equipamento.dart';

class Usuario extends Model {
  Usuario();
  Usuario.porDocumentSnapshot(DocumentSnapshot<Map> document) {
    Map dados = document.data()!;
    id = document.id;
    instituicao = dados['instituicao'];
    nomeCompleto = dados['nome_completo'];
    urlFotoDePerfil = dados['url_foto_de_perfil'];
    cpf = dados['cpf'];
  }

  Instituicao _instituicaoPorString(String instituicao) {
    const Map<String, Instituicao> instituicoes = {
      'HGCC': Instituicao.hgcc,
      'HGF': Instituicao.hgf,
      'HUWC': Instituicao.huwc,
      "Hospital De Messejana": Instituicao.hospitalDeMessejana,
    };

    return instituicoes[instituicao]!;
  }

  String nomeCompleto = 'Dra.Camila';
  DateTime dataDeCadastro = DateTime.now();
  String id = 'IDGENERICO';
  String cpf = 'CPFGENERICO';
  String urlFotoDePerfil = 'URLFOTODEPERFIL';
  Instituicao instituicao = Instituicao.huwc;
  String semimagem =
      'https://toppng.com/uploads/preview/app-icon-set-login-icon-comments-avatar-icon-11553436380yill0nchdm.png';
  TipoEquipamento tipo = TipoEquipamento.nasal;
  StatusDoEquipamento status = StatusDoEquipamento.disponivel;
}

enum Instituicao {
  huwc,
  hgf,
  hgcc,
  hospitalDeMessejana,
}

extension ExtensaoInstituicao on Instituicao {
  String get emString {
    const Map<Instituicao, String> strings = {
      Instituicao.hgcc: 'HGCC',
      Instituicao.hgf: 'HGF',
      Instituicao.huwc: 'HUWC',
      Instituicao.hospitalDeMessejana: "Hospital De Messejana"
    };

    return strings[this]!;
  }
}
