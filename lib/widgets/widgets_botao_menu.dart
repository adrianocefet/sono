import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sono/utils/models/user_model.dart';

import '../pages/perfis/perfil_equipamento/adicionar_equipamento.dart';

class BotaoMenu extends StatefulWidget {
  const BotaoMenu({Key? key}) : super(key: key);

  @override
  _BotaoMenuState createState() => _BotaoMenuState();
}

class _BotaoMenuState extends State<BotaoMenu>
    with SingleTickerProviderStateMixin {
  final actionButtomColor = Colors.tealAccent.shade700;

  late AnimationController animation;
  final menuIsOpen = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  toggleMenu() {
    menuIsOpen.value ? animation.reverse() : animation.forward();
    menuIsOpen.value = !menuIsOpen.value;
  }

  @override
  Widget build(BuildContext context) {
    FloatingActionButton _botao(MapEntry<Icon, void Function()?> infoBotao) {
      return FloatingActionButton(
        heroTag: null,
        child: infoBotao.key,
        onPressed: infoBotao.value,
        backgroundColor: actionButtomColor,
      );
    }

    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        List<MapEntry<Icon, void Function()?>> informacoesDosBotoes = [
          MapEntry(
            const Icon(Icons.add),
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdicionarEquipamento('Máscara')),
            ),
          ),
          MapEntry(
            const Icon(Icons.sort_by_alpha),
            () {},
          ),
          MapEntry(
            const Icon(Icons.home),
            model.fazHome,
          ),
        ];

        return Flow(
          clipBehavior: Clip.none,
          delegate: FlowMenuDelegate(animation: animation),
          children: [
            FloatingActionButton(
              heroTag: null,
              child: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: animation,
              ),
              onPressed: () => toggleMenu(),
            ),
            for (var infoBotao in informacoesDosBotoes) _botao(infoBotao),
          ],
        );
      },
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  final AnimationController animation;
  FlowMenuDelegate({required this.animation}) : super(repaint: animation);

  @override
  void paintChildren(FlowPaintingContext context) {
    const buttonSize = 56;
    const buttonRadius = buttonSize / 2;
    const buttonMargin = 10;

    final positionX = context.size.width - buttonSize;
    final positionY = context.size.height - buttonSize;
    final ultimoIndex = context.childCount - 1;

    for (int i = ultimoIndex; i >= 0; i--) {
      final y = positionY - ((buttonSize + buttonMargin) * i * animation.value);
      final size = (i != 0) ? animation.value : 1.0;

      context.paintChild(
        i,
        transform: Matrix4.translationValues(positionX, y, 0.0)
          ..translate(buttonRadius, buttonRadius)
          ..scale(size)
          ..translate(-buttonRadius, -buttonRadius),
      );
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => false;
}
