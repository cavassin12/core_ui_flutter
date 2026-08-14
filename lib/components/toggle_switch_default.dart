import 'package:flutter/material.dart';

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
class ToggleSwitchDefault extends StatefulWidget {
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

  @override
  State<ToggleSwitchDefault> createState() => _ToggleSwitchDefaultState();
}

class _ToggleSwitchDefaultState extends State<ToggleSwitchDefault> {
  late int? _selecionado;

  @override
  void initState() {
    super.initState();
    _selecionado = widget.indiceInicial;
  }

  @override
  void didUpdateWidget(covariant ToggleSwitchDefault oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.indiceInicial != oldWidget.indiceInicial) {
      _selecionado = widget.indiceInicial;
    }
  }

  int get _total =>
      widget.totalOpcoes ??
      widget.rotulos?.length ??
      widget.icones?.length ??
      widget.widgetsPersonalizados?.length ??
      0;

  Future<void> _aoTocar(int index) async {
    if (widget.desabilitado) return;

    if (_selecionado == index) {
      if (!widget.permitirDesselecionar) return;
      if (widget.ignorarToqueRepetido) return;
    }

    final desmarcando = _selecionado == index && widget.permitirDesselecionar;
    final novoIndice = desmarcando ? null : index;

    if (widget.cancelarAlternancia != null) {
      final podeAlternar = await widget.cancelarAlternancia!(
        _selecionado,
        index,
      );
      if (!podeAlternar) return;
    }

    setState(() => _selecionado = novoIndice);
    widget.aoAlternar?.call(novoIndice);
  }

  Color _resolverCorFundoAtivo(int index) {
    final cores = widget.coresFundoAtivo;
    if (cores != null && index < cores.length) return cores[index];
    return widget.corFundoAtivo;
  }

  TextStyle _resolverEstiloTexto(int index, bool ativo) {
    final estilos = widget.estilosTextoPersonalizados;
    final base = (estilos != null && index < estilos.length)
        ? estilos[index]
        : TextStyle(fontSize: widget.tamanhoFonte);
    return base.copyWith(
      color: base.color ?? (ativo ? widget.corTextoAtivo : widget.corTextoInativo),
      fontWeight: base.fontWeight ?? FontWeight.w500,
    );
  }

  Widget _buildConteudo(int index, bool ativo) {
    final personalizados = widget.widgetsPersonalizados;
    if (personalizados != null && index < personalizados.length) {
      return personalizados[index];
    }

    final cor = ativo ? widget.corTextoAtivo : widget.corTextoInativo;
    final icones = widget.icones;
    final icone = (icones != null && index < icones.length)
        ? icones[index]
        : null;
    final rotulos = widget.rotulos;
    final rotulo = (rotulos != null && index < rotulos.length)
        ? rotulos[index]
        : null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: widget.centralizarTexto
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        if (icone != null) ...[
          Icon(icone, size: widget.tamanhoIcone, color: cor),
          if (rotulo != null) const SizedBox(width: 6),
        ],
        if (rotulo != null)
          Flexible(
            child: Text(
              rotulo,
              textAlign: widget.centralizarTexto ? TextAlign.center : null,
              overflow: widget.textoMultilinha
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              softWrap: widget.textoMultilinha,
              maxLines: widget.textoMultilinha ? null : 1,
              style: _resolverEstiloTexto(index, ativo),
            ),
          ),
      ],
    );
  }

  Widget _buildOpcao(
    int index,
    double raio, {
    required bool mostrarDivisor,
  }) {
    final ativo = _selecionado == index;
    return GestureDetector(
      onTap: () => _aoTocar(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: (mostrarDivisor && widget.corDivisor != null)
            ? BoxDecoration(
                border: widget.vertical
                    ? Border(
                        bottom: BorderSide(
                          color: widget.corDivisor!,
                          width: 1,
                        ),
                      )
                    : Border(
                        right: BorderSide(color: widget.corDivisor!, width: 1),
                      ),
              )
            : null,
        child: _buildConteudo(index, ativo),
      ),
    );
  }

  Widget _buildIndicador(double raio, double esquerda, double topo, double largura, double altura) {
    if (_selecionado == null) return const SizedBox.shrink();
    return AnimatedPositioned(
      duration: widget.animar ? widget.duracaoAnimacao : Duration.zero,
      curve: widget.curvaAnimacao,
      left: esquerda,
      top: topo,
      width: largura,
      height: altura,
      child: Container(
        margin: EdgeInsets.all(widget.larguraBorda),
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
            : widget.larguraMinima * total;
        final larguraItem = widget.vertical
            ? larguraDisponivel
            : larguraDisponivel / total;
        final alturaTotal = widget.vertical
            ? widget.altura * total
            : widget.altura;

        return SizedBox(
          width: widget.vertical ? larguraDisponivel : null,
          height: alturaTotal,
          child: Stack(
            children: [
              _buildIndicador(
                raio,
                widget.vertical ? 0 : larguraItem * (_selecionado ?? 0),
                widget.vertical ? widget.altura * (_selecionado ?? 0) : 0,
                widget.vertical ? larguraDisponivel : larguraItem,
                widget.altura,
              ),
              Flex(
                direction: widget.vertical ? Axis.vertical : Axis.horizontal,
                children: List.generate(total, (index) {
                  return SizedBox(
                    width: widget.vertical ? larguraDisponivel : larguraItem,
                    height: widget.altura,
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
    final larguras = widget.largurasPersonalizadas!;
    double larguraDe(int index) =>
        index < larguras.length ? larguras[index] : widget.larguraMinima;

    final offsets = <double>[];
    var acumulado = 0.0;
    for (var i = 0; i < total; i++) {
      offsets.add(acumulado);
      acumulado += larguraDe(i);
    }

    final maiorLargura = List.generate(
      total,
      larguraDe,
    ).fold<double>(widget.larguraMinima, (a, b) => a > b ? a : b);

    return SizedBox(
      width: widget.vertical ? maiorLargura : acumulado,
      height: widget.vertical ? acumulado : widget.altura,
      child: Stack(
        children: [
          _buildIndicador(
            raio,
            widget.vertical ? 0 : offsets[_selecionado ?? 0],
            widget.vertical ? offsets[_selecionado ?? 0] : 0,
            widget.vertical ? maiorLargura : larguraDe(_selecionado ?? 0),
            widget.vertical ? larguraDe(_selecionado ?? 0) : widget.altura,
          ),
          Flex(
            direction: widget.vertical ? Axis.vertical : Axis.horizontal,
            children: List.generate(total, (index) {
              return SizedBox(
                width: widget.vertical ? maiorLargura : larguraDe(index),
                height: widget.vertical ? larguraDe(index) : widget.altura,
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

    final raio = widget.estiloPilula ? widget.altura / 2 : widget.raioCanto;

    return Directionality(
      textDirection: widget.direitaParaEsquerda
          ? TextDirection.rtl
          : Directionality.of(context),
      child: Opacity(
        opacity: widget.desabilitado ? 0.5 : 1,
        child: IgnorePointer(
          ignoring: widget.desabilitado,
          child: Container(
            decoration: BoxDecoration(
              color: widget.corFundoInativo,
              borderRadius: BorderRadius.circular(raio),
              border: widget.corBorda != null
                  ? Border.all(
                      color: widget.corBorda!,
                      width: widget.larguraBorda == 0 ? 1 : widget.larguraBorda,
                    )
                  : null,
              boxShadow: widget.elevacao > 0
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: widget.elevacao,
                        offset: Offset(0, widget.elevacao / 3),
                      ),
                    ]
                  : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: widget.largurasPersonalizadas != null
                ? _buildLargurasFixas(total, raio)
                : _buildDivisaoIgual(total, raio),
          ),
        ),
      ),
    );
  }
}
