import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../code_design_system_theme.dart';
import '../core/platform_widget.dart';
import '../models/dropdown_item_default.dart';
import 'icone_default_component.dart';

/// Dropdown de navegação horizontal inspirado em `.nav-item.dropdown` do Bootstrap.
///
/// Use-o em [NavbarDefault.itensCustomizados]. Os itens reutilizam
/// [DropdownItemDefault], inclusive os construtores `divider`, `header` e
/// `texto`.
class NavbarDropdownDefault extends PlatformWidget {
  final String texto;
  final IconData? icone;
  final List<DropdownItemDefault> itens;
  final bool ativo;
  final bool disabled;
  final Color? corTexto;
  final Color? corAtiva;
  final double? larguraMenu;

  const NavbarDropdownDefault({
    super.key,
    required this.texto,
    required this.itens,
    this.icone,
    this.ativo = false,
    this.disabled = false,
    this.corTexto,
    this.corAtiva,
    this.larguraMenu,
  });

  Widget _build(BuildContext context) => _NavbarDropdownBase(parent: this);

  @override
  Widget createAndroidWidget(BuildContext context) => _build(context);

  @override
  Widget createIosWidget(BuildContext context) => _build(context);
}

class _NavbarDropdownBase extends StatefulWidget {
  final NavbarDropdownDefault parent;

  const _NavbarDropdownBase({required this.parent});

  @override
  State<_NavbarDropdownBase> createState() => _NavbarDropdownBaseState();
}

class _NavbarDropdownBaseState extends State<_NavbarDropdownBase> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _aberto = false;

  @override
  void didUpdateWidget(covariant _NavbarDropdownBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.parent.disabled && _aberto) _fechar();
  }

  @override
  void dispose() {
    _removerOverlay();
    super.dispose();
  }

  void _alternar() {
    if (widget.parent.disabled) return;
    _aberto ? _fechar() : _abrir();
  }

  void _abrir() {
    if (_aberto) return;
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _aberto = true);
  }

  void _fechar() {
    _removerOverlay();
    if (mounted) setState(() => _aberto = false);
  }

  void _removerOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _buildOverlay() {
    final renderBox =
        _triggerKey.currentContext!.findRenderObject() as RenderBox;
    final tamanhoTrigger = renderBox.size;

    return OverlayEntry(
      builder: (overlayContext) => Focus(
        autofocus: true,
        onKeyEvent: (_, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.escape) {
            _fechar();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _fechar,
                child: const SizedBox.expand(),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: const Offset(0, 4),
              child: _buildMenu(overlayContext, tamanhoTrigger),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context, Size tamanhoTrigger) {
    final design = context.design;
    final theme = Theme.of(context);
    final largura =
        widget.parent.larguraMenu ??
        tamanhoTrigger.width.clamp(180.0, 320.0).toDouble();

    return Material(
      elevation: 6,
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(design.raioBorda),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: largura,
          maxWidth: 320,
          maxHeight: 320,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final item in widget.parent.itens) _buildItem(context, item),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, DropdownItemDefault item) {
    final design = context.design;
    final theme = Theme.of(context);

    if (item.isDivider) return Divider(height: 9, color: design.corBorda);
    if (item.isHeader) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Text(
          item.label ?? '',
          style: TextStyle(
            color: theme.hintColor,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    if (item.isText) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(item.label ?? ''),
      );
    }

    final corTexto = item.active
        ? Colors.white
        : item.disabled
        ? theme.disabledColor
        : theme.colorScheme.onSurface;
    return InkWell(
      onTap: item.disabled
          ? null
          : () {
              item.onTap?.call();
              _fechar();
            },
      child: Container(
        color: item.active ? design.corPrimaria : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            if (item.icone != null || item.iconeDefault != null) ...[
              IconeDefaultComponent(
                icone: item.icone,
                iconeDefault: item.iconeDefault,
                cor: corTexto,
                tamanho: 16,
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(item.label ?? '', style: TextStyle(color: corTexto)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final design = context.design;
    final corBase =
        widget.parent.corTexto ?? Theme.of(context).colorScheme.onSurface;
    final corAtiva = widget.parent.corAtiva ?? design.corPrimaria;
    final cor = widget.parent.disabled
        ? corBase.withValues(alpha: 0.38)
        : widget.parent.ativo || _aberto
        ? corAtiva
        : corBase.withValues(alpha: 0.72);

    return CompositedTransformTarget(
      link: _layerLink,
      child: KeyedSubtree(
        key: _triggerKey,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: widget.parent.disabled ? null : _alternar,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.parent.icone != null) ...[
                  Icon(widget.parent.icone, size: 18, color: cor),
                  const SizedBox(width: 7),
                ],
                Text(
                  widget.parent.texto,
                  style: TextStyle(
                    color: cor,
                    fontWeight: widget.parent.ativo
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
                Icon(
                  _aberto ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: cor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
