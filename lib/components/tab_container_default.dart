import 'package:flutter/material.dart';

import '../controllers/tab_container_controlador.dart';
import '../core/platform_widget.dart';
import '../types/tab_container_borda.dart';

/// Componente único de abas com conteúdo (tab container), inspirado no
/// pacote [`tab_container`](https://github.com/sourcemain/tab_container),
/// com todas as opções de customização traduzidas para português: posição
/// da barra de abas, cores, bordas, dimensões, animação, tipografia e
/// comportamento.
///
/// Suporta dois modos de uso:
/// - [filhos]: o próprio componente troca o conteúdo exibido conforme a aba
///   selecionada (com animação de transição).
/// - [filho]: um único widget é exibido e sua troca fica a cargo de quem usa
///   o componente (útil quando o "container de abas" funciona apenas como
///   seletor, ex.: um switch de múltiplas opções).
///
/// Uso básico:
/// ```dart
/// TabContainerDefault(
///   abas: const [Text('Resumo'), Text('Detalhes')],
///   filhos: const [ResumoView(), DetalhesView()],
///   cores: const [Colors.blue, Colors.teal],
/// )
/// ```
class TabContainerDefault extends PlatformWidget {
  /// Widgets exibidos na barra de abas.
  final List<Widget> abas;

  /// Widgets de conteúdo correspondentes a cada aba (na mesma ordem de
  /// [abas]). Mutuamente exclusivo com [filho].
  final List<Widget>? filhos;

  /// Widget único de conteúdo, controlado manualmente por quem usa o
  /// componente. Mutuamente exclusivo com [filhos].
  final Widget? filho;

  /// Controlador externo opcional para selecionar a aba programaticamente.
  /// Quando omitido, o componente gerencia a seleção internamente a partir
  /// de [indiceInicial].
  final TabContainerControlador? controlador;

  /// Índice da aba selecionada inicialmente (ignorado quando [controlador]
  /// é informado).
  final int indiceInicial;

  /// Chamado sempre que a aba selecionada muda, com o novo índice.
  final ValueChanged<int>? aoTrocarAba;

  /// Cor de fundo única do indicador de aba ativa e do painel de conteúdo.
  /// Ignorada para abas cujo índice exista em [cores].
  final Color? cor;

  /// Cores específicas por aba (sobrepõe [cor] para o índice
  /// correspondente).
  final List<Color>? cores;

  /// Raio das bordas externas do container.
  final double raioBorda;

  /// Raio das bordas do indicador de aba ativa. Usa [raioBorda] quando
  /// omitido.
  final double? raioBordaAba;

  /// Espaçamento interno da área de conteúdo.
  final EdgeInsetsGeometry childPadding;

  /// Posição da barra de abas em relação ao conteúdo.
  final TabContainerBorda bordaAba;

  /// Altura (quando [bordaAba] é superior/inferior) ou largura (quando é
  /// esquerda/direita) da barra de abas.
  final double tamanhoAba;

  /// Fração inicial (0.0 a 1.0) de onde a barra de abas começa dentro do
  /// espaço disponível — permite deixar respiro nas laterais.
  final double inicioAbas;

  /// Fração final (0.0 a 1.0) de onde a barra de abas termina dentro do
  /// espaço disponível.
  final double fimAbas;

  /// Comprimento mínimo de cada aba (na direção paralela à barra). Quando a
  /// soma dos comprimentos mínimos excede o espaço disponível, a barra de
  /// abas passa a rolar horizontalmente/verticalmente.
  final double? comprimentoMinimoAba;

  /// Comprimento máximo de cada aba.
  final double comprimentoMaximoAba;

  /// Duração da animação de troca de aba (indicador e, quando
  /// [duracaoConteudo] não for informado, também do conteúdo).
  final Duration duracao;

  /// Curva da animação de troca de aba.
  final Curve curva;

  /// Duração da animação de transição do conteúdo. Usa [duracao] quando
  /// omitido.
  final Duration? duracaoConteudo;

  /// Curva da animação de transição do conteúdo. Usa [curva] quando
  /// omitido.
  final Curve? curvaConteudo;

  /// Permite customizar totalmente a transição do conteúdo ao trocar de
  /// aba. Quando omitido, usa um fade combinado com leve deslizamento.
  final Widget Function(Widget filho, Animation<double> animacao)?
  construtorTransicao;

  /// Estilo de texto padrão aplicado à aba selecionada (quando o conteúdo
  /// da aba for um [Text] e [sobrescreverPropriedadesTexto] for `true`).
  final TextStyle? estiloTextoSelecionado;

  /// Estilo de texto padrão aplicado às abas não selecionadas (mesmas
  /// condições de [estiloTextoSelecionado]).
  final TextStyle? estiloTextoNaoSelecionado;

  /// Quando `true`, aplica [estiloTextoSelecionado]/[estiloTextoNaoSelecionado]
  /// sobre os widgets de [abas] automaticamente (funciona melhor quando cada
  /// aba é um [Text] simples).
  final bool sobrescreverPropriedadesTexto;

  /// Sobrescreve a direção de texto/layout do componente.
  final TextDirection? direcaoTexto;

  /// Habilita a seleção de aba por toque.
  final bool habilitado;

  /// Habilita feedback tátil/sonoro do sistema ao tocar em uma aba.
  final bool habilitarFeedback;

  const TabContainerDefault({
    super.key,
    required this.abas,
    this.filhos,
    this.filho,
    this.controlador,
    this.indiceInicial = 0,
    this.aoTrocarAba,
    this.cor,
    this.cores,
    this.raioBorda = 12.0,
    this.raioBordaAba,
    this.childPadding = const EdgeInsets.all(16),
    this.bordaAba = TabContainerBorda.superior,
    this.tamanhoAba = 50.0,
    this.inicioAbas = 0.0,
    this.fimAbas = 1.0,
    this.comprimentoMinimoAba,
    this.comprimentoMaximoAba = double.infinity,
    this.duracao = const Duration(milliseconds: 300),
    this.curva = Curves.easeInOut,
    this.duracaoConteudo,
    this.curvaConteudo,
    this.construtorTransicao,
    this.estiloTextoSelecionado,
    this.estiloTextoNaoSelecionado,
    this.sobrescreverPropriedadesTexto = false,
    this.direcaoTexto,
    this.habilitado = true,
    this.habilitarFeedback = true,
  }) : assert(
         (filhos != null) ^ (filho != null),
         'Informe exatamente um entre filhos e filho.',
       ),
       assert(
         filhos == null || filhos.length == abas.length,
         'filhos deve ter o mesmo tamanho de abas.',
       );

  // Um tab container não tem uma variação visual nativa relevante entre
  // plataformas — a mesma implementação é usada em todas.
  @override
  Widget createAndroidWidget(BuildContext context) =>
      _TabContainerDefaultBase(parent: this);

  @override
  Widget createIosWidget(BuildContext context) =>
      _TabContainerDefaultBase(parent: this);
}

// =============================================================================
// IMPLEMENTAÇÃO ESTADUALIZADA INTERNA
// =============================================================================

class _TabContainerDefaultBase extends StatefulWidget {
  final TabContainerDefault parent;

  const _TabContainerDefaultBase({required this.parent});

  @override
  State<_TabContainerDefaultBase> createState() =>
      _TabContainerDefaultBaseState();
}

class _TabContainerDefaultBaseState extends State<_TabContainerDefaultBase> {
  late TabContainerControlador _controladorInterno;

  TabContainerControlador get _controlador =>
      widget.parent.controlador ?? _controladorInterno;

  @override
  void initState() {
    super.initState();
    _controladorInterno = TabContainerControlador(
      indiceInicial: widget.parent.indiceInicial,
    );
    _controlador.addListener(_aoMudarControlador);
  }

  @override
  void didUpdateWidget(covariant _TabContainerDefaultBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.parent.controlador != widget.parent.controlador) {
      (oldWidget.parent.controlador ?? _controladorInterno).removeListener(
        _aoMudarControlador,
      );
      _controlador.addListener(_aoMudarControlador);
    }
  }

  @override
  void dispose() {
    _controlador.removeListener(_aoMudarControlador);
    _controladorInterno.dispose();
    super.dispose();
  }

  void _aoMudarControlador() => setState(() {});

  bool get _vertical =>
      widget.parent.bordaAba == TabContainerBorda.esquerda ||
      widget.parent.bordaAba == TabContainerBorda.direita;

  void _selecionar(int index) {
    if (!widget.parent.habilitado) return;
    if (widget.parent.habilitarFeedback) Feedback.forTap(context);
    _controlador.selecionar(index);
    widget.parent.aoTrocarAba?.call(index);
  }

  Color _corDaAba(int index) {
    final cores = widget.parent.cores;
    if (cores != null && index < cores.length) return cores[index];
    return widget.parent.cor ?? Theme.of(context).colorScheme.primary;
  }

  Widget _buildAba(int index, double comprimento) {
    final ativo = _controlador.indice == index;
    var conteudo = widget.parent.abas[index];

    if (widget.parent.sobrescreverPropriedadesTexto && conteudo is Text) {
      final estilo = ativo
          ? widget.parent.estiloTextoSelecionado
          : widget.parent.estiloTextoNaoSelecionado;
      conteudo = Text(
        conteudo.data ?? '',
        style: (conteudo.style ?? const TextStyle()).merge(estilo),
      );
    }

    return SizedBox(
      width: _vertical ? null : comprimento,
      height: _vertical ? comprimento : null,
      child: InkWell(
        onTap: () => _selecionar(index),
        child: Center(child: conteudo),
      ),
    );
  }

  Widget _buildBarraDeAbas(double extentTotal) {
    final raioAba = widget.parent.raioBordaAba ?? widget.parent.raioBorda;
    final total = widget.parent.abas.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final espacoDisponivel = _vertical
            ? constraints.maxHeight
            : constraints.maxWidth;
        final areaAbas =
            (espacoDisponivel.isFinite ? espacoDisponivel : extentTotal) *
            (widget.parent.fimAbas - widget.parent.inicioAbas);
        final deslocamentoInicial =
            (espacoDisponivel.isFinite ? espacoDisponivel : extentTotal) *
            widget.parent.inicioAbas;

        final comprimentoIgual = (areaAbas / total).clamp(
          widget.parent.comprimentoMinimoAba ?? 0.0,
          widget.parent.comprimentoMaximoAba,
        );
        final comprimentoTotalAbas = comprimentoIgual * total;
        final precisaRolar = comprimentoTotalAbas > areaAbas + 0.5;

        final indicador = AnimatedPositioned(
          duration: widget.parent.duracao,
          curve: widget.parent.curva,
          left: _vertical ? 0 : comprimentoIgual * _controlador.indice,
          top: _vertical ? comprimentoIgual * _controlador.indice : 0,
          width: _vertical ? widget.parent.tamanhoAba : comprimentoIgual,
          height: _vertical ? comprimentoIgual : widget.parent.tamanhoAba,
          child: Container(
            decoration: BoxDecoration(
              color: _corDaAba(_controlador.indice),
              borderRadius: BorderRadius.circular(raioAba),
            ),
          ),
        );

        final linhaDeAbas = Flex(
          direction: _vertical ? Axis.vertical : Axis.horizontal,
          mainAxisSize: precisaRolar ? MainAxisSize.min : MainAxisSize.max,
          children: List.generate(
            total,
            (index) => _buildAba(index, comprimentoIgual),
          ),
        );

        final barra = Stack(
          children: [
            indicador,
            Positioned.fill(child: linhaDeAbas),
          ],
        );

        final barraComPosicionamento = Padding(
          padding: _vertical
              ? EdgeInsets.only(top: deslocamentoInicial)
              : EdgeInsets.only(left: deslocamentoInicial),
          child: SizedBox(
            width: _vertical ? widget.parent.tamanhoAba : comprimentoTotalAbas,
            height: _vertical ? comprimentoTotalAbas : widget.parent.tamanhoAba,
            child: barra,
          ),
        );

        if (!precisaRolar) {
          return SizedBox(
            width: _vertical ? widget.parent.tamanhoAba : null,
            height: _vertical ? null : widget.parent.tamanhoAba,
            child: barraComPosicionamento,
          );
        }

        return SizedBox(
          width: _vertical ? widget.parent.tamanhoAba : double.infinity,
          height: _vertical ? double.infinity : widget.parent.tamanhoAba,
          child: SingleChildScrollView(
            scrollDirection: _vertical ? Axis.vertical : Axis.horizontal,
            child: barraComPosicionamento,
          ),
        );
      },
    );
  }

  Widget _buildTransicaoPadrao(Widget filho, Animation<double> animacao) {
    return FadeTransition(
      opacity: animacao,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(animacao),
        child: filho,
      ),
    );
  }

  Widget _buildConteudo() {
    final padding = Padding(
      padding: widget.parent.childPadding,
      child: widget.parent.filho ?? widget.parent.filhos![_controlador.indice],
    );

    if (widget.parent.filhos == null) return padding;

    return ClipRect(
      child: AnimatedSwitcher(
        duration: widget.parent.duracaoConteudo ?? widget.parent.duracao,
        switchInCurve: widget.parent.curvaConteudo ?? widget.parent.curva,
        switchOutCurve: widget.parent.curvaConteudo ?? widget.parent.curva,
        transitionBuilder:
            widget.parent.construtorTransicao ?? _buildTransicaoPadrao,
        layoutBuilder: (atual, anteriores) => Stack(
          alignment: Alignment.topCenter,
          children: [...anteriores, ?atual],
        ),
        child: KeyedSubtree(
          key: ValueKey(_controlador.indice),
          child: padding,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final conteudo = Container(
      decoration: BoxDecoration(
        color: (widget.parent.cores == null && widget.parent.cor != null)
            ? widget.parent.cor!.withValues(alpha: 0.08)
            : null,
      ),
      child: _buildConteudo(),
    );

    final barra = _buildBarraDeAbas(widget.parent.tamanhoAba);

    final filhosLayout = <Widget>[];
    switch (widget.parent.bordaAba) {
      case TabContainerBorda.superior:
        filhosLayout.addAll([barra, Expanded(child: conteudo)]);
        break;
      case TabContainerBorda.inferior:
        filhosLayout.addAll([Expanded(child: conteudo), barra]);
        break;
      case TabContainerBorda.esquerda:
        filhosLayout.addAll([barra, Expanded(child: conteudo)]);
        break;
      case TabContainerBorda.direita:
        filhosLayout.addAll([Expanded(child: conteudo), barra]);
        break;
    }

    final layout = Flex(
      direction: _vertical ? Axis.horizontal : Axis.vertical,
      children: filhosLayout,
    );

    final resultado = ClipRRect(
      borderRadius: BorderRadius.circular(widget.parent.raioBorda),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(widget.parent.raioBorda),
        ),
        child: layout,
      ),
    );

    if (widget.parent.direcaoTexto == null) return resultado;
    return Directionality(
      textDirection: widget.parent.direcaoTexto!,
      child: resultado,
    );
  }
}
