import 'package:flutter/material.dart';

/// Porte de `TableAction<T>` (core/models/interfaces/TableAction.ts).
///
/// `icon` é o identificador Lucide (kebab-case) consumido por `IconeDefaultComponent`.
/// `iconType` e `classes` do original não foram portados: eram, respectivamente, um campo
/// não lido em nenhum lugar do tablegrid original e uma classe CSS extra sem equivalente
/// direto em Flutter — sem uso real a preservar.
/// `permission` é mantido apenas como dado: assim como no original, [TableGrid] não o
/// interpreta — quem monta a lista de ações é responsável por filtrar por permissão antes.
class TableAction<T> {
  final String icon;
  final String tooltip;
  final Color? color;
  final bool Function(T row)? canShow;
  final void Function(T row) handler;
  final String? permission;

  const TableAction({
    required this.icon,
    required this.tooltip,
    this.color,
    this.canShow,
    required this.handler,
    this.permission,
  });

  bool podeMostrar(T row) => canShow == null ? true : canShow!(row);
}
