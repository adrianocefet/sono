class UsuarioReduzido {
  final Map<String, dynamic> infoMap;
  late final String id;
  late final String nomeCompleto;
  late final int profissao;
  late final String telefone;
  late final String email;

  UsuarioReduzido(this.infoMap) {
    this.id = infoMap['id'];
    this.nomeCompleto = infoMap['nome_completo'];
    this.profissao = infoMap['profissao'];
    this.telefone = infoMap['telefone'];
    this.email = infoMap['email'];
  }
}
