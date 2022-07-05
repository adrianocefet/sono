import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:sono/constants/constants.dart';

class TelaPDF extends StatefulWidget {
  final File arquivo;
  const TelaPDF({Key? key,required this.arquivo}) : super(key: key);

  @override
  State<TelaPDF> createState() => _TelaPDFState();
}

class _TelaPDFState extends State<TelaPDF> {
  @override
  Widget build(BuildContext context) {
    final nomeArquivo = basename(widget.arquivo.path);
    return Scaffold(
      appBar: AppBar(
        title: Text(nomeArquivo),
        backgroundColor: Constantes.corAzulEscuroPrincipal,
      ),
      body: PDFView(
        filePath: widget.arquivo.path,
      ),
    );
  }
}