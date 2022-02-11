import 'package:flutter/material.dart';

void mostrarDialogCarregando(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AbsorbPointer(
        absorbing: true,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    },
  );
}
