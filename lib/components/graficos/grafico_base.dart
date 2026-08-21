import 'package:flutter/material.dart';

import '../../code_design_system_theme.dart';
import '../../types/grafico_legenda_posicao.dart';

const _coresGraficosFallback = [
  Color(0xFF2563EB),
  Color(0xFF0D9488),
  Color(0xFF7C3AED),
  Color(0xFFEA580C),
  Color(0xFFDB2777),
  Color(0xFF0891B2),
];

List<Color> coresGraficos(BuildContext context, List<Color>? cores) {
  if (cores != null && cores.isNotEmpty) return cores;
  final design = context.design;
  return [
    design.corPrimaria,
    design.corSucesso,
    const Color(0xFF7C3AED),
    design.corAviso,
    const Color(0xFFDB2777),
    design.corInfo,
  ];
}

Color corGrafico(List<Color> cores, int indice) => cores.isEmpty
    ? _coresGraficosFallback[indice % _coresGraficosFallback.length]
    : cores[indice % cores.length];

String formatarNumeroGrafico(double valor) {
  if (valor == valor.roundToDouble()) return valor.toInt().toString();
  return valor.toStringAsFixed(1).replaceAll('.', ',');
}

class GraficoBase extends StatelessWidget {
  final String? titulo;
  final String? subtitulo;
  final double altura;
  final bool vazio;
  final String mensagemVazio;
  final Widget grafico;
  final List<(String, Color)> legendas;
  final GraficoLegendaPosicao posicaoLegenda;
  final String descricaoSemantica;

  const GraficoBase({
    super.key,
    this.titulo,
    this.subtitulo,
    required this.altura,
    required this.vazio,
    required this.mensagemVazio,
    required this.grafico,
    this.legendas = const [],
    this.posicaoLegenda = GraficoLegendaPosicao.inferior,
    required this.descricaoSemantica,
  });

  @override
  Widget build(BuildContext context) {
    final design = context.design;
    final legenda = _LegendaGrafico(itens: legendas);

    return Semantics(
      container: true,
      label: descricaoSemantica,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (titulo != null)
            Text(
              titulo!,
              style: TextStyle(
                color: design.corTexto,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (subtitulo != null) ...[
            const SizedBox(height: 3),
            Text(
              subtitulo!,
              style: TextStyle(
                color: design.corTextoSecundario,
                fontSize: 12.5,
              ),
            ),
          ],
          if ((titulo != null || subtitulo != null) &&
              posicaoLegenda == GraficoLegendaPosicao.superior)
            const SizedBox(height: 12),
          if (posicaoLegenda == GraficoLegendaPosicao.superior) legenda,
          if (titulo != null ||
              subtitulo != null ||
              posicaoLegenda == GraficoLegendaPosicao.superior)
            const SizedBox(height: 14),
          SizedBox(
            height: altura,
            child: vazio
                ? Center(
                    child: Text(
                      mensagemVazio,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: design.corTextoSecundario),
                    ),
                  )
                : grafico,
          ),
          if (posicaoLegenda == GraficoLegendaPosicao.inferior &&
              legendas.isNotEmpty) ...[
            const SizedBox(height: 14),
            legenda,
          ],
        ],
      ),
    );
  }
}

class _LegendaGrafico extends StatelessWidget {
  final List<(String, Color)> itens;

  const _LegendaGrafico({required this.itens});

  @override
  Widget build(BuildContext context) {
    if (itens.isEmpty) return const SizedBox.shrink();
    final design = context.design;
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        for (final item in itens)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: item.$2,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                item.$1,
                style: TextStyle(
                  color: design.corTextoSecundario,
                  fontSize: 12,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
