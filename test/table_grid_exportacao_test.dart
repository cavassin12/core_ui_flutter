import 'package:core_ui_flutter/core_ui_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const colunas = [
    DynamicColumnDTO(title: 'Nome', field: 'nome', order: 0),
    DynamicColumnDTO(title: 'Cidade', field: 'cidade', order: 1),
    DynamicColumnDTO(
      title: 'Ativo',
      field: 'ativo',
      type: TypeColunm.statusBoolean,
      order: 2,
    ),
  ];

  test('gera CSV somente com as colunas escolhidas e escapa conteúdo', () {
    final csv = gerarCsvTableGrid<Map<String, dynamic>>(
      data: const [
        {'nome': 'Maria, Silva', 'cidade': 'São Paulo', 'ativo': true},
        {'nome': 'João "Jota"', 'cidade': 'Curitiba', 'ativo': false},
      ],
      colunas: [colunas[0], colunas[2]],
      resolverCampo: (row, campo) => row[campo],
    );

    expect(
      csv,
      'Nome,Ativo\r\n"Maria, Silva",Ativo\r\n"João ""Jota""",Inativo',
    );
    expect(csv, isNot(contains('Cidade')));
  });

  testWidgets('botão abre modal e permite marcar ou desmarcar colunas', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CoreDesignSystemTheme.claro.criarThemeData(),
        home: const Scaffold(
          body: SizedBox(
            width: 800,
            child: TableGrid<Map<String, dynamic>>(
              exportarCSV: true,
              cols: colunas,
              data: [
                {'nome': 'Maria', 'cidade': 'São Paulo', 'ativo': true},
              ],
            ),
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('tablegrid-exportar-csv')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('tablegrid-exportar-csv')));
    await tester.pumpAndSettle();

    expect(find.text('Exportar dados em CSV'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsNWidgets(3));

    await tester.tap(find.byKey(const ValueKey('csv-coluna-cidade')));
    await tester.pump();
    final cidade = tester.widget<CheckboxListTile>(
      find.byKey(const ValueKey('csv-coluna-cidade')),
    );
    expect(cidade.value, isFalse);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('Exportar dados em CSV'), findsNothing);
  });

  testWidgets('não mostra exportação por padrão', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: TableGrid<Map<String, dynamic>>(cols: colunas)),
      ),
    );
    expect(find.byKey(const ValueKey('tablegrid-exportar-csv')), findsNothing);
  });
}
