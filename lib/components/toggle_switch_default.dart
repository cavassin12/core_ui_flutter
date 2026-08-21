import 'package:flutter/material.dart';

import '../core/platform_widget.dart';

/// Componente único de switch com múltiplas opções (segmented control),
/// inspirado no pacote `toggle_switch` (PramodJoshi/toggle_switch), com
/// todos os parâmetros de customização traduzidos para português: rótulos,
/// ícones, cores, larguras, bordas, animação, orientação vertical/horizontal,
/// desseleção e cancelamento assíncrono da troca.
///
/// Uso básico:
/// ```dart
/// ToggleSwitchDefault(
///   rotulos: const ['Dia', 'Semana', 'Mês'],
///   indiceInicial: 0,
///   aoAlternar: (indice) => print('Selecionado: $indice'),
/// )
/// ```
class ToggleSwitchDefault extends PlatformWidget {
  /// Textos exibidos em cada opção do switch.
  final List<String>? rotulos;

  /// Ícones exibidos em cada opção (podem ser combinados com [rotulos]).
  final List<IconData>? icones;

  /// Widgets totalmente customizados que substituem o conteúdo padrão
  /// (rótulo + ícone) da opção correspondente.
  final List<Widget>? widgetsPersonalizados;

  /// Número total de opções. Se omitido, é inferido a partir de [rotulos],
  /// [icones] ou [widgetsPersonalizados] (o primeiro que estiver definido).
  final int? totalOpcoes;

  /// Índice selecionado inicialmente. `null` significa nenhuma opção
  /// selecionada (só é possível manter `null` após interação quando
  /// [permitirDesselecionar] for `true`).
  final int? indiceInicial;

  /// Chamado sempre que a opção selecionada muda. Recebe `null` quando o
  /// usuário desseleciona a opção ativa (ver [permitirDesselecionar]).
  final ValueChanged<int?>? aoAlternar;

  /// Chamado antes de efetivar a troca de opção, permitindo cancelá-la de
  /// forma assíncrona (ex.: confirmação, chamada de API). Retornar `false`
  /// impede a troca e o switch permanece na opção atual.
  final Future<bool> Function(int? indiceAtual, int novoIndice)?
  cancelarAlternancia;

  /// Largura mínima de cada opção quando a divisão é igualitária (ignorado
  /// quando [largurasPersonalizadas] é informado).
  final double larguraMinima;

  /// Altura de cada opção do switch.
  final double altura;

  /// Larguras fixas por opção. Quando informado, as opções deixam de se
  /// dividir igualmente pelo espaço disponível e passam a usar estas
  /// larguras (na ordem das opções).
  final List<double>? largurasPersonalizadas;

  /// Tamanho da fonte dos rótulos (ignorado quando o estilo já é definido
  /// via [estilosTextoPersonalizados]).
  final double tamanhoFonte;

  /// Tamanho dos ícones.
  final double tamanhoIcone;

  /// Raio dos cantos do switch. Ignorado quando [estiloPilula] é `true`.
  final double raioCanto;

  /// Quando `true`, os cantos ficam totalmente arredondados (formato de
  /// "pílula"), independente de [raioCanto].
  final bool estiloPilula;

  /// Cor de fundo da opção ativa. Ignorada para opções cujo índice exista em
  /// [coresFundoAtivo].
  final Color corFundoAtivo;

  /// Cores de fundo ativas por opção (sobrepõe [corFundoAtivo] para o
  /// índice correspondente).
  final List<Color>? coresFundoAtivo;

  /// Cor do texto/ícone da opção ativa.
  final Color corTextoAtivo;

  /// Cor de fundo das opções inativas / trilho do switch.
  final Color corFundoInativo;

  /// Cor do texto/ícone das opções inativas.
  final Color corTextoInativo;

  /// Cor da borda externa do switch. Quando `null`, nenhuma borda é
  /// desenhada.
  final Color? corBorda;

  /// Espessura da borda externa e do respiro entre o indicador ativo e a
  /// borda do trilho.
  final double larguraBorda;

  /// Cor do divisor exibido entre as opções inativas.
  final Color? corDivisor;

  /// Estilos de texto individuais por opção (sobrepõe [tamanhoFonte] e as
  /// cores de texto quando definirem `color`).
  final List<TextStyle>? estilosTextoPersonalizados;

  /// Anima a transição do indicador ao trocar de opção.
  final bool animar;

  /// Duração da animação (quando [animar] é `true`).
  final Duration duracaoAnimacao;

  /// Curva da animação (quando [animar] é `true`).
  final Curve curvaAnimacao;

  /// Exibe as opções na vertical (empilhadas) em vez de na horizontal.
  final bool vertical;

  /// Centraliza o conteúdo (rótulo/ícone) de cada opção.
  final bool centralizarTexto;

  /// Permite que o rótulo quebre em múltiplas linhas em vez de cortar com
  /// reticências.
  final bool textoMultilinha;

  /// Força a direção do texto/layout da direita para a esquerda (idiomas
  /// RTL).
  final bool direitaParaEsquerda;

  /// Permite que o usuário desselecione a opção ativa tocando novamente
  /// nela — a seleção passa a ser `null`.
  final bool permitirDesselecionar;

  /// Ignora toques na opção que já está selecionada (não dispara
  /// [aoAlternar] novamente). Não tem efeito quando
  /// [permitirDesselecionar] é `true`.
  final bool ignorarToqueRepetido;

  /// Desabilita completamente as interações do switch.
  final bool desabilitado;

  /// Elevação/sombra do switch. `0` remove a sombra.
  final double elevacao;

  const ToggleSwitchDefault({
    super.key,
    this.rotulos,
    this.icones,
    this.widgetsPersonalizados,
    this.totalOpcoes,
    this.indiceInicial = 0,
    this.aoAlternar,
    this.cancelarAlternancia,
    this.larguraMinima = 72,
    this.altura = 38,
    this.largurasPersonalizadas,
    this.tamanhoFonte = 14,
    this.tamanhoIcone = 18,
    this.raioCanto = 8,
    this.estiloPilula = false,
    this.corFundoAtivo = Colors.blue,
    this.coresFundoAtivo,
    this.corTextoAtivo = Colors.white,
    this.corFundoInativo = const Color(0xFFE5E7EB),
    this.corTextoInativo = Colors.black87,
    this.corBorda,
    this.larguraBorda = 0,
    this.corDivisor,
    this.estilosTextoPersonalizados,
    this.animar = true,
    this.duracaoAnimacao = const Duration(milliseconds: 200),
    this.curvaAnimacao = Curves.easeInOut,
    this.vertical = false,
    this.centralizarTexto = true,
    this.textoMultilinha = false,
    this.direitaParaEsquerda = false,
    this.permitirDesselecionar = false,
    this.ignorarToqueRepetido = true,
    this.desabilitado = false,
    this.elevacao = 0,
  }) : assert(
         rotulos != null ||
             icones != null ||
             widgetsPersonalizados != null ||
             totalOpcoes != null,
         'Informe rotulos, icones, widgetsPersonalizados ou totalOpcoes.',
       );

  // Um toggle switch não tem uma variação visual nativa relevante entre
  // plataformas — a mesma implementação é usada em todas.
  @override
  Widget createAndroidWidget(BuildContext context) =>
      _ToggleSwitchDefaultBase(parent: this);

  @override
  Widget createIosWidget(BuildContext context) =>
      _ToggleSwitchDefaultBase(parent: this);
}

// =============================================================================
// IMPLEMENTAÇÃO ESTADUALIZADA INTERNA
// =============================================================================

class _ToggleSwitchDefaultBase extends StatefulWidget {
  final ToggleSwitchDefault parent;

  const _ToggleSwitchDefaultBase({required this.parent});

  @override
  State<_ToggleSwitchDefaultBase> createState() =>
      _ToggleSwitchDefaultBaseState();
}

class _ToggleSwitchDefaultBaseState extends State<_ToggleSwitchDefaultBase> {
  late int? _selecionado;

  @override
  void initState() {
    super.initState();
    _selecionado = widget.parent.indiceInicial;
  }

  @override
  void didUpdateWidget(covariant _ToggleSwitchDefaultBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.parent.indiceInicial != oldWidget.parent.indiceInicial) {
      _selecionado = widget.parent.indiceInicial;
    }
  }

  int get _total =>
      widget.parent.totalOpcoes ??
      widget.parent.rotulos?.length ??
      widget.parent.icones?.length ??
      widget.parent.widgetsPersonalizados?.length ??
      0;

  Future<void> _aoTocar(int index) async {
    if (widget.parent.desabilitado) return;

    if (_selecionado == index) {
      if (!widget.parent.permitirDesselecionar) return;
      if (widget.parent.ignorarToqueRepetido) return;
    }

    final desmarcando =
        _selecionado == index && widget.parent.permitirDesselecionar;
    final novoIndice = desmarcando ? null : index;

    if (widget.parent.cancelarAlternancia != null) {
      final podeAlternar = await widget.parent.cancelarAlternancia!(
        _selecionado,
        index,
      );
      if (!podeAlternar) return;
    }

    setState(() => _selecionado = novoIndice);
    widget.parent.aoAlternar?.call(novoIndice);
  }

  Color _resolverCorFundoAtivo(int index) {
    final cores = widget.parent.coresFundoAtivo;
    if (cores != null && index < cores.length) return cores[index];
    return widget.parent.corFundoAtivo;
  }

  TextStyle _resolverEstiloTexto(int index, bool ativo) {
    final estilos = widget.parent.estilosTextoPersonalizados;
    final base = (estilos != null && index < estilos.length)
        ? estilos[index]
        : TextStyle(fontSize: widget.parent.tamanhoFonte);
    return base.copyWith(
      color:
          base.color ??
          (ativo ? widget.parent.corTextoAtivo : widget.parent.corTextoInativo),
      fontWeight: base.fontWeight ?? FontWeight.w500,
    );
  }

  Widget _buildConteudo(int index, bool ativo) {
    final personalizados = widget.parent.widgetsPersonalizados;
    if (personalizados != null && index < personalizados.length) {
      return personalizados[index];
    }

    final cor = ativo
        ? widget.parent.corTextoAtivo
        : widget.parent.corTextoInativo;
    final icones = widget.parent.icones;
    final icone = (icones != null && index < icones.length)
        ? icones[index]
        : null;
    final rotulos = widget.parent.rotulos;
    final rotulo = (rotulos != null && index < rotulos.length)
        ? rotulos[index]
        : null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: widget.parent.centralizarTexto
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        if (icone != null) ...[
          Icon(icone, size: widget.parent.tamanhoIcone, color: cor),
          if (rotulo != null) const SizedBox(width: 6),
        ],
        if (rotulo != null)
          Flexible(
            child: Text(
              rotulo,
              textAlign: widget.parent.centralizarTexto
                  ? TextAlign.center
                  : null,
              overflow: widget.parent.textoMultilinha
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              softWrap: widget.parent.textoMultilinha,
              maxLines: widget.parent.textoMultilinha ? null : 1,
              style: _resolverEstiloTexto(index, ativo),
            ),
          ),
      ],
    );
  }

  Widget _buildOpcao(int index, double raio, {required bool mostrarDivisor}) {
    final ativo = _selecionado == index;
    return GestureDetector(
      onTap: () => _aoTocar(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: (mostrarDivisor && widget.parent.corDivisor != null)
            ? BoxDecoration(
                border: widget.parent.vertical
                    ? Border(
                        bottom: BorderSide(
                          color: widget.parent.corDivisor!,
                          width: 1,
                        ),
                      )
                    : Border(
                        right: BorderSide(
                          color: widget.parent.corDivisor!,
                          width: 1,
                        ),
                      ),
              )
            : null,
        child: _buildConteudo(index, ativo),
      ),
    );
  }

  Widget _buildIndicador(
    double raio,
    double esquerda,
    double topo,
    double largura,
    double altura,
  ) {
    if (_selecionado == null) return const SizedBox.shrink();
    return AnimatedPositioned(
      duration: widget.parent.animar
          ? widget.parent.duracaoAnimacao
          : Duration.zero,
      curve: widget.parent.curvaAnimacao,
      left: esquerda,
      top: topo,
      width: largura,
      height: altura,
      child: Container(
        margin: EdgeInsets.all(widget.parent.larguraBorda),
        decoration: BoxDecoration(
          color: _resolverCorFundoAtivo(_selecionado!),
          borderRadius: BorderRadius.circular(raio),
        ),
      ),
    );
  }

  Widget _buildDivisaoIgual(int total, double raio) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final larguraDisponivel = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : widget.parent.larguraMinima * total;
        final larguraItem = widget.parent.vertical
            ? larguraDisponivel
            : larguraDisponivel / total;
        final alturaTotal = widget.parent.vertical
            ? widget.parent.altura * total
            : widget.parent.altura;

        return SizedBox(
          width: widget.parent.vertical ? larguraDisponivel : null,
          height: alturaTotal,
          child: Stack(
            children: [
              _buildIndicador(
                raio,
                widget.parent.vertical ? 0 : larguraItem * (_selecionado ?? 0),
                widget.parent.vertical
                    ? widget.parent.altura * (_selecionado ?? 0)
                    : 0,
                widget.parent.vertical ? larguraDisponivel : larguraItem,
                widget.parent.altura,
              ),
              Flex(
                direction: widget.parent.vertical
                    ? Axis.vertical
                    : Axis.horizontal,
                children: List.generate(total, (index) {
                  return SizedBox(
                    width: widget.parent.vertical
                        ? larguraDisponivel
                        : larguraItem,
                    height: widget.parent.altura,
                    child: _buildOpcao(
                      index,
                      raio,
                      mostrarDivisor: index < total - 1,
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLargurasFixas(int total, double raio) {
    final larguras = widget.parent.largurasPersonalizadas!;
    double larguraDe(int index) =>
        index < larguras.length ? larguras[index] : widget.parent.larguraMinima;

    final offsets = <double>[];
    var acumulado = 0.0;
    for (var i = 0; i < total; i++) {
      offsets.add(acumulado);
      acumulado += larguraDe(i);
    }

    final maiorLargura = List.generate(
      total,
      larguraDe,
    ).fold<double>(widget.parent.larguraMinima, (a, b) => a > b ? a : b);

    return SizedBox(
      width: widget.parent.vertical ? maiorLargura : acumulado,
      height: widget.parent.vertical ? acumulado : widget.parent.altura,
      child: Stack(
        children: [
          _buildIndicador(
            raio,
            widget.parent.vertical ? 0 : offsets[_selecionado ?? 0],
            widget.parent.vertical ? offsets[_selecionado ?? 0] : 0,
            widget.parent.vertical
                ? maiorLargura
                : larguraDe(_selecionado ?? 0),
            widget.parent.vertical
                ? larguraDe(_selecionado ?? 0)
                : widget.parent.altura,
          ),
          Flex(
            direction: widget.parent.vertical ? Axis.vertical : Axis.horizontal,
            children: List.generate(total, (index) {
              return SizedBox(
                width: widget.parent.vertical ? maiorLargura : larguraDe(index),
                height: widget.parent.vertical
                    ? larguraDe(index)
                    : widget.parent.altura,
                child: _buildOpcao(
                  index,
                  raio,
                  mostrarDivisor: index < total - 1,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _total;
    if (total == 0) return const SizedBox.shrink();

    final raio = widget.parent.estiloPilula
        ? widget.parent.altura / 2
        : widget.parent.raioCanto;

    return Directionality(
      textDirection: widget.parent.direitaParaEsquerda
          ? TextDirection.rtl
          : Directionality.of(context),
      child: Opacity(
        opacity: widget.parent.desabilitado ? 0.5 : 1,
        child: IgnorePointer(
          ignoring: widget.parent.desabilitado,
          child: Container(
            decoration: BoxDecoration(
              color: widget.parent.corFundoInativo,
              borderRadius: BorderRadius.circular(raio),
              border: widget.parent.corBorda != null
                  ? Border.all(
                      color: widget.parent.corBorda!,
                      width: widget.parent.larguraBorda == 0
                          ? 1
                          : widget.parent.larguraBorda,
                    )
                  : null,
              boxShadow: widget.parent.elevacao > 0
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: widget.parent.elevacao,
                        offset: Offset(0, widget.parent.elevacao / 3),
                      ),
                    ]
                  : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: widget.parent.largurasPersonalizadas != null
                ? _buildLargurasFixas(total, raio)
                : _buildDivisaoIgual(total, raio),
          ),
        ),
      ),
    );
  }
}
