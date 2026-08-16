import 'package:flutter/material.dart';

import '../core/platform_widget.dart';
import '../types/icones_default.dart';

class IconeDefaultComponent extends PlatformWidget {
  /// Aceita String de classe legada, nome do ícone ou diretamente um `IconData`
  final dynamic icone;

  /// Enum `IconesDefault`
  final IconesDefault? iconeDefault;

  /// Nome do ícone Lucide no formato oficial ou `IconesLucide` enum
  final dynamic iconeLucide;

  /// Tamanho do ícone (aceita double, int ou String ex: '18')
  final dynamic tamanho;

  /// Cor do ícone (aceita `Color` ou String `#FFFFFF`)
  final dynamic cor;

  const IconeDefaultComponent({
    super.key,
    this.icone,
    this.iconeDefault,
    this.iconeLucide,
    this.tamanho = '12',
    this.cor = '#ffffff',
  });

  /// Resolve o objeto `IconData` correspondente com base nos inputs
  IconData? get _iconeLucideData {
    // Se o input for diretamente um IconData do Flutter, retorna ele
    if (icone is IconData) return icone as IconData;
    if (iconeLucide is IconData) return iconeLucide as IconData;

    // Resolve a string do identificador
    String? identificador;

    if (iconeLucide != null) {
      identificador = iconeLucide is IconesLucide
          ? (iconeLucide as IconesLucide).code
          : iconeLucide.toString();
    } else if (iconeDefault != null) {
      identificador = iconeDefault!.code;
    } else if (icone != null) {
      identificador = icone.toString();
    }

    if (identificador == null || identificador.isEmpty) return null;

    final chaveNormalizada = normalizarIdentificadorLucide(identificador);
    return iconesLucideMap[chaveNormalizada];
  }

  Widget _build(BuildContext context) {
    final iconData = _iconeLucideData;
    if (iconData == null) return const SizedBox.shrink();

    final sizeResolved = parseIconSize(tamanho);
    final colorResolved = parseIconColor(cor, context);

    return Icon(iconData, size: sizeResolved, color: colorResolved);
  }

  // Um ícone não tem uma variação visual nativa relevante entre plataformas —
  // a mesma implementação é usada em todas.
  @override
  Widget createAndroidWidget(BuildContext context) => _build(context);

  @override
  Widget createIosWidget(BuildContext context) => _build(context);
}
