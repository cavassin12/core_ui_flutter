import 'package:flutter/material.dart';

import '../code_design_system_theme.dart';
import '../core/platform_widget.dart';
import '../types/pagination_size_default.dart';

/// Componente único de paginação avulsa, equivalente ao `.pagination` do
/// Bootstrap: botões de anterior/próxima, números de página (com janela
/// deslizante ao redor da página atual) e botões opcionais de
/// primeira/última página.
///
/// Diferente da paginação embutida no `TableGrid` (que só mostra "Página X
/// de Y" + anterior/próxima), este componente é standalone e pode ser usado
/// em qualquer lista/tela que precise de paginação.
///
/// Estende `PlatformWidget`, mas usa a mesma implementação em todas as
/// plataformas — uma paginação não tem uma variação visual nativa relevante
/// entre Android/iOS/Web/Windows.
///
/// Uso básico:
/// ```dart
/// PaginationDefault(
///   paginaAtual: pagina,
///   totalPaginas: totalPaginas,
///   aoMudarPagina: (novaPagina) => setState(() => pagina = novaPagina),
/// )
/// ```
class PaginationDefault extends PlatformWidget {
  /// Página atualmente selecionada (1-based).
  final int paginaAtual;

  /// Total de páginas disponíveis.
  final int totalPaginas;

  /// Chamado ao selecionar uma nova página (por número, anterior, próxima,
  /// primeira ou última).
  final ValueChanged<int> aoMudarPagina;

  /// Exibe os botões numéricos de página. Quando `false`, exibe apenas
  /// "página atual / total" entre os botões de anterior/próxima.
  final bool mostrarNumeros;

  /// Quantidade máxima de botões numéricos exibidos simultaneamente — a
  /// janela desliza para manter [paginaAtual] visível, sempre que possível
  /// centralizada.
  final int maxBotoesNumericos;

  /// Exibe botões de pular para a primeira e para a última página.
  final bool mostrarPrimeiraUltima;

  /// Tamanho dos botões.
  final PaginationSizeDefault tamanho;

  /// Alinhamento horizontal do conjunto de botões dentro do espaço
  /// disponível (o widget ocupa toda a largura do pai).
  final MainAxisAlignment alinhamento;

  const PaginationDefault({
    super.key,
    required this.paginaAtual,
    required this.totalPaginas,
    required this.aoMudarPagina,
    this.mostrarNumeros = true,
    this.maxBotoesNumericos = 5,
    this.mostrarPrimeiraUltima = false,
    this.tamanho = PaginationSizeDefault.normal,
    this.alinhamento = MainAxisAlignment.center,
  }) : assert(paginaAtual >= 1, 'paginaAtual deve ser >= 1'),
       assert(totalPaginas >= 1, 'totalPaginas deve ser >= 1'),
       assert(maxBotoesNumericos >= 1, 'maxBotoesNumericos deve ser >= 1');

  double get _tamanhoBotao {
    switch (tamanho) {
      case PaginationSizeDefault.small:
        return 28.0;
      case PaginationSizeDefault.normal:
        return 36.0;
      case PaginationSizeDefault.large:
        return 44.0;
    }
  }

  double get _fontSize {
    switch (tamanho) {
      case PaginationSizeDefault.small:
        return 12.0;
      case PaginationSizeDefault.normal:
        return 14.0;
      case PaginationSizeDefault.large:
        return 16.0;
    }
  }

  /// Janela de números de página exibida ao redor de [paginaAtual],
  /// recortada aos limites `[1, totalPaginas]`.
  List<int> _paginasVisiveis() {
    if (totalPaginas <= maxBotoesNumericos) {
      return List.generate(totalPaginas, (i) => i + 1);
    }

    var inicio = paginaAtual - (maxBotoesNumericos ~/ 2);
    var fim = inicio + maxBotoesNumericos - 1;

    if (inicio < 1) {
      fim += (1 - inicio);
      inicio = 1;
    }
    if (fim > totalPaginas) {
      inicio -= (fim - totalPaginas);
      fim = totalPaginas;
    }
    inicio = inicio < 1 ? 1 : inicio;

    return List.generate(fim - inicio + 1, (i) => inicio + i);
  }

  Widget _buildBotao(
    BuildContext context, {
    required Widget child,
    required bool habilitado,
    required bool ativo,
    required VoidCallback? onTap,
  }) {
    final design = context.design;
    final theme = Theme.of(context);
    final tamanhoBotao = _tamanhoBotao;

    final corFundo = ativo ? design.corPrimaria : Colors.transparent;
    final corTexto = ativo
        ? Colors.white
        : (habilitado
              ? theme.textTheme.bodyMedium?.color
              : theme.disabledColor);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: corFundo,
        borderRadius: BorderRadius.circular(design.raioBorda),
        child: InkWell(
          onTap: habilitado ? onTap : null,
          borderRadius: BorderRadius.circular(design.raioBorda),
          child: Container(
            constraints: BoxConstraints(
              minWidth: tamanhoBotao,
              minHeight: tamanhoBotao,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            alignment: Alignment.center,
            child: IconTheme.merge(
              data: IconThemeData(size: _fontSize + 4, color: corTexto),
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  fontSize: _fontSize,
                  color: corTexto,
                  fontWeight: ativo ? FontWeight.w700 : FontWeight.w500,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _build(BuildContext context) {
    final podeAnterior = paginaAtual > 1;
    final podeProxima = paginaAtual < totalPaginas;

    final botoes = <Widget>[
      if (mostrarPrimeiraUltima)
        _buildBotao(
          context,
          child: const Icon(Icons.first_page),
          habilitado: podeAnterior,
          ativo: false,
          onTap: () => aoMudarPagina(1),
        ),
      _buildBotao(
        context,
        child: const Icon(Icons.chevron_left),
        habilitado: podeAnterior,
        ativo: false,
        onTap: () => aoMudarPagina(paginaAtual - 1),
      ),
      if (mostrarNumeros)
        for (final pagina in _paginasVisiveis())
          _buildBotao(
            context,
            child: Text('$pagina'),
            habilitado: true,
            ativo: pagina == paginaAtual,
            onTap: () => aoMudarPagina(pagina),
          )
      else
        _buildBotao(
          context,
          child: Text('$paginaAtual / $totalPaginas'),
          habilitado: false,
          ativo: false,
          onTap: null,
        ),
      _buildBotao(
        context,
        child: const Icon(Icons.chevron_right),
        habilitado: podeProxima,
        ativo: false,
        onTap: () => aoMudarPagina(paginaAtual + 1),
      ),
      if (mostrarPrimeiraUltima)
        _buildBotao(
          context,
          child: const Icon(Icons.last_page),
          habilitado: podeProxima,
          ativo: false,
          onTap: () => aoMudarPagina(totalPaginas),
        ),
    ];

    return Row(mainAxisAlignment: alinhamento, children: botoes);
  }

  @override
  Widget createAndroidWidget(BuildContext context) => _build(context);

  @override
  Widget createIosWidget(BuildContext context) => _build(context);
}
