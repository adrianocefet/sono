import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class PDFapi{

  static Future<File> carregarLink(String url)async{
    final resposta = await http.get(Uri.parse(url));
    final bytes = resposta.bodyBytes;

    return _armazenarArquivo(url,bytes);
  }

  static Future<File> _armazenarArquivo(String url, List<int> bytes) async{
    final nomeArquivo = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final arquivo = File('${dir.path}/$nomeArquivo');
    await arquivo.writeAsBytes(bytes, flush:true);
    return arquivo;
  }

}