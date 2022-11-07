import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sono/constants/constants.dart';

class QrCodeGerado extends StatelessWidget {
  const QrCodeGerado({required this.idEquipamento, Key? key}) : super(key: key);

  final String idEquipamento;

  @override
  Widget build(BuildContext context) {
    final ScreenshotController screenshotController = ScreenshotController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Qr Code'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                'Código gerado do equipamento: \n$idEquipamento',
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Screenshot(
                controller: screenshotController,
                child: QrImage(
                  data: idEquipamento,
                  size: 250,
                  backgroundColor: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(97, 253, 125, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                    onPressed: () async {
                      const snackBar = SnackBar(
                        content: Text(
                          'Salvo com sucesso!',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Constantes.corAzulEscuroSecundario,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      final imagefile = await screenshotController.capture();
                      if (imagefile != null) {
                        saveImage(imagefile);
                      } else {
                        return;
                      }
                    },
                    child: const Text(
                      'Salvar na Galeria',
                      style: TextStyle(color: Colors.black),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = 'screenshot_$time';
    final result = await ImageGallerySaver.saveImage(bytes, name: name);

    return result['filePath'];
  }
}
