/// Porte simplificado de `TableLazyLoadEvent` (primeng/table), usado pelo `[lazy]="true"`
/// do PrimeNG no componente original. Mantém apenas os campos que o restante do código
/// deste projeto de fato lê (`first`/`rows`, para calcular a página a buscar) — o original
/// do PrimeNG também carrega `sortField`/`filters`/etc., sem uso aqui.
class TableLazyLoadEvent {
  /// Índice (0-based) do primeiro registro da página.
  final int first;

  /// Quantidade de registros por página.
  final int rows;

  const TableLazyLoadEvent({required this.first, required this.rows});
}
