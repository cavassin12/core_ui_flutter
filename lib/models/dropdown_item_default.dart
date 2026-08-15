import 'package:flutter/material.dart';

import '../types/icones_default.dart';

/// Representa um item do menu do `DropdownDefault`.
///
/// Use os construtores nomeados [DropdownItemDefault.divider], [DropdownItemDefault.header]
/// e [DropdownItemDefault.texto] para os itens não clicáveis do Bootstrap
/// (`dropdown-divider`, `dropdown-header`, `dropdown-item-text`).
class DropdownItemDefault {
  final String? label;
  final IconData? icone;
  final IconesDefault? iconeDefault;
  final VoidCallback? onTap;
  final bool active;
  final bool disabled;
  final bool isDivider;
  final bool isHeader;
  final bool isText;

  const DropdownItemDefault({
    required this.label,
    this.icone,
    this.iconeDefault,
    this.onTap,
    this.active = false,
    this.disabled = false,
  })  : isDivider = false,
        isHeader = false,
        isText = false;

  const DropdownItemDefault.divider()
      : label = null,
        icone = null,
        iconeDefault = null,
        onTap = null,
        active = false,
        disabled = false,
        isDivider = true,
        isHeader = false,
        isText = false;

  const DropdownItemDefault.header(String texto)
      : label = texto,
        icone = null,
        iconeDefault = null,
        onTap = null,
        active = false,
        disabled = false,
        isDivider = false,
        isHeader = true,
        isText = false;

  const DropdownItemDefault.texto(String texto)
      : label = texto,
        icone = null,
        iconeDefault = null,
        onTap = null,
        active = false,
        disabled = false,
        isDivider = false,
        isHeader = false,
        isText = true;
}
