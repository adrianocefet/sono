import 'package:flutter/material.dart';

void mostrarDialogCarregando(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: const AbsorbPointer(
          absorbing: true,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    },
  );
}
