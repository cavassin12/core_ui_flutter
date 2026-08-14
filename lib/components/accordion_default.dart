import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Velocidade da rolagem automática até a seção quando ela é aberta.
enum AccordionRolagem { rapida, lenta, nenhuma }

/// Tipo de feedback tátil disparado ao abrir/fechar uma seção.
enum AccordionFeedbackHaptico { nenhum, leve, medio, pesado, selecao }

/// Uma seção do [AccordionDefault]: cabeçalho, conteúdo e, opcionalmente,
/// overrides individuais das cores/bordas/espaçamentos definidos
/// globalmente no [AccordionDefault].
class AccordionItem {
  /// Widget exibido no cabeçalho (sempre visível).
  final Widget cabecalho;

  /// Widget exibido quando a seção está aberta.
  final Widget conteudo;

  /// Define se a seção já inicia aberta.
  final bool abertoInicialmente;

  /// Chamado quando a seção é aberta.
  final VoidCallback? aoAbrir;

  /// Chamado quando a seção é fechada.
  final VoidCallback? aoFechar;

  /// Cor de fundo do cabeçalho fechado. Sobrepõe
  /// [AccordionDefault.corFundoCabecalho] para esta seção.
  final Color? corFundoCabecalho;

  /// Cor de fundo do cabeçalho aberto. Sobrepõe
  /// [AccordionDefault.corFundoCabecalhoAberto] para esta seção.
  final Color? corFundoCabecalhoAberto;

  /// Cor da borda do cabeçalho fechado.
  final Color? corBordaCabecalho;

  /// Cor da borda do cabeçalho aberto.
  final Color? corBordaCabecalhoAberto;

  /// Espessura da borda do cabeçalho.
  final double? larguraBordaCabecalho;

  /// Espaçamento interno do cabeçalho.
  final EdgeInsetsGeometry? espacamentoCabecalho;

  /// Widget exibido à esquerda do cabeçalho.
  final Widget? iconeEsquerdo;

  /// Widget exibido à direita do cabeçalho (padrão: seta para baixo).
  final Widget? iconeDireito;

  /// Cor de fundo do conteúdo.
  final Color? corFundoConteudo;

  /// Cor da borda do conteúdo.
  final Color? corBordaConteudo;

  /// Espessura da borda do conteúdo.
  final double? larguraBordaConteudo;

  /// Raio das bordas do cabeçalho e do conteúdo.
  final double? raioBorda;

  /// Espaçamento horizontal interno do conteúdo.
  final double? espacamentoHorizontalConteudo;

  /// Espaçamento vertical interno do conteúdo.
  final double? espacamentoVerticalConteudo;

  const AccordionItem({
    required this.cabecalho,
    required this.conteudo,
    this.abertoInicialmente = false,
    this.aoAbrir,
    this.aoFechar,
    this.corFundoCabecalho,
    this.corFundoCabecalhoAberto,
    this.corBordaCabecalho,
    this.corBordaCabecalhoAberto,
    this.larguraBordaCabecalho,
    this.espacamentoCabecalho,
    this.iconeEsquerdo,
    this.iconeDireito,
    this.corFundoConteudo,
    this.corBordaConteudo,
    this.larguraBordaConteudo,
    this.raioBorda,
    this.espacamentoHorizontalConteudo,
    this.espacamentoVerticalConteudo,
  });
}

/// Componente único de acordeão (lista de seções expansíveis), inspirado no
/// pacote [`accordion`](https://github.com/GotJimmy/accordion), com todas as
/// opções de customização traduzidas para português: número máximo de
/// seções abertas, animação, ícones, cores/bordas/espaçamentos (globais e
/// por seção), rolagem automática e feedback tátil.
///
/// Uso básico:
/// ```dart
/// AccordionDefault(
///   itens: [
///     AccordionItem(
///       cabecalho: const Text('Seção 1'),
///       conteudo: const Text('Conteúdo da seção 1'),
///     ),
///     AccordionItem(
///       cabecalho: const Text('Seção 2'),
///       conteudo: const Text('Conteúdo da seção 2'),
///     ),
///   ],
/// )
/// ```
class AccordionDefault extends StatefulWidget {
  /// Seções exibidas pelo acordeão, na ordem desejada.
  final List<AccordionItem> itens;

  /// Número máximo de seções abertas simultaneamente. Ao abrir uma nova
  /// seção além do limite, a seção aberta há mais tempo é fechada
  /// automaticamente.
  final int maximoSecoesAbertas;

  /// Desativa a rolagem interna do acordeão — use quando ele já estiver
  /// dentro de uma lista/scroll externo.
  final bool desabilitarRolagem;

  /// Habilita animação ao abrir/fechar as seções.
  final bool animarAberturaFechamento;

  /// Aplica um leve efeito de escala ao conteúdo durante a animação de
  /// abertura.
  final bool escalarDuranteAnimacao;

  /// Atraso antes de abrir automaticamente as seções marcadas com
  /// [AccordionItem.abertoInicialmente], produzindo uma sequência de
  /// abertura ao montar o widget em vez de já nascerem abertas.
  final Duration atrasoSequenciaAberturaInicial;

  /// Inverte (rotaciona 180°) o [AccordionItem.iconeEsquerdo] quando a seção
  /// está aberta.
  final bool inverterIconeEsquerdoSeAberto;

  /// Inverte (rotaciona 180°) o ícone direito quando a seção está aberta.
  final bool inverterIconeDireitoSeAberto;

  /// Duração da animação de abrir/fechar e de rotação dos ícones.
  final Duration duracaoAnimacao;

  /// Curva da animação de abrir/fechar.
  final Curve curvaAnimacao;

  /// Espaçamento acima da primeira seção.
  final double espacamentoTopoLista;

  /// Espaçamento abaixo da última seção.
  final double espacamentoRodapeLista;

  /// Espaçamento horizontal aplicado a toda a lista de seções.
  final double espacamentoHorizontalLista;

  /// Cor de fundo padrão do cabeçalho fechado. Usa a cor primária do tema
  /// quando omitida.
  final Color? corFundoCabecalho;

  /// Cor de fundo padrão do cabeçalho aberto. Usa [corFundoCabecalho]
  /// quando omitida.
  final Color? corFundoCabecalhoAberto;

  /// Cor de borda padrão do cabeçalho fechado. Usa a cor primária do tema
  /// quando omitida.
  final Color? corBordaCabecalho;

  /// Cor de borda padrão do cabeçalho aberto. Usa [corBordaCabecalho]
  /// quando omitida.
  final Color? corBordaCabecalhoAberto;

  /// Espessura padrão da borda do cabeçalho.
  final double larguraBordaCabecalho;

  /// Espaçamento interno padrão do cabeçalho.
  final EdgeInsetsGeometry espacamentoCabecalho;

  /// Widget padrão exibido à direita do cabeçalho quando a seção não
  /// define [AccordionItem.iconeDireito].
  final Widget iconeDireitoPadrao;

  /// Cor de fundo padrão do conteúdo.
  final Color corFundoConteudo;

  /// Cor de borda padrão do conteúdo.
  final Color corBordaConteudo;

  /// Espessura padrão da borda do conteúdo.
  final double larguraBordaConteudo;

  /// Raio das bordas padrão do cabeçalho e do conteúdo.
  final double raioBorda;

  /// Espaçamento horizontal interno padrão do conteúdo.
  final double espacamentoHorizontalConteudo;

  /// Espaçamento vertical interno padrão do conteúdo.
  final double espacamentoVerticalConteudo;

  /// Distância entre duas seções quando ambas estão fechadas.
  final double espacamentoEntreSecoesFechadas;

  /// Distância entre duas seções quando uma delas está aberta.
  final double espacamentoEntreSecoesAbertas;

  /// Velocidade da rolagem automática até a seção aberta.
  final AccordionRolagem rolarParaSecaoAoAbrir;

  /// Feedback tátil disparado ao abrir uma seção.
  final AccordionFeedbackHaptico feedbackHapticoAoAbrir;

  /// Feedback tátil disparado ao fechar uma seção.
  final AccordionFeedbackHaptico feedbackHapticoAoFechar;

  const AccordionDefault({
    super.key,
    required this.itens,
    this.maximoSecoesAbertas = 1,
    this.desabilitarRolagem = false,
    this.animarAberturaFechamento = true,
    this.escalarDuranteAnimacao = true,
    this.atrasoSequenciaAberturaInicial = Duration.zero,
    this.inverterIconeEsquerdoSeAberto = false,
    this.inverterIconeDireitoSeAberto = true,
    this.duracaoAnimacao = const Duration(milliseconds: 300),
    this.curvaAnimacao = Curves.easeInOut,
    this.espacamentoTopoLista = 20.0,
    this.espacamentoRodapeLista = 40.0,
    this.espacamentoHorizontalLista = 10.0,
    this.corFundoCabecalho,
    this.corFundoCabecalhoAberto,
    this.corBordaCabecalho,
    this.corBordaCabecalhoAberto,
    this.larguraBordaCabecalho = 0.0,
    this.espacamentoCabecalho = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),
    this.iconeDireitoPadrao = const Icon(Icons.keyboard_arrow_down),
    this.corFundoConteudo = Colors.white,
    this.corBordaConteudo = Colors.white,
    this.larguraBordaConteudo = 0.0,
    this.raioBorda = 20.0,
    this.espacamentoHorizontalConteudo = 10.0,
    this.espacamentoVerticalConteudo = 10.0,
    this.espacamentoEntreSecoesFechadas = 3.0,
    this.espacamentoEntreSecoesAbertas = 10.0,
    this.rolarParaSecaoAoAbrir = AccordionRolagem.nenhuma,
    this.feedbackHapticoAoAbrir = AccordionFeedbackHaptico.nenhum,
    this.feedbackHapticoAoFechar = AccordionFeedbackHaptico.nenhum,
  }) : assert(maximoSecoesAbertas > 0, 'maximoSecoesAbertas deve ser >= 1');

  @override
  State<AccordionDefault> createState() => _AccordionDefaultState();
}

class _AccordionDefaultState extends State<AccordionDefault> {
  final Set<int> _abertos = {};
  final List<int> _ordemAbertura = [];
  List<GlobalKey> _chaves = [];

  @override
  void initState() {
    super.initState();
    _chaves = List.generate(widget.itens.length, (_) => GlobalKey());
    _abrirSecoesIniciais();
  }

  @override
  void didUpdateWidget(covariant AccordionDefault oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itens.length != widget.itens.length) {
      _chaves = List.generate(widget.itens.length, (_) => GlobalKey());
      _abertos.removeWhere((index) => index >= widget.itens.length);
      _ordemAbertura.removeWhere((index) => index >= widget.itens.length);
    }
  }

  void _abrirSecoesIniciais() {
    final indicesIniciais = <int>[
      for (var i = 0; i < widget.itens.length; i++)
        if (widget.itens[i].abertoInicialmente) i,
    ];
    if (indicesIniciais.isEmpty) return;

    void abrirTodos() {
      if (!mounted) return;
      setState(() {
        for (final index in indicesIniciais) {
          _abertos.add(index);
          _ordemAbertura.add(index);
        }
        while (_abertos.length > widget.maximoSecoesAbertas &&
            _ordemAbertura.isNotEmpty) {
          final maisAntiga = _ordemAbertura.removeAt(0);
          _abertos.remove(maisAntiga);
        }
      });
    }

    if (widget.atrasoSequenciaAberturaInicial == Duration.zero) {
      abrirTodos();
    } else {
      Future.delayed(widget.atrasoSequenciaAberturaInicial, abrirTodos);
    }
  }

  void _disparaFeedback(AccordionFeedbackHaptico tipo) {
    switch (tipo) {
      case AccordionFeedbackHaptico.leve:
        HapticFeedback.lightImpact();
        break;
      case AccordionFeedbackHaptico.medio:
        HapticFeedback.mediumImpact();
        break;
      case AccordionFeedbackHaptico.pesado:
        HapticFeedback.heavyImpact();
        break;
      case AccordionFeedbackHaptico.selecao:
        HapticFeedback.selectionClick();
        break;
      case AccordionFeedbackHaptico.nenhum:
        break;
    }
  }

  void _rolarParaSecao(int index) {
    if (widget.rolarParaSecaoAoAbrir == AccordionRolagem.nenhuma) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contexto = _chaves[index].currentContext;
      if (contexto == null) return;
      Scrollable.ensureVisible(
        contexto,
        duration: widget.rolarParaSecaoAoAbrir == AccordionRolagem.rapida
            ? const Duration(milliseconds: 200)
            : const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    });
  }

  void _alternar(int index) {
    final item = widget.itens[index];
    final aberto = _abertos.contains(index);

    setState(() {
      if (aberto) {
        _abertos.remove(index);
        _ordemAbertura.remove(index);
        item.aoFechar?.call();
        _disparaFeedback(widget.feedbackHapticoAoFechar);
        return;
      }

      while (_abertos.length >= widget.maximoSecoesAbertas &&
          _ordemAbertura.isNotEmpty) {
        final maisAntiga = _ordemAbertura.removeAt(0);
        _abertos.remove(maisAntiga);
        widget.itens[maisAntiga].aoFechar?.call();
      }

      _abertos.add(index);
      _ordemAbertura.add(index);
      item.aoAbrir?.call();
      _disparaFeedback(widget.feedbackHapticoAoAbrir);
    });

    if (!aberto) _rolarParaSecao(index);
  }

  Color _corFundoCabecalho(AccordionItem item, bool aberto, BuildContext context) {
    final fechado = item.corFundoCabecalho ??
        widget.corFundoCabecalho ??
        Theme.of(context).colorScheme.primary;
    if (!aberto) return fechado;
    return item.corFundoCabecalhoAberto ?? widget.corFundoCabecalhoAberto ?? fechado;
  }

  Color _corBordaCabecalho(AccordionItem item, bool aberto, BuildContext context) {
    final fechado = item.corBordaCabecalho ??
        widget.corBordaCabecalho ??
        Theme.of(context).colorScheme.primary;
    if (!aberto) return fechado;
    return item.corBordaCabecalhoAberto ?? widget.corBordaCabecalhoAberto ?? fechado;
  }

  double _larguraBordaCabecalho(AccordionItem item) =>
      item.larguraBordaCabecalho ?? widget.larguraBordaCabecalho;

  EdgeInsetsGeometry _espacamentoCabecalho(AccordionItem item) =>
      item.espacamentoCabecalho ?? widget.espacamentoCabecalho;

  double _raioBorda(AccordionItem item) => item.raioBorda ?? widget.raioBorda;

  Color _corFundoConteudo(AccordionItem item) =>
      item.corFundoConteudo ?? widget.corFundoConteudo;

  Color _corBordaConteudo(AccordionItem item) =>
      item.corBordaConteudo ?? widget.corBordaConteudo;

  double _larguraBordaConteudo(AccordionItem item) =>
      item.larguraBordaConteudo ?? widget.larguraBordaConteudo;

  double _espacamentoHorizontalConteudo(AccordionItem item) =>
      item.espacamentoHorizontalConteudo ?? widget.espacamentoHorizontalConteudo;

  double _espacamentoVerticalConteudo(AccordionItem item) =>
      item.espacamentoVerticalConteudo ?? widget.espacamentoVerticalConteudo;

  Widget _buildCabecalho(int index, bool aberto) {
    final item = widget.itens[index];
    final raio = _raioBorda(item);

    return InkWell(
      onTap: () => _alternar(index),
      borderRadius: BorderRadius.circular(raio),
      child: Container(
        padding: _espacamentoCabecalho(item),
        decoration: BoxDecoration(
          color: _corFundoCabecalho(item, aberto, context),
          border: Border.all(
            color: _corBordaCabecalho(item, aberto, context),
            width: _larguraBordaCabecalho(item),
          ),
          borderRadius: BorderRadius.circular(raio),
        ),
        child: Row(
          children: [
            if (item.iconeEsquerdo != null) ...[
              AnimatedRotation(
                turns: (aberto && widget.inverterIconeEsquerdoSeAberto)
                    ? 0.5
                    : 0,
                duration: widget.duracaoAnimacao,
                child: item.iconeEsquerdo!,
              ),
              const SizedBox(width: 8),
            ],
            Expanded(child: item.cabecalho),
            const SizedBox(width: 8),
            AnimatedRotation(
              turns: (aberto && widget.inverterIconeDireitoSeAberto) ? 0.5 : 0,
              duration: widget.duracaoAnimacao,
              child: item.iconeDireito ?? widget.iconeDireitoPadrao,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConteudo(int index, bool aberto) {
    final item = widget.itens[index];
    final raio = _raioBorda(item);

    final corpo = aberto
        ? Container(
            key: ValueKey('conteudo_$index'),
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: _espacamentoHorizontalConteudo(item),
              vertical: _espacamentoVerticalConteudo(item),
            ),
            decoration: BoxDecoration(
              color: _corFundoConteudo(item),
              border: Border.all(
                color: _corBordaConteudo(item),
                width: _larguraBordaConteudo(item),
              ),
              borderRadius: BorderRadius.circular(raio),
            ),
            child: item.conteudo,
          )
        : SizedBox(key: ValueKey('vazio_$index'), width: double.infinity);

    final animado = AnimatedSize(
      duration: widget.animarAberturaFechamento
          ? widget.duracaoAnimacao
          : Duration.zero,
      curve: widget.curvaAnimacao,
      alignment: Alignment.topCenter,
      child: corpo,
    );

    if (!aberto || !widget.escalarDuranteAnimacao) return animado;

    return TweenAnimationBuilder<double>(
      key: ValueKey('escala_$index'),
      tween: Tween(begin: 0.96, end: 1.0),
      duration: widget.duracaoAnimacao,
      curve: widget.curvaAnimacao,
      builder: (context, valor, filho) =>
          Transform.scale(scale: valor, alignment: Alignment.topCenter, child: filho),
      child: animado,
    );
  }

  Widget _buildSecao(int index) {
    final aberto = _abertos.contains(index);
    return Column(
      key: _chaves[index],
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCabecalho(index, aberto),
        _buildConteudo(index, aberto),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.itens.length;
    final filhos = <Widget>[];

    for (var i = 0; i < total; i++) {
      filhos.add(_buildSecao(i));
      if (i < total - 1) {
        final proximaOuAtualAberta =
            _abertos.contains(i) || _abertos.contains(i + 1);
        filhos.add(
          SizedBox(
            height: proximaOuAtualAberta
                ? widget.espacamentoEntreSecoesAbertas
                : widget.espacamentoEntreSecoesFechadas,
          ),
        );
      }
    }

    final padding = EdgeInsets.only(
      top: widget.espacamentoTopoLista,
      bottom: widget.espacamentoRodapeLista,
      left: widget.espacamentoHorizontalLista,
      right: widget.espacamentoHorizontalLista,
    );

    if (widget.desabilitarRolagem) {
      return Padding(
        padding: padding,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: filhos),
      );
    }

    return ListView(padding: padding, children: filhos);
  }
}
