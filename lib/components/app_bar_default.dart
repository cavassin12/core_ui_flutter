import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../code_design_system_theme.dart';
import '../core/platform_widget.dart';

/// Barra superior do app, equivalente ao `navbar` do Bootstrap adaptado para
/// o padrão de barra de título/navegação de aplicativos móveis e web:
/// título, botão de voltar automático (quando a rota atual pode ser
/// desfeita), ações à direita, e uma faixa opcional abaixo (`bottom`, ex.:
/// abas).
///
/// Implementa `PreferredSizeWidget`, então pode ser usado diretamente em
/// `Scaffold.appBar`.
///
/// Estende `PlatformWidget`: usa `AppBar` (Material) no Android/Web/Windows
/// e `CupertinoNavigationBar` no iOS/macOS — diferente da maioria dos
/// componentes do pacote, a barra de navegação tem convenções visuais
/// bem distintas entre essas plataformas (título centralizado x alinhado à
/// esquerda, seta x chevron de voltar, com/sem sombra), então essa é uma
/// variação intencional.
///
/// Uso básico:
/// ```dart
/// Scaffold(
///   appBar: AppBarDefault(titulo: 'Minha Tela'),
///   body: const Placeholder(),
/// )
/// ```
class AppBarDefault extends PlatformWidget implements PreferredSizeWidget {
  /// Título exibido na barra. Ignorado quando [tituloWidget] é informado.
  final String? titulo;

  /// Substitui totalmente o título padrão (`Text(titulo)`) por um widget
  /// customizado.
  final Widget? tituloWidget;

  /// Ações exibidas à direita da barra (equivalente aos itens à direita do
  /// `navbar`).
  final List<Widget>? acoes;

  /// Substitui totalmente o widget inicial (à esquerda) da barra, incluindo
  /// o botão de voltar automático.
  final Widget? leading;

  /// Exibe um botão de voltar automático quando a rota atual pode ser
  /// desfeita (`Navigator.canPop`). Ignorado quando [leading] é informado.
  final bool exibirBotaoVoltar;

  /// Chamado ao tocar no botão de voltar automático, no lugar do
  /// `Navigator.pop()` padrão.
  final VoidCallback? aoVoltar;

  /// Cor de fundo da barra. Usa `context.design.corPrimaria` quando omitida.
  final Color? corFundo;

  /// Cor do título/ícones/ações. Usa `Colors.white` quando omitida.
  final Color? corTexto;

  /// Elevação/sombra da barra (Android/Web/Windows). No iOS, qualquer valor
  /// maior que zero apenas garante a borda inferior padrão do
  /// `CupertinoNavigationBar`.
  final double elevacao;

  /// Centraliza o título. Padrão: `false` no Android/Web/Windows (segue o
  /// Material 3), sempre centralizado no iOS (comportamento nativo do
  /// `CupertinoNavigationBar`, não configurável).
  final bool centralizarTitulo;

  /// Faixa opcional exibida abaixo da barra (ex.: um `TabContainerDefault`
  /// ou outra barra de abas). Ignorada no iOS — `CupertinoNavigationBar` não
  /// tem uma área equivalente; se precisar de abas no iOS, coloque-as no
  /// `body` da tela.
  final PreferredSizeWidget? bottom;

  /// Altura da faixa principal da barra (sem contar [bottom]).
  final double altura;

  const AppBarDefault({
    super.key,
    this.titulo,
    this.tituloWidget,
    this.acoes,
    this.leading,
    this.exibirBotaoVoltar = true,
    this.aoVoltar,
    this.corFundo,
    this.corTexto,
    this.elevacao = 0.0,
    this.centralizarTitulo = false,
    this.bottom,
    this.altura = kToolbarHeight,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(altura + (bottom?.preferredSize.height ?? 0.0));

  void _aoTocarVoltar(BuildContext context) {
    if (aoVoltar != null) {
      aoVoltar!();
      return;
    }
    Navigator.of(context).pop();
  }

  Widget? _buildLeadingMaterial(BuildContext context) {
    if (leading != null) return leading;
    if (!exibirBotaoVoltar || !Navigator.of(context).canPop()) return null;
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => _aoTocarVoltar(context),
    );
  }

  Widget? _buildLeadingCupertino(BuildContext context) {
    if (leading != null) return leading;
    if (!exibirBotaoVoltar || !Navigator.of(context).canPop()) return null;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => _aoTocarVoltar(context),
      child: const Icon(CupertinoIcons.back),
    );
  }

  @override
  Widget createAndroidWidget(BuildContext context) {
    final design = context.design;
    final bg = corFundo ?? design.corPrimaria;
    final fg = corTexto ?? Colors.white;

    return AppBar(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: elevacao,
      centerTitle: centralizarTitulo,
      automaticallyImplyLeading: false,
      leading: _buildLeadingMaterial(context),
      title: tituloWidget ?? (titulo != null ? Text(titulo!) : null),
      actions: acoes,
      toolbarHeight: altura,
      bottom: bottom,
    );
  }

  @override
  Widget createIosWidget(BuildContext context) {
    final design = context.design;
    final bg = corFundo ?? design.corPrimaria;
    final fg = corTexto ?? Colors.white;

    final navBar = CupertinoNavigationBar(
      backgroundColor: bg,
      automaticallyImplyLeading: false,
      leading: _buildLeadingCupertino(context),
      middle: DefaultTextStyle.merge(
        style: TextStyle(color: fg, fontWeight: FontWeight.w600),
        child: tituloWidget ?? (titulo != null ? Text(titulo!) : const SizedBox.shrink()),
      ),
      trailing: acoes != null && acoes!.isNotEmpty
          ? Row(mainAxisSize: MainAxisSize.min, children: acoes!)
          : null,
      border: elevacao > 0
          ? null
          : const Border(bottom: BorderSide(color: Colors.transparent)),
    );

    if (bottom == null) return navBar;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [navBar, bottom!],
    );
  }
}
