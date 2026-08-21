import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../code_design_system_theme.dart';
import '../../core/platform_widget.dart';
import '../../models/graficos/grafico_selecao_dto.dart';
import '../../models/graficos/grafico_serie_dto.dart';
import '../../types/grafico_legenda_posicao.dart';
import 'grafico_base.dart';

class GraficoLinhaDefault extends PlatformWidget {
  final List<GraficoSerieDTO> series;
  final String? titulo;
  final String? subtitulo;
  final double altura;
  final bool curvo;
  final bool exibirPontos;
  final bool preencherArea;
  final bool exibirGrade;
  final bool exibirTooltip;
  final List<Color>? cores;
  final GraficoLegendaPosicao posicaoLegenda;
  final String mensagemVazio;
  final String Function(double valor)? formatadorValor;
  final GraficoAoSelecionar? aoSelecionar;

  const GraficoLinhaDefault({
    super.key,
    required this.series,
    this.titulo,
    this.subtitulo,
    this.altura = 280,
    this.curvo = true,
    this.exibirPontos = true,
    this.preencherArea = false,
    this.exibirGrade = true,
    this.exibirTooltip = true,
    this.cores,
    this.posicaoLegenda = GraficoLegendaPosicao.inferior,
    this.mensagemVazio = 'Nenhum dado disponível.',
    this.formatadorValor,
    this.aoSelecionar,
  });

  @override
  Widget createAndroidWidget(BuildContext context) => _build(context);

  @override
  Widget createIosWidget(BuildContext context) => _build(context);

  Widget _build(BuildContext context) {
    final design = context.design;
    final paleta = coresGraficos(context, cores);
    final seriesValidas = series
        .where((serie) => serie.pontos.isNotEmpty)
        .toList();
    final legendas = <(String, Color)>[
      for (var i = 0; i < seriesValidas.length; i++)
        (seriesValidas[i].nome, seriesValidas[i].cor ?? corGrafico(paleta, i)),
    ];

    return GraficoBase(
      titulo: titulo,
      subtitulo: subtitulo,
      altura: altura,
      vazio: seriesValidas.isEmpty,
      mensagemVazio: mensagemVazio,
      posicaoLegenda: posicaoLegenda,
      legendas: legendas,
      descricaoSemantica: titulo ?? 'Gráfico de linhas',
      grafico: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: exibirGrade,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: design.corBorda, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: _titulos(context, seriesValidas),
          lineTouchData: LineTouchData(
            enabled: exibirTooltip || aoSelecionar != null,
            handleBuiltInTouches: exibirTooltip,
            touchCallback: (evento, resposta) {
              if (evento is! FlTapUpEvent || aoSelecionar == null) return;
              final ponto = resposta?.lineBarSpots?.firstOrNull;
              if (ponto == null) return;
              final serie = seriesValidas[ponto.barIndex];
              final dado = serie.pontos[ponto.spotIndex];
              aoSelecionar!(
                GraficoSelecaoDTO(
                  indiceSerie: ponto.barIndex,
                  indiceItem: ponto.spotIndex,
                  serie: serie.nome,
                  rotulo: dado.rotulo ?? formatarNumeroGrafico(dado.x),
                  valor: dado.valor,
                ),
              );
            },
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => design.corNavbar,
              getTooltipItems: (pontos) => pontos.map((ponto) {
                final serie = seriesValidas[ponto.barIndex];
                return LineTooltipItem(
                  '${serie.nome}\n${_formatar(ponto.y)}',
                  TextStyle(
                    color: design.corNavbarTexto,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList(),
            ),
          ),
          lineBarsData: [
            for (var i = 0; i < seriesValidas.length; i++)
              LineChartBarData(
                spots: [
                  for (final ponto in seriesValidas[i].pontos)
                    FlSpot(ponto.x, ponto.valor),
                ],
                color: seriesValidas[i].cor ?? corGrafico(paleta, i),
                isCurved: curvo,
                barWidth: 3,
                dotData: FlDotData(show: exibirPontos),
                belowBarData: BarAreaData(
                  show: preencherArea,
                  color: (seriesValidas[i].cor ?? corGrafico(paleta, i))
                      .withValues(alpha: .12),
                ),
              ),
          ],
        ),
        duration: const Duration(milliseconds: 350),
      ),
    );
  }

  FlTitlesData _titulos(BuildContext context, List<GraficoSerieDTO> validas) {
    final design = context.design;
    final rotulos = <double, String>{
      if (validas.isNotEmpty)
        for (final ponto in validas.first.pontos)
          if (ponto.rotulo != null) ponto.x: ponto.rotulo!,
    };
    final estilo = TextStyle(color: design.corTextoSecundario, fontSize: 11);
    return FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 42,
          getTitlesWidget: (v, _) => Text(_formatar(v), style: estilo),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (v, _) => Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(rotulos[v] ?? '', style: estilo),
          ),
        ),
      ),
    );
  }

  String _formatar(double valor) =>
      formatadorValor?.call(valor) ?? formatarNumeroGrafico(valor);
}
