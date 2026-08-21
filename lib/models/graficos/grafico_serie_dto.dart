import 'package:flutter/material.dart';

import 'grafico_ponto_dto.dart';

/// Série nomeada de dados cartesianos.
class GraficoSerieDTO {
  final String nome;
  final List<GraficoPontoDTO> pontos;
  final Color? cor;

  const GraficoSerieDTO({required this.nome, required this.pontos, this.cor});
}
