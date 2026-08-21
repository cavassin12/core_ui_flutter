/// Um ponto cartesiano compartilhado pelos gráficos de linha e barras.
class GraficoPontoDTO {
  final double x;
  final double valor;
  final String? rotulo;

  const GraficoPontoDTO({required this.x, required this.valor, this.rotulo});
}
