import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sono/constants/constants.dart';

class TelaPDF extends StatefulWidget {
  late final File? arquivo;
  late final String? urlPdf;
  late final String nomeArquivo;
  TelaPDF({Key? key, required this.arquivo, String? nome}) : super(key: key) {
    urlPdf = null;
    nomeArquivo = nome ?? basename(arquivo!.path);
  }

  TelaPDF.network({Key? key, required this.urlPdf, String? nome})
      : super(key: key) {
    arquivo = null;
    nomeArquivo = nome ?? urlPdf!;
  }

  @override
  State<TelaPDF> createState() => _TelaPDFState();
}

class _TelaPDFState extends State<TelaPDF> {
  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    try {
      final url = widget.urlPdf!;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();

      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeArquivo),
        backgroundColor: Constantes.corAzulEscuroPrincipal,
        centerTitle: true,
      ),
      body: widget.urlPdf != null
          ? FutureBuilder<File>(
              future: createFileOfPdfUrl(),
              builder: (context, snap) {
                if (snap.hasData) {
                  return PDFView(filePath: snap.data!.path);
                } else if (snap.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao exibir PDF!",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
          : PDFView(
              filePath: widget.arquivo!.path,
            ),
    );
  }
}
