import 'package:flutter/widgets.dart';

import '../types/type_colunm.dart';

/// Porte de `DynamicColumnDTO` (core/commom-views/tablegrid/DynamicColumnDTO.ts).
///
/// Duas diferenças em relação ao original, por não haver equivalente direto em Flutter:
/// - `width` era uma string CSS (ex.: `'20%'`); aqui é uma largura fixa em pixels
///   (`null` = coluna flexível, ocupa o espaço restante — ver [Expanded] em [TableGrid]).
/// - `cellClass`/`headerClass` eram nomes de classes CSS; aqui viraram [TextStyle] opcionais.
class DynamicColumnDTO {
  final String title;
  final TypeColunm type;
  final String field;
  final String? objeto;
  final bool visible;
  final double? width;
  final int order;
  final TextStyle? cellStyle;
  final TextStyle? headerStyle;

  const DynamicColumnDTO({
    required this.title,
    this.type = TypeColunm.texto,
    required this.field,
    this.objeto,
    this.visible = true,
    this.width,
    this.order = 0,
    this.cellStyle,
    this.headerStyle,
  });
}
