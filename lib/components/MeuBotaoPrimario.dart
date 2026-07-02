import 'package:core_ui_flutter/core/PlatformWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MeuBotaoPrimario extends PlatformWidget {
  final String texto;
  final VoidCallback onPressed;

  const MeuBotaoPrimario({
    super.key,
    required this.texto,
    required this.onPressed,
  });

  @override
  Widget createIosWidget(BuildContext context) {
    return CupertinoButton.filled(onPressed: onPressed, child: Text(texto));
  }

  @override
  Widget createAndroidWidget(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(texto));
  }

  // Opcional: Sobrescrevendo a Web para ter um comportamento exclusivo!
  @override
  Widget createWebWidget(BuildContext context) {
    // Na Web, talvez queiramos um botão mais largo ou com efeito de Hover (mouse)
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 48,
            vertical: 20,
          ), // Maior para uso com rato
        ),
        onPressed: onPressed,
        child: Text(texto),
      ),
    );
  }
}
