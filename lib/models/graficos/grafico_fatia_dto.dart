import 'package:flutter/material.dart';

/// Uma fatia usada pelo gráfico de rosca/pizza.
class GraficoFatiaDTO {
  final String rotulo;
  final double valor;
  final Color? cor;

  const GraficoFatiaDTO({required this.rotulo, required this.valor, this.cor});
}
