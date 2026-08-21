import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../code_design_system_theme.dart';
import '../../core/platform_widget.dart';
import '../../models/graficos/grafico_fatia_dto.dart';
import '../../models/graficos/grafico_selecao_dto.dart';
import '../../types/grafico_legenda_posicao.dart';
import 'grafico_base.dart';

class GraficoRoscaDefault extends PlatformWidget {
  final List<GraficoFatiaDTO> fatias;
  final String? titulo;
  final String? subtitulo;
  final String? textoCentral;
  final String? detalheCentral;
  final double altura;
  final bool formatoRosca;
  final bool exibirPercentuais;
  final GraficoLegendaPosicao posicaoLegenda;
  final List<Color>? cores;
  final String mensagemVazio;
  final GraficoAoSelecionar? aoSelecionar;

  const GraficoRoscaDefault({
    super.key,
    required this.fatias,
    this.titulo,
    this.subtitulo,
    this.textoCentral,
    this.detalheCentral,
    this.altura = 280,
    this.formatoRosca = true,
    this.exibirPercentuais = true,
    this.posicaoLegenda = GraficoLegendaPosicao.inferior,
    this.cores,
    this.mensagemVazio = 'Nenhum dado disponível.',
    this.aoSelecionar,
  });

  @override
  Widget createAndroidWidget(BuildContext context) =>
      _GraficoRoscaConteudo(configuracao: this);

  @override
  Widget createIosWidget(BuildContext context) =>
      _GraficoRoscaConteudo(configuracao: this);
}

class _GraficoRoscaConteudo extends StatefulWidget {
  final GraficoRoscaDefault configuracao;
  const _GraficoRoscaConteudo({required this.configuracao});

  @override
  State<_GraficoRoscaConteudo> createState() => _GraficoRoscaConteudoState();
}

class _GraficoRoscaConteudoState extends State<_GraficoRoscaConteudo> {
  int indiceAtivo = -1;

  @override
  Widget build(BuildContext context) {
    final c = widget.configuracao;
    final design = context.design;
    final validas = c.fatias.where((f) => f.valor > 0).toList();
    final total = validas.fold<double>(0, (soma, fatia) => soma + fatia.valor);
    final paleta = coresGraficos(context, c.cores);
    final legendas = <(String, Color)>[
      for (var i = 0; i < validas.length; i++)
        (validas[i].rotulo, validas[i].cor ?? corGrafico(paleta, i)),
    ];
    return GraficoBase(
      titulo: c.titulo,
      subtitulo: c.subtitulo,
      altura: c.altura,
      vazio: validas.isEmpty,
      mensagemVazio: c.mensagemVazio,
      legendas: legendas,
      posicaoLegenda: c.posicaoLegenda,
      descricaoSemantica: c.titulo ?? 'Gráfico de rosca',
      grafico: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              centerSpaceRadius: c.formatoRosca ? 62 : 0,
              sectionsSpace: 3,
              pieTouchData: PieTouchData(
                touchCallback: (evento, resposta) {
                  final indice =
                      resposta?.touchedSection?.touchedSectionIndex ?? -1;
                  if (indice != indiceAtivo) {
                    setState(() => indiceAtivo = indice);
                  }
                  if (evento is FlTapUpEvent &&
                      indice >= 0 &&
                      c.aoSelecionar != null) {
                    final fatia = validas[indice];
                    c.aoSelecionar!(
                      GraficoSelecaoDTO(
                        indiceSerie: 0,
                        indiceItem: indice,
                        serie: c.titulo ?? 'Distribuição',
                        rotulo: fatia.rotulo,
                        valor: fatia.valor,
                      ),
                    );
                  }
                },
              ),
              sections: [
                for (var i = 0; i < validas.length; i++)
                  PieChartSectionData(
                    value: validas[i].valor,
                    color: validas[i].cor ?? corGrafico(paleta, i),
                    radius: i == indiceAtivo ? 72 : 64,
                    title: c.exibirPercentuais
                        ? '${(validas[i].valor / total * 100).round()}%'
                        : '',
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
            duration: const Duration(milliseconds: 350),
          ),
          if (c.formatoRosca &&
              (c.textoCentral != null || c.detalheCentral != null))
            IgnorePointer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (c.textoCentral != null)
                    Text(
                      c.textoCentral!,
                      style: TextStyle(
                        color: design.corTexto,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  if (c.detalheCentral != null)
                    Text(
                      c.detalheCentral!,
                      style: TextStyle(
                        color: design.corTextoSecundario,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
