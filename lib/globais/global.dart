import 'package:sono/utils/models/tamanho_equipamento.dart';

List<TamanhoItem> tamanhos = [];

List<Map<String, dynamic>> exportarListaDeTamanhos(){
    return tamanhos.map((tamanho) => tamanho.toMap()).toList();
  }

