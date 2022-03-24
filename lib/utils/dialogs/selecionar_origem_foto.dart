import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sono/constants/constants.dart';

Future<ImageSource?> selecionarOrigemFoto(BuildContext context) async {
  return await showDialog<ImageSource>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "Selecione a origem da foto",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Constantes.corAzulEscuroPrincipal,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: ListView(
          shrinkWrap: true,
          children: [
            const Divider(),
            ListTile(
              title: const Text(
                "Galeria",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Constantes.corAzulEscuroSecundario,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(
                  context,
                  ImageSource.gallery,
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                "Câmera",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Constantes.corAzulEscuroSecundario,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(
                  context,
                  ImageSource.camera,
                );
              },
            ),
            const Divider(),
          ],
        ),
      );
    },
  );
}
