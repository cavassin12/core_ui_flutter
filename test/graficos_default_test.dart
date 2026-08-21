import 'package:core_ui_flutter/core_ui_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget app(Widget child) => MaterialApp(
  theme: CoreDesignSystemTheme.claro.criarThemeData(),
  home: Scaffold(body: SizedBox(width: 720, child: child)),
);

const serie = GraficoSerieDTO(
  nome: 'Receita',
  pontos: [
    GraficoPontoDTO(x: 0, valor: 10, rotulo: 'Jan'),
    GraficoPontoDTO(x: 1, valor: 18, rotulo: 'Fev'),
    GraficoPontoDTO(x: 2, valor: 14, rotulo: 'Mar'),
  ],
);

void main() {
  testWidgets('renderiza os quatro tipos de gráfico', (tester) async {
    await tester.pumpWidget(
      app(
        const SingleChildScrollView(
          child: Column(
            children: [
              GraficoLinhaDefault(
                titulo: 'Linha',
                series: [serie],
                altura: 220,
              ),
              GraficoBarrasDefault(
                titulo: 'Barras',
                series: [serie],
                altura: 220,
              ),
              GraficoRoscaDefault(
                titulo: 'Rosca',
                altura: 220,
                fatias: [
                  GraficoFatiaDTO(rotulo: 'Web', valor: 70),
                  GraficoFatiaDTO(rotulo: 'Desktop', valor: 30),
                ],
              ),
              GraficoIndicadorDefault(
                titulo: 'Indicador',
                valor: 76,
                altura: 220,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Linha'), findsOneWidget);
    expect(find.text('Barras'), findsOneWidget);
    expect(find.text('Rosca'), findsOneWidget);
    expect(find.text('Indicador'), findsOneWidget);
    expect(find.text('76'), findsOneWidget);
  });

  testWidgets('exibe estado vazio em gráficos sem dados', (tester) async {
    await tester.pumpWidget(
      app(
        const GraficoLinhaDefault(
          series: [],
          mensagemVazio: 'Sem métricas no período',
        ),
      ),
    );
    expect(find.text('Sem métricas no período'), findsOneWidget);
  });

  testWidgets('indicador responde ao toque', (tester) async {
    var tocou = false;
    await tester.pumpWidget(
      app(GraficoIndicadorDefault(valor: 50, aoTocar: () => tocou = true)),
    );
    await tester.tap(find.byType(InkWell));
    expect(tocou, isTrue);
  });
}
