import 'package:flutter/material.dart';

import '../code_design_system_theme.dart';
import '../core/platform_widget.dart';

/// Descrição de uma aba para [NavbarTabsDefault].
class NavbarTabItemDefault {
  final String texto;
  final IconData? icone;
  final bool disabled;

  const NavbarTabItemDefault({
    required this.texto,
    this.icone,
    this.disabled = false,
  });
}

/// Barra horizontal de abas, inspirada em `.nav-tabs` e `.nav-pills` do Bootstrap.
///
/// O componente é controlado: [indiceAtivo] determina a aba visível e
/// [aoTrocar] recebe a escolha do usuário. Ele não gerencia conteúdo; combine-o
/// com o conteúdo do dashboard que corresponde ao índice selecionado.
class NavbarTabsDefault extends PlatformWidget {
  final List<NavbarTabItemDefault> abas;
  final int indiceAtivo;
  final ValueChanged<int>? aoTrocar;
  final bool pills;
  final Color? corAtiva;
  final Color? corTexto;
  final EdgeInsetsGeometry padding;

  const NavbarTabsDefault({
    super.key,
    required this.abas,
    this.indiceAtivo = 0,
    this.aoTrocar,
    this.pills = false,
    this.corAtiva,
    this.corTexto,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  }) : assert(indiceAtivo >= 0);

  Widget _build(BuildContext context) {
    final design = context.design;
    final texto = corTexto ?? Theme.of(context).colorScheme.onSurface;
    final ativa = corAtiva ?? design.corPrimaria;

    return Container(
      padding: padding,
      decoration: pills
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: design.corBorda)),
            ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var index = 0; index < abas.length; index++)
              _NavbarTab(
                item: abas[index],
                ativa: index == indiceAtivo,
                pills: pills,
                corTexto: texto,
                corAtiva: ativa,
                aoTocar: () => aoTrocar?.call(index),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget createAndroidWidget(BuildContext context) => _build(context);

  @override
  Widget createIosWidget(BuildContext context) => _build(context);
}

class _NavbarTab extends StatelessWidget {
  final NavbarTabItemDefault item;
  final bool ativa;
  final bool pills;
  final Color corTexto;
  final Color corAtiva;
  final VoidCallback aoTocar;

  const _NavbarTab({
    required this.item,
    required this.ativa,
    required this.pills,
    required this.corTexto,
    required this.corAtiva,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    final color = item.disabled
        ? corTexto.withValues(alpha: 0.38)
        : ativa && pills
        ? Colors.white
        : ativa
        ? corAtiva
        : corTexto.withValues(alpha: 0.68);

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(pills ? 999 : 0),
        onTap: item.disabled ? null : aoTocar,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: ativa && pills ? corAtiva : Colors.transparent,
            borderRadius: pills ? BorderRadius.circular(999) : null,
            border: pills || !ativa
                ? null
                : Border(bottom: BorderSide(color: corAtiva, width: 2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icone != null) ...[
                Icon(item.icone, size: 18, color: color),
                const SizedBox(width: 7),
              ],
              Text(
                item.texto,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
