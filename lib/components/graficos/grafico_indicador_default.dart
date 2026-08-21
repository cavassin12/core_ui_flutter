import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../code_design_system_theme.dart';
import '../../core/platform_widget.dart';
import '../../models/graficos/grafico_faixa_dto.dart';
import '../graficos/grafico_base.dart';

class GraficoIndicadorDefault extends PlatformWidget {
  final double valor;
  final double minimo;
  final double maximo;
  final String? titulo;
  final String? subtitulo;
  final String? rotulo;
  final double altura;
  final List<GraficoFaixaDTO> faixas;
  final Color? corIndicador;
  final String Function(double valor)? formatadorValor;
  final VoidCallback? aoTocar;

  const GraficoIndicadorDefault({
    super.key,
    required this.valor,
    this.minimo = 0,
    this.maximo = 100,
    this.titulo,
    this.subtitulo,
    this.rotulo,
    this.altura = 240,
    this.faixas = const [],
    this.corIndicador,
    this.formatadorValor,
    this.aoTocar,
  }) : assert(maximo > minimo);

  @override
  Widget createAndroidWidget(BuildContext context) => _build(context);

  @override
  Widget createIosWidget(BuildContext context) => _build(context);

  Widget _build(BuildContext context) {
    final design = context.design;
    final limitado = valor.clamp(minimo, maximo).toDouble();
    final texto = formatadorValor?.call(valor) ?? formatarNumeroGrafico(valor);
    final indicador = Semantics(
      button: aoTocar != null,
      value: texto,
      child: InkWell(
        onTap: aoTocar,
        borderRadius: BorderRadius.circular(design.raioBordaGrande),
        child: CustomPaint(
          painter: _IndicadorPainter(
            valor: limitado,
            minimo: minimo,
            maximo: maximo,
            faixas: faixas,
            corFundo: design.corBorda,
            corIndicador: corIndicador ?? design.corPrimaria,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 42),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    texto,
                    style: TextStyle(
                      color: design.corTexto,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (rotulo != null)
                    Text(
                      rotulo!,
                      style: TextStyle(
                        color: design.corTextoSecundario,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return GraficoBase(
      titulo: titulo,
      subtitulo: subtitulo,
      altura: altura,
      vazio: false,
      mensagemVazio: '',
      grafico: indicador,
      descricaoSemantica: titulo ?? 'Gráfico indicador',
    );
  }
}

class _IndicadorPainter extends CustomPainter {
  final double valor;
  final double minimo;
  final double maximo;
  final List<GraficoFaixaDTO> faixas;
  final Color corFundo;
  final Color corIndicador;

  const _IndicadorPainter({
    required this.valor,
    required this.minimo,
    required this.maximo,
    required this.faixas,
    required this.corFundo,
    required this.corIndicador,
  });

  static const inicio = math.pi * .75;
  static const amplitude = math.pi * 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height * .58);
    final raio = math.min(size.width * .38, size.height * .42);
    final rect = Rect.fromCircle(center: centro, radius: raio);
    final fundo = Paint()
      ..color = corFundo
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, inicio, amplitude, false, fundo);
    for (final faixa in faixas) {
      final a = ((faixa.inicio - minimo) / (maximo - minimo)).clamp(0.0, 1.0);
      final b = ((faixa.fim - minimo) / (maximo - minimo)).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = faixa.cor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        rect,
        inicio + amplitude * a,
        amplitude * (b - a),
        false,
        paint,
      );
    }
    final progresso = (valor - minimo) / (maximo - minimo);
    final angulo = inicio + amplitude * progresso;
    final ponta =
        centro + Offset(math.cos(angulo), math.sin(angulo)) * (raio - 4);
    canvas.drawLine(
      centro,
      ponta,
      Paint()
        ..color = corIndicador
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(centro, 9, Paint()..color = corIndicador);
  }

  @override
  bool shouldRepaint(covariant _IndicadorPainter oldDelegate) =>
      valor != oldDelegate.valor ||
      minimo != oldDelegate.minimo ||
      maximo != oldDelegate.maximo ||
      faixas != oldDelegate.faixas ||
      corFundo != oldDelegate.corFundo ||
      corIndicador != oldDelegate.corIndicador;
}
