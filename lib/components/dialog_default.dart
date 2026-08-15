import 'package:core_ui_flutter/code_design_system_theme.dart';
import 'package:core_ui_flutter/core/platform_widget.dart';
import 'package:core_ui_flutter/types/dialog_tamanho.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Componente único de dialog/modal do design system, reproduzindo as
/// opções do Modal do Bootstrap (tamanho, centralização, rolagem, backdrop
/// estático, fechamento por ESC/clique fora, cabeçalho/corpo/rodapé
/// customizáveis e variante tela-cheia).
///
/// Uso normal: `DialogDefault.show(context: context, titulo: '...', corpo: ...)`.
/// Para o padrão "confirmar/cancelar" existe o atalho [DialogDefault.confirmar].
class DialogDefault extends PlatformWidget {
  /// Título exibido no cabeçalho padrão. Ignorado se [cabecalho] for informado.
  final String? titulo;

  /// Substitui totalmente o cabeçalho padrão (título + botão fechar).
  final Widget? cabecalho;

  /// Conteúdo principal do dialog.
  final Widget corpo;

  /// Ações exibidas no rodapé (normalmente botões), alinhadas à direita.
  final List<Widget>? acoes;

  /// Tamanho do dialog (`modal-sm/lg/xl/fullscreen`).
  final DialogTamanho tamanho;

  /// Centraliza o dialog verticalmente na tela (`modal-dialog-centered`).
  /// Quando `false`, o dialog fica ancorado próximo ao topo, como no
  /// Bootstrap sem essa classe.
  final bool centralizado;

  /// Permite rolagem interna do corpo quando o conteúdo excede a altura
  /// disponível (`modal-dialog-scrollable`).
  final bool rolavel;

  /// Exibe o botão "x" de fechar no cabeçalho padrão.
  final bool exibirBotaoFechar;

  const DialogDefault({
    super.key,
    this.titulo,
    this.cabecalho,
    required this.corpo,
    this.acoes,
    this.tamanho = DialogTamanho.medio,
    this.centralizado = true,
    this.rolavel = false,
    this.exibirBotaoFechar = true,
  });

  /// Exibe o [DialogDefault] como modal, reproduzindo o comportamento do
  /// Modal do Bootstrap.
  ///
  /// - [backdropEstatico]: quando `true`, clicar fora ou apertar ESC não
  ///   fecha o dialog (equivalente a `data-bs-backdrop="static"`).
  /// - [fecharComEsc]: habilita/desabilita o fechamento pela tecla ESC,
  ///   independente do backdrop.
  /// - [corBarreira]: cor do fundo escurecido atrás do dialog.
  /// - [animado]: aplica a transição de fade + escala (desative para abrir
  ///   o dialog instantaneamente, sem animação).
  static Future<T?> show<T>({
    required BuildContext context,
    String? titulo,
    Widget? cabecalho,
    required Widget corpo,
    List<Widget>? acoes,
    DialogTamanho tamanho = DialogTamanho.medio,
    bool centralizado = true,
    bool rolavel = false,
    bool exibirBotaoFechar = true,
    bool backdropEstatico = false,
    bool fecharComEsc = true,
    Color? corBarreira,
    bool animado = true,
  }) {
    final dialog = DialogDefault(
      titulo: titulo,
      cabecalho: cabecalho,
      corpo: corpo,
      acoes: acoes,
      tamanho: tamanho,
      centralizado: centralizado,
      rolavel: rolavel,
      exibirBotaoFechar: exibirBotaoFechar,
    );

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: !backdropEstatico,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: corBarreira ?? Colors.black54,
      transitionDuration: animado
          ? const Duration(milliseconds: 200)
          : Duration.zero,
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return _DialogEscListener(
          fecharComEsc: fecharComEsc && !backdropEstatico,
          child: dialog,
        );
      },
      transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
        if (!animado) return child;
        final curva = CurvedAnimation(parent: animation, curve: Curves.easeOut);
        return FadeTransition(
          opacity: curva,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(curva),
            child: child,
          ),
        );
      },
    );
  }

  /// Atalho para o padrão "confirmar/cancelar" (equivalente a um Modal do
  /// Bootstrap com dois botões de ação). Retorna `true` se o usuário
  /// confirmar, `false` caso contrário (cancelar, fechar ou clicar fora).
  static Future<bool> confirmar({
    required BuildContext context,
    required String titulo,
    required String mensagem,
    String textoConfirmar = 'Confirmar',
    String textoCancelar = 'Cancelar',
    bool destrutivo = false,
    bool backdropEstatico = false,
  }) async {
    final resultado = await show<bool>(
      context: context,
      titulo: titulo,
      tamanho: DialogTamanho.pequeno,
      backdropEstatico: backdropEstatico,
      corpo: Text(mensagem),
      acoes: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(textoCancelar),
        ),
        FilledButton(
          style: destrutivo
              ? FilledButton.styleFrom(backgroundColor: Colors.red.shade600)
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(textoConfirmar),
        ),
      ],
    );
    return resultado ?? false;
  }

  double? _larguraMaxima(DialogTamanho tamanho) {
    switch (tamanho) {
      case DialogTamanho.pequeno:
        return 320;
      case DialogTamanho.medio:
        return 500;
      case DialogTamanho.grande:
        return 760;
      case DialogTamanho.extraGrande:
        return 1100;
      case DialogTamanho.telaCheia:
        return null;
    }
  }

  List<Widget> _acoesComEspacamento() {
    final lista = acoes ?? const <Widget>[];
    final resultado = <Widget>[];
    for (var i = 0; i < lista.length; i++) {
      if (i > 0) resultado.add(const SizedBox(width: 8));
      resultado.add(lista[i]);
    }
    return resultado;
  }

  Widget _buildBotaoFechar(BuildContext context, {required bool cupertino}) {
    final icone = cupertino ? CupertinoIcons.xmark : Icons.close;
    return InkResponse(
      onTap: () => Navigator.of(context).maybePop(),
      radius: 18,
      child: Icon(icone, size: 20, color: Colors.black54),
    );
  }

  Widget _buildCabecalhoPadrao(BuildContext context, {required bool cupertino}) {
    if (titulo == null && !exibirBotaoFechar) return const SizedBox.shrink();
    final design = context.design;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: design.corBorda)),
      ),
      child: Row(
        children: [
          if (titulo != null)
            Expanded(
              child: Text(
                titulo!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            )
          else
            const Spacer(),
          if (exibirBotaoFechar) _buildBotaoFechar(context, cupertino: cupertino),
        ],
      ),
    );
  }

  Widget _buildDialog(BuildContext context, {required bool cupertino}) {
    final design = context.design;
    final isTelaCheia = tamanho == DialogTamanho.telaCheia;
    final raio = cupertino ? 14.0 : design.raioBorda;

    final cabecalhoWidget =
        cabecalho ?? _buildCabecalhoPadrao(context, cupertino: cupertino);

    final rodapeWidget = (acoes != null && acoes!.isNotEmpty)
        ? Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: design.corBorda)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _acoesComEspacamento(),
            ),
          )
        : null;

    final corpoComPadding = Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: corpo,
    );

    final conteudoRolavel = SingleChildScrollView(child: corpoComPadding);

    if (isTelaCheia) {
      return Material(
        color: design.corFundo,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              cabecalhoWidget,
              Expanded(child: conteudoRolavel),
              ?rodapeWidget,
            ],
          ),
        ),
      );
    }

    final larguraMaxima = _larguraMaxima(tamanho);
    final alturaMaxima = MediaQuery.of(context).size.height * 0.9;

    return Align(
      alignment: centralizado ? Alignment.center : Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: centralizado ? 24 : 48,
          horizontal: 16,
        ),
        child: Material(
          color: design.corFundo,
          elevation: 8,
          borderRadius: BorderRadius.circular(raio),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: larguraMaxima ?? double.infinity,
              maxHeight: alturaMaxima,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                cabecalhoWidget,
                Flexible(
                  child: rolavel ? conteudoRolavel : corpoComPadding,
                ),
                ?rodapeWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget createAndroidWidget(BuildContext context) =>
      _buildDialog(context, cupertino: false);

  @override
  Widget createIosWidget(BuildContext context) =>
      _buildDialog(context, cupertino: true);
}

/// Fecha o dialog ao pressionar ESC, respeitando `fecharComEsc`/backdrop
/// estático definidos em [DialogDefault.show].
class _DialogEscListener extends StatelessWidget {
  final bool fecharComEsc;
  final Widget child;

  const _DialogEscListener({required this.fecharComEsc, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!fecharComEsc) return child;
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.of(context).maybePop();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }
}
