import 'package:flutter/material.dart';
import 'package:sono/constants/constants.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController controller;
  final int page;
  final Future Function()? onTap;

  const DrawerTile(this.icon, this.text, this.controller, this.page,
      {Key? key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Constantes.corAzulEscuroPrincipal.withAlpha(70),
        onTap: () async {
          if (onTap != null) await onTap!();
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: Container(
          color: controller.page!.round() == page
              ? Colors.black.withAlpha(20)
              : null,
          child: SizedBox(
            height: 60.0,
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: 32.0,
                ),
                Icon(
                  icon,
                  size: 32.0,
                  color: controller.page!.round() == page
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700],
                ),
                const SizedBox(
                  width: 32.0,
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: controller.page!.round() == page
                        ? Theme.of(context).primaryColor
                        : Colors.grey[700],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
