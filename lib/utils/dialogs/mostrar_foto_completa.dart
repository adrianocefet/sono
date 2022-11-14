import 'package:flutter/material.dart';

Future<void> mostrarFotoCompleta(
    BuildContext context, String? urlFotoDePerfil, String semfoto) async {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  return await showDialog(
      builder: (BuildContext context) => AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(2),
            title: Container(
              decoration: const BoxDecoration(),
              height: mediaQuery.size.height * 0.6,
              child: Image.network(
                urlFotoDePerfil ?? semfoto,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
      context: context);
}
