import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future<File?> mostrarDialogAnexarArquivoAoExame(
    BuildContext context, String codigoExame) async {
  return await showDialog(
    context: context,
    builder: (context) => WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, null);
        return false;
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 285, horizontal: 25),
        padding: const EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width * 0.92,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            width: 2,
            color: Theme.of(context).primaryColor,
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromRGBO(165, 166, 246, 1.0), Colors.white],
            stops: [0, 0.2],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(17),
                    topRight: Radius.circular(17),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Center(
                    child: Text(
                      'Anexar arquivo ao exame',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const Text(
                'Escolha o tipo de arquivo:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: const Text(
                      'PDF',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf']);
                      File? file;

                      if (result == null) {
                        Navigator.pop(context, null);
                        return;
                      }

                      file = File(result.files.single.path!);
                      Navigator.pop(context, file);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      maximumSize: const Size(200, 40),
                      minimumSize: const Size(200, 40),
                      backgroundColor: Theme.of(context).focusColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: const Text(
                      'Fotos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.image,
                        allowMultiple: true,
                      );
                      if (result == null) {
                        Navigator.pop(context, null);
                        return;
                      }

                      List<File> files =
                          result.paths.map((path) => File(path!)).toList();

                      final pdf = pw.Document();
                      for (File imagem in files) {
                        pdf.addPage(
                          pw.Page(
                            pageFormat: PdfPageFormat.undefined,
                            margin: pw.EdgeInsets.zero,
                            build: (pw.Context context) {
                              return pw.Center(
                                child: pw.Image(
                                  pw.MemoryImage(
                                    imagem.readAsBytesSync(),
                                  ),
                                  fit: pw.BoxFit.scaleDown,
                                ),
                              );
                            },
                          ),
                        );
                      }

                      final output = await getTemporaryDirectory();
                      final fullpath = "${output.path}/$codigoExame.pdf";
                      final pdfFile = File(fullpath);

                      if (await pdfFile.exists()) await pdfFile.delete();

                      await pdfFile.writeAsBytes(await pdf.save());

                      Navigator.pop(context, pdfFile);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      maximumSize: const Size(200, 40),
                      minimumSize: const Size(200, 40),
                      backgroundColor: Theme.of(context).focusColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
