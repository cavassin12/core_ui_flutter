import 'package:core_ui_flutter/components/icone_default_component.dart';
import 'package:core_ui_flutter/core/platform_widget.dart';
import 'package:core_ui_flutter/types/button_severity.dart';
import 'package:core_ui_flutter/types/icones_default.dart';
import 'package:core_ui_flutter/types/tipo_botao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonDefault extends PlatformWidget {
  static const double _alturaPadrao = 30.0;

  final IconData? icone;
  final IconesDefault? iconeDefault;
  final String? texto;
  final bool disabled;
  final TipoBotao? tipo;
  final Color? corTexto;
  final double tamanho;
  final double? largura;
  final double? altura;
  final VoidCallback? acaoExecutar;

  const ButtonDefault({
    super.key,
    this.icone,
    this.iconeDefault,
    this.texto,
    this.disabled = false,
    this.tipo,
    this.corTexto,
    this.tamanho = 18.0,
    this.largura,
    this.altura = _alturaPadrao,
    this.acaoExecutar,
  });

  // ---------------------------------------------------------------------------
  // LÓGICA E REGRAS DE NEGÓCIO (Fidelidade ao Angular)
  // ---------------------------------------------------------------------------

  /// Identifica se o texto do botão refere-se a uma ação de inclusão/criação
  bool get _ehAcaoInclusao {
    if (texto == null || texto!.trim().isEmpty) return false;

    // Normaliza removendo acentos e espaços
    final textoNormalizado = texto!
        .toLowerCase()
        .replaceAll(RegExp(r'[áàâãä]'), 'a')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[íìîï]'), 'i')
        .replaceAll(RegExp(r'[óòôõö]'), 'o')
        .replaceAll(RegExp(r'[úùûü]'), 'u')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .trim();

    final regex = RegExp(r'^(incluir|adicionar|novo|nova|cadastrar|criar)\b');
    return regex.hasMatch(textoNormalizado);
  }

  /// Retorna a severidade do botão com base no tipo e no texto (getSeverity do TS)
  ButtonSeverity get severity {
    if (tipo == null) return ButtonSeverity.primary;

    if (tipo!.isDanger) return ButtonSeverity.danger;
    if (tipo!.isWarning) return ButtonSeverity.warn;
    if (tipo!.isSuccess) {
      return _ehAcaoInclusao ? ButtonSeverity.primary : ButtonSeverity.success;
    }
    if (tipo!.isInfo) return ButtonSeverity.info;

    return ButtonSeverity.primary;
  }

  /// Verifica se o tamanho do botão é pequeno ('btn-sm')
  bool get isSmall => tipo?.isSmall ?? false;

  /// Calcula o tamanho do ícone (getIconSize do TS)
  double get iconSize {
    if (isSmall && tamanho == 18.0) {
      return 12.0;
    }
    return tamanho;
  }

  /// Calcula a altura final do botão
  double? get heightResolved {
    final alturaCustomizada = altura != null && altura != _alturaPadrao;
    if (isSmall) {
      return alturaCustomizada ? altura! : 24.0;
    }
    return altura;
  }

  /// Resolve a cor de fundo com base na severidade e no tema do aplicativo
  Color _resolveBackgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (severity) {
      case ButtonSeverity.danger:
        return theme.colorScheme.error;
      case ButtonSeverity.warn:
        return Colors.orange.shade700;
      case ButtonSeverity.success:
        return const Color(0xFF22C55E); // Verde padrão PrimeNG
      case ButtonSeverity.info:
        return const Color(0xFF3B82F6); // Azul padrão PrimeNG
      case ButtonSeverity.secondary:
        return theme.colorScheme.secondary;
      case ButtonSeverity.primary:
        return theme.colorScheme.primary;
    }
  }

  /// Resolve a cor do texto/ícone
  Color _resolveTextColor(BuildContext context) {
    if (corTexto != null) return corTexto!;

    // Se o botão for secundário ou padrão, usa cor do tema
    if (tipo == TipoBotao.defaultType || tipo == TipoBotao.xDefault) {
      return Theme.of(context).colorScheme.onSurface;
    }

    // Padrão: Texto branco/contraste com o fundo do botão
    return Colors.white;
  }

  /// Handler de clique
  void _handleTap() {
    if (!disabled && acaoExecutar != null) {
      acaoExecutar!();
    }
  }

  /// Conteúdo interno do botão (Ícone + Texto)
  Widget _buildContent(Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icone != null || iconeDefault != null) ...[
          IconeDefaultComponent(
            icone: icone,
            iconeDefault: iconeDefault,
            cor: textColor,
            tamanho: iconSize,
          ),
          if (texto != null && texto!.isNotEmpty) const SizedBox(width: 6),
        ],
        if (texto != null && texto!.isNotEmpty)
          Flexible(
            child: Text(
              texto!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: isSmall ? 12 : 14,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
            ),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // IMPLEMENTAÇÕES DE PLATAFORMA (PlatformWidget)
  // ---------------------------------------------------------------------------

  /// 1. ANDROID (Material Design)
  @override
  Widget createAndroidWidget(BuildContext context) {
    final bgColor = _resolveBackgroundColor(context);
    final textColor = _resolveTextColor(context);

    return SizedBox(
      width: largura,
      height: heightResolved,
      child: Material(
        color: disabled ? bgColor.withValues(alpha: 0.5) : bgColor,
        borderRadius: BorderRadius.circular(isSmall ? 4.0 : 6.0),
        elevation: 0,
        child: InkWell(
          onTap: disabled ? null : _handleTap,
          borderRadius: BorderRadius.circular(isSmall ? 4.0 : 6.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmall ? 8.0 : 12.0),
            child: Center(
              child: _buildContent(
                disabled ? textColor.withValues(alpha: 0.6) : textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 2. iOS (Cupertino Style)
  @override
  Widget createIosWidget(BuildContext context) {
    final bgColor = _resolveBackgroundColor(context);
    final textColor = _resolveTextColor(context);

    return SizedBox(
      width: largura,
      height: heightResolved,
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(horizontal: isSmall ? 8.0 : 12.0),
        color: bgColor,
        disabledColor: bgColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(isSmall ? 6.0 : 8.0),
        minimumSize: Size(0, heightResolved ?? 30.0),
        onPressed: disabled ? null : _handleTap,
        child: _buildContent(disabled ? textColor.withValues(alpha: 0.5) : textColor),
      ),
    );
  }

  /// 3. WEB (Estilo Web Responsivo com suporte a Cursor e Hover)
  @override
  Widget createWebWidget(BuildContext context) {
    final bgColor = _resolveBackgroundColor(context);
    final textColor = _resolveTextColor(context);

    return SizedBox(
      width: largura,
      height: heightResolved,
      child: MouseRegion(
        cursor: disabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: Material(
          color: disabled ? bgColor.withValues(alpha: 0.4) : bgColor,
          borderRadius: BorderRadius.circular(4.0),
          child: InkWell(
            onTap: disabled ? null : _handleTap,
            hoverColor: Colors.white.withValues(alpha: 0.12),
            splashColor: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isSmall ? 10.0 : 14.0),
              child: Center(
                child: _buildContent(
                  disabled ? textColor.withValues(alpha: 0.5) : textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 4. WINDOWS (Estilo Desktop Fluent)
  @override
  Widget createWindowsWidget(BuildContext context) {
    final bgColor = _resolveBackgroundColor(context);
    final textColor = _resolveTextColor(context);

    return SizedBox(
      width: largura,
      height: heightResolved,
      child: Material(
        color: disabled ? bgColor.withValues(alpha: 0.35) : bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
          side: BorderSide(
            color: disabled
                ? Colors.transparent
                : Colors.black.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: disabled ? null : _handleTap,
          hoverColor: Colors.white.withValues(alpha: 0.15),
          focusColor: Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmall ? 10.0 : 12.0),
            child: Center(
              child: _buildContent(
                disabled ? textColor.withValues(alpha: 0.4) : textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
