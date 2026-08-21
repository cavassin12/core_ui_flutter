import 'package:flutter/material.dart';

import '../code_design_system_theme.dart';
import '../core/platform_widget.dart';

/// Item de navegação exibido por [NavbarDefault].
class NavbarItemDefault {
  final String texto;
  final IconData? icone;
  final bool ativo;
  final bool disabled;
  final VoidCallback? aoTocar;

  const NavbarItemDefault({
    required this.texto,
    this.icone,
    this.ativo = false,
    this.disabled = false,
    this.aoTocar,
  });
}

/// Barra de navegação horizontal inspirada em `.navbar` do Bootstrap.
///
/// É indicada para o topo de dashboards: comporta marca, itens de navegação
/// e ações à direita. Em espaços estreitos, os itens permanecem acessíveis por
/// rolagem horizontal, em vez de serem cortados ou quebrados em duas linhas.
class NavbarDefault extends PlatformWidget implements PreferredSizeWidget {
  final Widget? marca;
  final List<NavbarItemDefault> itens;
  final List<Widget> itensCustomizados;
  final List<Widget> acoes;
  final Color? corFundo;
  final Color? corTexto;
  final Color? corItemAtivo;
  final double altura;
  final EdgeInsetsGeometry padding;
  final bool elevado;

  const NavbarDefault({
    super.key,
    this.marca,
    this.itens = const [],
    this.itensCustomizados = const [],
    this.acoes = const [],
    this.corFundo,
    this.corTexto,
    this.corItemAtivo,
    this.altura = 56,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.elevado = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(altura);

  Widget _build(BuildContext context) {
    final design = context.design;
    final fundo = corFundo ?? design.corFundo;
    final texto = corTexto ?? Theme.of(context).colorScheme.onSurface;
    final ativo = corItemAtivo ?? design.corPrimaria;

    return Material(
      color: fundo,
      elevation: elevado ? 2 : 0,
      child: SizedBox(
        height: altura,
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              if (marca != null) ...[
                DefaultTextStyle.merge(
                  style: TextStyle(
                    color: texto,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  child: marca!,
                ),
                const SizedBox(width: 20),
              ],
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final item in itens)
                        _NavbarItem(
                          item: item,
                          corTexto: texto,
                          corAtiva: ativo,
                        ),
                      ...itensCustomizados,
                    ],
                  ),
                ),
              ),
              if (acoes.isNotEmpty) ...[
                const SizedBox(width: 12),
                Row(mainAxisSize: MainAxisSize.min, children: acoes),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget createAndroidWidget(BuildContext context) => _build(context);

  @override
  Widget createIosWidget(BuildContext context) => _build(context);
}

class _NavbarItem extends StatelessWidget {
  final NavbarItemDefault item;
  final Color corTexto;
  final Color corAtiva;

  const _NavbarItem({
    required this.item,
    required this.corTexto,
    required this.corAtiva,
  });

  @override
  Widget build(BuildContext context) {
    final color = item.disabled
        ? corTexto.withValues(alpha: 0.38)
        : item.ativo
        ? corAtiva
        : corTexto.withValues(alpha: 0.72);

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: item.disabled ? null : item.aoTocar,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icone != null) ...[
                Icon(item.icone, size: 18, color: color),
                const SizedBox(width: 7),
              ],
              Text(
                item.texto,
                style: TextStyle(
                  color: color,
                  fontWeight: item.ativo ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
