import 'package:core_ui_flutter/code_design_system_theme.dart';
import 'package:core_ui_flutter/components/icone_default_component.dart';
import 'package:core_ui_flutter/core/platform_widget.dart';
import 'package:core_ui_flutter/types/button_severity.dart';
import 'package:core_ui_flutter/models/dropdown_item_default.dart';
import 'package:core_ui_flutter/types/dropdown_auto_close_default.dart';
import 'package:core_ui_flutter/types/dropdown_direction_default.dart';
import 'package:core_ui_flutter/types/dropdown_size_default.dart';
import 'package:core_ui_flutter/types/icones_default.dart';
import 'package:core_ui_flutter/types/tipo_botao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Dropdown adaptável baseado no componente Dropdown do Bootstrap.
///
/// Reúne em um único componente: botão trigger com ícone/texto, direção de
/// abertura (dropdown/dropup), itens com ícone, estado ativo/desabilitado,
/// divisores e cabeçalhos de seção, tamanhos (sm/normal/lg), variante dark
/// do menu e comportamento de fechamento automático configurável.
class DropdownDefault extends PlatformWidget {
  final List<DropdownItemDefault> items;
  final String? texto;
  final IconData? icone;
  final IconesDefault? iconeDefault;
  final TipoBotao? tipo;
  final DropdownSizeDefault tamanho;
  final DropdownDirectionDefault direcao;
  final DropdownAutoCloseDefault autoClose;
  final bool dark;
  final bool disabled;

  /// Largura fixa do menu. Se omitida, usa a largura do botão trigger
  /// (respeitando uma largura mínima de 180px).
  final double? menuWidth;

  const DropdownDefault({
    super.key,
    required this.items,
    this.texto,
    this.icone,
    this.iconeDefault,
    this.tipo,
    this.tamanho = DropdownSizeDefault.normal,
    this.direcao = DropdownDirectionDefault.down,
    this.autoClose = DropdownAutoCloseDefault.always,
    this.dark = false,
    this.disabled = false,
    this.menuWidth,
  });

  @override
  Widget createAndroidWidget(BuildContext context) {
    return _DropdownDefaultBase(parent: this, platform: TargetPlatform.android);
  }

  @override
  Widget createIosWidget(BuildContext context) {
    return _DropdownDefaultBase(parent: this, platform: TargetPlatform.iOS);
  }

  @override
  Widget createWebWidget(BuildContext context) {
    return _DropdownDefaultBase(parent: this, platform: TargetPlatform.fuchsia);
  }

  @override
  Widget createWindowsWidget(BuildContext context) {
    return _DropdownDefaultBase(parent: this, platform: TargetPlatform.windows);
  }
}

// =============================================================================
// IMPLEMENTAÇÃO ESTADUALIZADA INTERNA
// =============================================================================

class _DropdownDefaultBase extends StatefulWidget {
  final DropdownDefault parent;
  final TargetPlatform platform;

  const _DropdownDefaultBase({required this.parent, required this.platform});

  @override
  State<_DropdownDefaultBase> createState() => _DropdownDefaultBaseState();
}

class _DropdownDefaultBaseState extends State<_DropdownDefaultBase> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void didUpdateWidget(covariant _DropdownDefaultBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.parent.disabled && _isOpen) {
      _closeMenu();
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleMenu() {
    if (widget.parent.disabled) return;
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    if (_isOpen) return;
    final overlay = Overlay.of(context);
    _overlayEntry = _buildOverlayEntry();
    overlay.insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeMenu() {
    _removeOverlay();
    if (mounted) setState(() => _isOpen = false);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleItemTap(DropdownItemDefault item) {
    if (item.disabled) return;
    item.onTap?.call();

    final autoClose = widget.parent.autoClose;
    if (autoClose == DropdownAutoCloseDefault.always ||
        autoClose == DropdownAutoCloseDefault.insideClick) {
      _closeMenu();
    }
  }

  void _handleOutsideTap() {
    final autoClose = widget.parent.autoClose;
    if (autoClose == DropdownAutoCloseDefault.always ||
        autoClose == DropdownAutoCloseDefault.outsideClick) {
      _closeMenu();
    }
  }

  // ---------------------------------------------------------------------------
  // TAMANHOS
  // ---------------------------------------------------------------------------

  double get _altura {
    switch (widget.parent.tamanho) {
      case DropdownSizeDefault.small:
        return 28.0;
      case DropdownSizeDefault.normal:
        return 36.0;
      case DropdownSizeDefault.large:
        return 44.0;
    }
  }

  double get _fontSize {
    switch (widget.parent.tamanho) {
      case DropdownSizeDefault.small:
        return 12.0;
      case DropdownSizeDefault.normal:
        return 14.0;
      case DropdownSizeDefault.large:
        return 16.0;
    }
  }

  double get _paddingHorizontal {
    switch (widget.parent.tamanho) {
      case DropdownSizeDefault.small:
        return 10.0;
      case DropdownSizeDefault.normal:
        return 14.0;
      case DropdownSizeDefault.large:
        return 18.0;
    }
  }

  double get _iconSize {
    switch (widget.parent.tamanho) {
      case DropdownSizeDefault.small:
        return 14.0;
      case DropdownSizeDefault.normal:
        return 16.0;
      case DropdownSizeDefault.large:
        return 18.0;
    }
  }

  // ---------------------------------------------------------------------------
  // CORES
  // ---------------------------------------------------------------------------

  ButtonSeverity get _severity {
    final tipo = widget.parent.tipo;
    if (tipo == null) return ButtonSeverity.primary;
    if (tipo.isDanger) return ButtonSeverity.danger;
    if (tipo.isWarning) return ButtonSeverity.warn;
    if (tipo.isSuccess) return ButtonSeverity.success;
    if (tipo.isInfo) return ButtonSeverity.info;
    return ButtonSeverity.primary;
  }

  Color _resolveBackgroundColor(BuildContext context) {
    final design = context.design;
    final tipo = widget.parent.tipo;
    if (tipo == TipoBotao.defaultType || tipo == TipoBotao.xDefault) {
      return design.corSuperficie;
    }

    switch (_severity) {
      case ButtonSeverity.danger:
        return design.corErro;
      case ButtonSeverity.warn:
        return design.corAviso;
      case ButtonSeverity.success:
        return design.corSucesso;
      case ButtonSeverity.info:
        return design.corInfo;
      case ButtonSeverity.secondary:
        return design.corSecundaria;
      case ButtonSeverity.primary:
        return design.corPrimaria;
    }
  }

  Color _resolveTextColor(BuildContext context) {
    final tipo = widget.parent.tipo;
    if (tipo == TipoBotao.defaultType || tipo == TipoBotao.xDefault) {
      return context.design.corTexto;
    }
    return context.design.corPrimariaContraste;
  }

  // ---------------------------------------------------------------------------
  // OVERLAY / MENU
  // ---------------------------------------------------------------------------

  OverlayEntry _buildOverlayEntry() {
    final renderBox =
        _triggerKey.currentContext!.findRenderObject() as RenderBox;
    final triggerSize = renderBox.size;
    final isUp = widget.parent.direcao == DropdownDirectionDefault.up;

    return OverlayEntry(
      builder: (overlayContext) {
        return Focus(
          autofocus: true,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.escape) {
              _closeMenu();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _handleOutsideTap,
                  child: const SizedBox.expand(),
                ),
              ),
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                targetAnchor: isUp ? Alignment.topLeft : Alignment.bottomLeft,
                followerAnchor: isUp ? Alignment.bottomLeft : Alignment.topLeft,
                offset: Offset(0, isUp ? -4 : 4),
                child: _buildMenu(overlayContext, triggerSize),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenu(BuildContext context, Size triggerSize) {
    final theme = Theme.of(context);
    final design = context.design;
    final isDark = widget.parent.dark;

    final bgColor = isDark
        ? const Color(0xFF343A40)
        : theme.colorScheme.surface;
    final width =
        widget.parent.menuWidth ??
        (triggerSize.width < 180.0 ? 180.0 : triggerSize.width);

    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(design.raioBorda),
      color: bgColor,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: width,
          maxWidth: 320,
          maxHeight: 320,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.parent.items
                .map((item) => _buildMenuItem(context, item, isDark))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    DropdownItemDefault item,
    bool isDark,
  ) {
    final theme = Theme.of(context);

    if (item.isDivider) {
      return Divider(
        height: 9,
        thickness: 1,
        color: isDark ? Colors.white24 : theme.dividerColor,
      );
    }

    if (item.isHeader) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Text(
          item.label ?? '',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white54 : theme.textTheme.bodySmall?.color,
          ),
        ),
      );
    }

    if (item.isText) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Text(
          item.label ?? '',
          style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : null),
        ),
      );
    }

    final design = context.design;
    final corFundo = item.active ? design.corPrimaria : null;
    final Color corConteudo = item.active
        ? Colors.white
        : (item.disabled
              ? (isDark ? Colors.white30 : theme.disabledColor)
              : (isDark
                    ? Colors.white
                    : (theme.textTheme.bodyMedium?.color ?? Colors.black)));

    return InkWell(
      onTap: item.disabled ? null : () => _handleItemTap(item),
      hoverColor: isDark
          ? Colors.white.withValues(alpha: 0.08)
          : design.corPrimaria.withValues(alpha: 0.08),
      child: Container(
        color: corFundo,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (item.icone != null || item.iconeDefault != null) ...[
              IconeDefaultComponent(
                icone: item.icone,
                iconeDefault: item.iconeDefault,
                cor: corConteudo,
                tamanho: 16,
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                item.label ?? '',
                style: TextStyle(fontSize: 14, color: corConteudo),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TRIGGER
  // ---------------------------------------------------------------------------

  Widget _buildTriggerContent(Color textColor) {
    final isUp = widget.parent.direcao == DropdownDirectionDefault.up;
    final texto = widget.parent.texto;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.parent.icone != null ||
            widget.parent.iconeDefault != null) ...[
          IconeDefaultComponent(
            icone: widget.parent.icone,
            iconeDefault: widget.parent.iconeDefault,
            cor: textColor,
            tamanho: _iconSize,
          ),
          if (texto != null && texto.isNotEmpty) const SizedBox(width: 6),
        ],
        if (texto != null && texto.isNotEmpty)
          Flexible(
            child: Text(
              texto,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: _fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        const SizedBox(width: 6),
        Icon(
          isUp ? LucideIcons.chevronUp : LucideIcons.chevronDown,
          size: _iconSize,
          color: textColor,
        ),
      ],
    );
  }

  Widget _buildTrigger(BuildContext context) {
    final design = context.design;
    final disabled = widget.parent.disabled;
    final bgColor = _resolveBackgroundColor(context);
    final textColor = _resolveTextColor(context);
    final radius = BorderRadius.circular(design.raioBorda);

    Widget button = Material(
      color: disabled ? bgColor.withValues(alpha: 0.5) : bgColor,
      borderRadius: radius,
      child: InkWell(
        onTap: disabled ? null : _toggleMenu,
        borderRadius: radius,
        child: Container(
          height: _altura,
          padding: EdgeInsets.symmetric(horizontal: _paddingHorizontal),
          alignment: Alignment.center,
          child: _buildTriggerContent(
            disabled ? textColor.withValues(alpha: 0.6) : textColor,
          ),
        ),
      ),
    );

    if (widget.platform == TargetPlatform.fuchsia) {
      button = MouseRegion(
        cursor: disabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: button,
      );
    }

    return button;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: KeyedSubtree(key: _triggerKey, child: _buildTrigger(context)),
    );
  }
}
