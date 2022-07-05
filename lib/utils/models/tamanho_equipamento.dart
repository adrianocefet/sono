class TamanhoItem {

  TamanhoItem({required this.nome,required this.estoque});

  TamanhoItem.fromMap(Map<String, dynamic> map){
    nome = map['nome'] as String;
    estoque = map['estoque'] as int;
  }

  late String nome;
  late int estoque;


  Map<String, dynamic> toMap(){
    return {
      'nome': nome,
      'estoque': estoque,
    };
  }

  @override
  String toString() {
    return 'TamanhoItem{nome: $nome, estoque: $estoque}';
  }
}