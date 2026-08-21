/// Informação emitida ao selecionar um ponto, barra ou fatia.
class GraficoSelecaoDTO {
  final int indiceSerie;
  final int indiceItem;
  final String serie;
  final String rotulo;
  final double valor;

  const GraficoSelecaoDTO({
    required this.indiceSerie,
    required this.indiceItem,
    required this.serie,
    required this.rotulo,
    required this.valor,
  });
}

typedef GraficoAoSelecionar = void Function(GraficoSelecaoDTO selecao);
