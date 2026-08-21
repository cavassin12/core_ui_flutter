import 'package:flutter/material.dart';

/// Faixa de valores exibida no fundo do gráfico indicador.
class GraficoFaixaDTO {
  final double inicio;
  final double fim;
  final Color cor;
  final String? rotulo;

  const GraficoFaixaDTO({
    required this.inicio,
    required this.fim,
    required this.cor,
    this.rotulo,
  });
}
