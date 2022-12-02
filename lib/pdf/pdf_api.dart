import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sono/utils/models/equipamento.dart';
import 'package:sono/utils/models/solicitacao.dart';

class PDFapi {
  static Future<File> gerarPdfSolicitacao(
      String url, TipoSolicitacao tipo, Equipamento equipamento) async {
    final resposta = await http.get(Uri.parse(url));
    final bytes = resposta.bodyBytes;

    return _armazenarPdf(url, bytes, tipo, equipamento);
  }

  static Future<File> _armazenarPdf(String url, List<int> bytes,
      TipoSolicitacao tipo, Equipamento equipamento) async {
    final dir = await getApplicationDocumentsDirectory();
    final File arquivo;
    switch (tipo) {
      case TipoSolicitacao.delecao:
      case TipoSolicitacao.concessao:
      case TipoSolicitacao.emprestimo:
        arquivo = File(
            '${dir.path}/${equipamento.tipo.emStringSnakeCase.contains('mascara') || equipamento.tipo.emStringSnakeCase.contains('ap') ? "TermoDeResponsabilidade.pdf" : "ReciboDeItens.pdf"}');
        break;
      case TipoSolicitacao.devolucao:
        arquivo = File('${dir.path}/TermoDeDevolução.pdf');
        break;
    }
    await arquivo.writeAsBytes(bytes, flush: true);
    return arquivo;
  }

  static Future<File?> carregarLink(String url) async {
    final resposta = await http.get(Uri.parse(url));
    if (resposta.statusCode == 200) {
      final bytes = resposta.bodyBytes;

      return _armazenarArquivo(url, bytes);
    } else {
      return null;
    }
  }

  static Future<File> _armazenarArquivo(String url, List<int> bytes) async {
    final nomeArquivo = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final arquivo = File('${dir.path}/$nomeArquivo');
    await arquivo.writeAsBytes(bytes, flush: true);
    return arquivo;
  }
}
