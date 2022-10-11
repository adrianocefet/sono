import 'package:flutter/material.dart';

Future<void> mostrarFotoCompleta(
    BuildContext context, String? urlFotoDePerfil, String semfoto) async {
  return await showDialog(
      builder: (BuildContext context) => AlertDialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(2),
            title: Container(
              decoration: const BoxDecoration(),
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                urlFotoDePerfil ?? semfoto,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
      context: context);
}
