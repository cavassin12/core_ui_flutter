import 'package:flutter/material.dart';

/// Breakpoints do grid, equivalentes aos do Bootstrap (`xs`, `sm`, `md`,
/// `lg`, `xl`, `xxl`). A resolução do breakpoint atual usa a largura
/// disponível para o [GridLinha] (via `LayoutBuilder`), não a largura da
/// tela inteira — o que torna o grid responsivo também dentro de painéis,
/// diálogos e outros containers menores que o viewport.
enum GridQuebra { xs, sm, md, lg, xl, xxl }

const List<GridQuebra> _ordemQuebrasDecrescente = [
  GridQuebra.xxl,
  GridQuebra.xl,
  GridQuebra.lg,
  GridQuebra.md,
  GridQuebra.sm,
  GridQuebra.xs,
];

const Map<GridQuebra, double> _larguraMinimaQuebra = {
  GridQuebra.xxl: 1400,
  GridQuebra.xl: 1200,
  GridQuebra.lg: 992,
  GridQuebra.md: 768,
  GridQuebra.sm: 576,
  GridQuebra.xs: 0,
};

T? _cascataMobileFirst<T>(GridQuebra quebra, Map<GridQuebra, T?> valores) {
  final indice = _ordemQuebrasDecrescente.indexOf(quebra);
  for (var i = indice; i < _ordemQuebrasDecrescente.length; i++) {
    final valor = valores[_ordemQuebrasDecrescente[i]];
    if (valor != null) return valor;
  }
  return null;
}

/// Uma coluna do grid, equivalente às classes `col`/`col-*`/`col-*-*` do
/// Bootstrap. Deve ser usada como filha direta de um [GridLinha].
///
/// Quando nenhum `colunas*` é informado, a coluna se comporta como o `.col`
/// "automático" do Bootstrap: divide igualmente, com as demais colunas
/// automáticas da mesma linha, o espaço que sobrar depois das colunas com
/// tamanho fixo.
///
/// Os parâmetros seguem a filosofia *mobile-first* do Bootstrap: um valor
/// definido em um breakpoint vale também para os breakpoints maiores, até
/// ser sobrescrito por um valor mais específico.
class GridColuna extends StatelessWidget {
  /// Conteúdo da coluna.
  final Widget filho;

  /// Número de colunas ocupadas a partir do breakpoint `xs` (equivalente a
  /// `col-*`). `null` = automático.
  final int? colunas;

  /// Sobrescreve [colunas] a partir do breakpoint `sm` (`col-sm-*`).
  final int? colunasSm;

  /// Sobrescreve [colunas] a partir do breakpoint `md` (`col-md-*`).
  final int? colunasMd;

  /// Sobrescreve [colunas] a partir do breakpoint `lg` (`col-lg-*`).
  final int? colunasLg;

  /// Sobrescreve [colunas] a partir do breakpoint `xl` (`col-xl-*`).
  final int? colunasXl;

  /// Sobrescreve [colunas] a partir do breakpoint `xxl` (`col-xxl-*`).
  final int? colunasXxl;

  /// Deslocamento (em número de colunas) antes desta coluna, a partir do
  /// breakpoint `xs` (equivalente a `offset-*`).
  final int? deslocamento;

  /// Sobrescreve [deslocamento] a partir do breakpoint `sm`.
  final int? deslocamentoSm;

  /// Sobrescreve [deslocamento] a partir do breakpoint `md`.
  final int? deslocamentoMd;

  /// Sobrescreve [deslocamento] a partir do breakpoint `lg`.
  final int? deslocamentoLg;

  /// Sobrescreve [deslocamento] a partir do breakpoint `xl`.
  final int? deslocamentoXl;

  /// Sobrescreve [deslocamento] a partir do breakpoint `xxl`.
  final int? deslocamentoXxl;

  /// Posição de exibição da coluna dentro da linha, a partir do breakpoint
  /// `xs` (equivalente a `order-*`). Colunas com `ordem` menor aparecem
  /// primeiro; em caso de empate, mantém a ordem original.
  final int? ordem;

  /// Sobrescreve [ordem] a partir do breakpoint `sm`.
  final int? ordemSm;

  /// Sobrescreve [ordem] a partir do breakpoint `md`.
  final int? ordemMd;

  /// Sobrescreve [ordem] a partir do breakpoint `lg`.
  final int? ordemLg;

  /// Sobrescreve [ordem] a partir do breakpoint `xl`.
  final int? ordemXl;

  /// Sobrescreve [ordem] a partir do breakpoint `xxl`.
  final int? ordemXxl;

  const GridColuna({
    super.key,
    required this.filho,
    this.colunas,
    this.colunasSm,
    this.colunasMd,
    this.colunasLg,
    this.colunasXl,
    this.colunasXxl,
    this.deslocamento,
    this.deslocamentoSm,
    this.deslocamentoMd,
    this.deslocamentoLg,
    this.deslocamentoXl,
    this.deslocamentoXxl,
    this.ordem,
    this.ordemSm,
    this.ordemMd,
    this.ordemLg,
    this.ordemXl,
    this.ordemXxl,
  });

  int? _resolverColunas(GridQuebra quebra) => _cascataMobileFirst(quebra, {
    GridQuebra.xxl: colunasXxl,
    GridQuebra.xl: colunasXl,
    GridQuebra.lg: colunasLg,
    GridQuebra.md: colunasMd,
    GridQuebra.sm: colunasSm,
    GridQuebra.xs: colunas,
  });

  int _resolverDeslocamento(GridQuebra quebra) =>
      _cascataMobileFirst(quebra, {
        GridQuebra.xxl: deslocamentoXxl,
        GridQuebra.xl: deslocamentoXl,
        GridQuebra.lg: deslocamentoLg,
        GridQuebra.md: deslocamentoMd,
        GridQuebra.sm: deslocamentoSm,
        GridQuebra.xs: deslocamento,
      }) ??
      0;

  int _resolverOrdem(GridQuebra quebra) =>
      _cascataMobileFirst(quebra, {
        GridQuebra.xxl: ordemXxl,
        GridQuebra.xl: ordemXl,
        GridQuebra.lg: ordemLg,
        GridQuebra.md: ordemMd,
        GridQuebra.sm: ordemSm,
        GridQuebra.xs: ordem,
      }) ??
      0;

  @override
  Widget build(BuildContext context) => filho;
}

class _ColunaResolvida {
  final GridColuna coluna;
  final int span; // 0 = automático
  final int deslocamento;
  final int ordem;

  _ColunaResolvida(this.coluna, this.span, this.deslocamento, this.ordem);
}

/// Uma linha do grid, equivalente à classe `row` do Bootstrap. Organiza seus
/// [filhos] (idealmente [GridColuna]s) em um sistema de colunas responsivo
/// que quebra automaticamente para uma nova linha quando a soma das colunas
/// ultrapassa [totalColunas].
///
/// Uso básico:
/// ```dart
/// GridLinha(
///   filhos: const [
///     GridColuna(colunas: 12, colunasMd: 6, filho: Text('Coluna A')),
///     GridColuna(colunas: 12, colunasMd: 6, filho: Text('Coluna B')),
///   ],
/// )
/// ```
class GridLinha extends StatelessWidget {
  /// Widgets da linha — idealmente [GridColuna]s. Widgets que não sejam
  /// [GridColuna] são tratados como uma coluna automática (`.col`).
  final List<Widget> filhos;

  /// Número total de colunas do grid (equivalente à variável Sass
  /// `$grid-columns` do Bootstrap, cujo padrão também é `12`).
  final int totalColunas;

  /// Espaçamento horizontal entre colunas (gutter). É descontado da largura
  /// disponível antes de calcular a largura de cada coluna — as bordas
  /// esquerda e direita da linha não recebem gutter, apenas o espaço entre
  /// colunas consecutivas.
  final double espacamentoHorizontal;

  /// Espaçamento vertical entre linhas, quando o conteúdo quebra para uma
  /// nova linha por exceder [totalColunas].
  final double espacamentoVertical;

  /// Alinhamento horizontal das colunas dentro de cada linha (equivalente a
  /// `justify-content-*`).
  final MainAxisAlignment alinhamentoHorizontal;

  /// Alinhamento vertical das colunas dentro de cada linha (equivalente a
  /// `align-items-*`). O padrão `stretch` faz as colunas ocuparem a mesma
  /// altura, igual ao comportamento padrão do Bootstrap.
  final CrossAxisAlignment alinhamentoVertical;

  /// Inverte a ordem visual das colunas (equivalente a
  /// `flex-row-reverse`).
  final bool reverter;

  const GridLinha({
    super.key,
    required this.filhos,
    this.totalColunas = 12,
    this.espacamentoHorizontal = 24.0,
    this.espacamentoVertical = 24.0,
    this.alinhamentoHorizontal = MainAxisAlignment.start,
    this.alinhamentoVertical = CrossAxisAlignment.stretch,
    this.reverter = false,
  }) : assert(totalColunas > 0, 'totalColunas deve ser >= 1');

  GridQuebra _resolverQuebra(double largura) {
    for (final quebra in _ordemQuebrasDecrescente) {
      if (largura >= _larguraMinimaQuebra[quebra]!) return quebra;
    }
    return GridQuebra.xs;
  }

  List<List<_ColunaResolvida>> _quebrarEmLinhas(
    List<_ColunaResolvida> itens,
  ) {
    final linhas = <List<_ColunaResolvida>>[];
    var linhaAtual = <_ColunaResolvida>[];
    var somaAtual = 0;

    for (final item in itens) {
      final custo = item.span == 0 ? 0 : item.span + item.deslocamento;
      if (item.span != 0 &&
          somaAtual + custo > totalColunas &&
          linhaAtual.isNotEmpty) {
        linhas.add(linhaAtual);
        linhaAtual = [];
        somaAtual = 0;
      }
      linhaAtual.add(item);
      somaAtual += custo;
    }
    if (linhaAtual.isNotEmpty) linhas.add(linhaAtual);
    return linhas;
  }

  double _slotsAutomaticos(List<_ColunaResolvida> linha) {
    final autos = linha.where((c) => c.span == 0).length;
    if (autos == 0) return 0;
    final somaFixa = linha.fold<int>(
      0,
      (soma, c) => soma + (c.span == 0 ? 0 : c.span) + c.deslocamento,
    );
    final restante = (totalColunas - somaFixa).clamp(0, totalColunas);
    return restante / autos;
  }

  Widget _buildLinha(List<_ColunaResolvida> linha, double larguraDisponivel) {
    final gutterTotal = espacamentoHorizontal * (linha.length - 1);
    final larguraPorSlot = (larguraDisponivel - gutterTotal) / totalColunas;
    final slotsAuto = _slotsAutomaticos(linha);
    final children = <Widget>[];

    for (var i = 0; i < linha.length; i++) {
      final item = linha[i];
      if (i > 0) children.add(SizedBox(width: espacamentoHorizontal));
      if (item.deslocamento > 0) {
        children.add(SizedBox(width: larguraPorSlot * item.deslocamento));
      }
      final slots = item.span == 0 ? slotsAuto : item.span.toDouble();
      children.add(
        SizedBox(width: larguraPorSlot * slots, child: item.coluna.filho),
      );
    }

    final linhaWidget = Row(
      mainAxisAlignment: alinhamentoHorizontal,
      crossAxisAlignment: alinhamentoVertical,
      textDirection: reverter ? TextDirection.rtl : null,
      children: children,
    );

    // `stretch` exige que o Row conheça sua própria altura antes de esticar
    // os filhos; `IntrinsicHeight` resolve isso sem depender de restrições
    // de altura vindas do widget pai (que costumam ser não-limitadas).
    if (alinhamentoVertical == CrossAxisAlignment.stretch) {
      return IntrinsicHeight(child: linhaWidget);
    }
    return linhaWidget;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final largura = constraints.maxWidth;
        final quebra = _resolverQuebra(largura);

        final resolvidas = filhos.map((filho) {
          final coluna = filho is GridColuna
              ? filho
              : GridColuna(filho: filho);
          return _ColunaResolvida(
            coluna,
            coluna._resolverColunas(quebra) ?? 0,
            coluna._resolverDeslocamento(quebra),
            coluna._resolverOrdem(quebra),
          );
        }).toList();

        final ordenadas = List<_ColunaResolvida>.from(resolvidas)
          ..sort((a, b) => a.ordem.compareTo(b.ordem));

        final linhas = _quebrarEmLinhas(ordenadas);

        final widgetsLinhas = <Widget>[];
        for (var i = 0; i < linhas.length; i++) {
          if (i > 0 && espacamentoVertical > 0) {
            widgetsLinhas.add(SizedBox(height: espacamentoVertical));
          }
          widgetsLinhas.add(_buildLinha(linhas[i], largura));
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgetsLinhas,
        );
      },
    );
  }
}
