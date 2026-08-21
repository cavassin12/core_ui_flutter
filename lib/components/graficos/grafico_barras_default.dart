import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../code_design_system_theme.dart';
import '../../core/platform_widget.dart';
import '../../models/graficos/grafico_selecao_dto.dart';
import '../../models/graficos/grafico_serie_dto.dart';
import '../../types/grafico_barras_modo.dart';
import '../../types/grafico_barras_orientacao.dart';
import '../../types/grafico_legenda_posicao.dart';
import 'grafico_base.dart';

class GraficoBarrasDefault extends PlatformWidget {
  final List<GraficoSerieDTO> series;
  final String? titulo;
  final String? subtitulo;
  final double altura;
  final GraficoBarrasModo modo;
  final GraficoBarrasOrientacao orientacao;
  final GraficoLegendaPosicao posicaoLegenda;
  final bool exibirGrade;
  final bool exibirTooltip;
  final double larguraBarra;
  final List<Color>? cores;
  final String mensagemVazio;
  final String Function(double valor)? formatadorValor;
  final GraficoAoSelecionar? aoSelecionar;

  const GraficoBarrasDefault({
    super.key,
    required this.series,
    this.titulo,
    this.subtitulo,
    this.altura = 280,
    this.modo = GraficoBarrasModo.agrupado,
    this.orientacao = GraficoBarrasOrientacao.vertical,
    this.posicaoLegenda = GraficoLegendaPosicao.inferior,
    this.exibirGrade = true,
    this.exibirTooltip = true,
    this.larguraBarra = 16,
    this.cores,
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
    final validas = series.where((s) => s.pontos.isNotEmpty).toList();
    final paleta = coresGraficos(context, cores);
    final quantidade = validas.fold<int>(
      0,
      (maximo, s) => s.pontos.length > maximo ? s.pontos.length : maximo,
    );
    final legendas = <(String, Color)>[
      for (var i = 0; i < validas.length; i++)
        (validas[i].nome, validas[i].cor ?? corGrafico(paleta, i)),
    ];

    return GraficoBase(
      titulo: titulo,
      subtitulo: subtitulo,
      altura: altura,
      vazio: validas.isEmpty,
      mensagemVazio: mensagemVazio,
      legendas: legendas,
      posicaoLegenda: posicaoLegenda,
      descricaoSemantica: titulo ?? 'Gráfico de barras',
      grafico: BarChart(
        BarChartData(
          rotationQuarterTurns: orientacao == GraficoBarrasOrientacao.horizontal
              ? 1
              : 0,
          alignment: BarChartAlignment.spaceAround,
          gridData: FlGridData(
            show: exibirGrade,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(color: design.corBorda),
          ),
          borderData: FlBorderData(show: false),
          titlesData: _titulos(context, validas),
          barTouchData: BarTouchData(
            enabled: exibirTooltip || aoSelecionar != null,
            handleBuiltInTouches: exibirTooltip,
            touchCallback: (evento, resposta) {
              if (evento is! FlTapUpEvent || aoSelecionar == null) return;
              final spot = resposta?.spot;
              if (spot == null || validas.isEmpty) return;
              final indiceSerie = modo == GraficoBarrasModo.agrupado
                  ? spot.touchedRodDataIndex
                  : 0;
              final serie = validas[indiceSerie.clamp(0, validas.length - 1)];
              if (spot.touchedBarGroupIndex >= serie.pontos.length) return;
              final ponto = serie.pontos[spot.touchedBarGroupIndex];
              aoSelecionar!(
                GraficoSelecaoDTO(
                  indiceSerie: indiceSerie,
                  indiceItem: spot.touchedBarGroupIndex,
                  serie: serie.nome,
                  rotulo: ponto.rotulo ?? '${spot.touchedBarGroupIndex + 1}',
                  valor: ponto.valor,
                ),
              );
            },
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => design.corNavbar,
              getTooltipItem: (grupo, indiceGrupo, rod, indiceRod) =>
                  BarTooltipItem(
                    _formatar(rod.toY),
                    TextStyle(
                      color: design.corNavbarTexto,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ),
          ),
          barGroups: [
            for (var item = 0; item < quantidade; item++)
              _grupo(item, validas, paleta),
          ],
        ),
        duration: const Duration(milliseconds: 350),
      ),
    );
  }

  BarChartGroupData _grupo(
    int item,
    List<GraficoSerieDTO> validas,
    List<Color> paleta,
  ) {
    if (modo == GraficoBarrasModo.agrupado) {
      return BarChartGroupData(
        x: item,
        barsSpace: 4,
        barRods: [
          for (var serie = 0; serie < validas.length; serie++)
            BarChartRodData(
              toY: item < validas[serie].pontos.length
                  ? validas[serie].pontos[item].valor
                  : 0,
              color: validas[serie].cor ?? corGrafico(paleta, serie),
              width: larguraBarra,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(5),
              ),
            ),
        ],
      );
    }
    var acumulado = 0.0;
    final pilha = <BarChartRodStackItem>[];
    for (var serie = 0; serie < validas.length; serie++) {
      final valor = item < validas[serie].pontos.length
          ? validas[serie].pontos[item].valor
          : 0.0;
      pilha.add(
        BarChartRodStackItem(
          acumulado,
          acumulado + valor,
          validas[serie].cor ?? corGrafico(paleta, serie),
        ),
      );
      acumulado += valor;
    }
    return BarChartGroupData(
      x: item,
      barRods: [
        BarChartRodData(
          toY: acumulado,
          width: larguraBarra * 1.35,
          rodStackItems: pilha,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
        ),
      ],
    );
  }

  FlTitlesData _titulos(BuildContext context, List<GraficoSerieDTO> validas) {
    final estilo = TextStyle(
      color: context.design.corTextoSecundario,
      fontSize: 11,
    );
    String rotulo(int indice) =>
        validas.isNotEmpty && indice < validas.first.pontos.length
        ? validas.first.pontos[indice].rotulo ?? ''
        : '';
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
            child: Text(rotulo(v.toInt()), style: estilo),
          ),
        ),
      ),
    );
  }

  String _formatar(double valor) =>
      formatadorValor?.call(valor) ?? formatarNumeroGrafico(valor);
}
