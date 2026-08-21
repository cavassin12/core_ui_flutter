import 'package:core_ui_flutter/core_ui_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const marcaKey = Key('marca-navbar');

  Widget app({
    required double largura,
    bool usarContainer = true,
    double larguraMaxima = 1320,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: largura,
            child: NavbarDefault(
              usarContainer: usarContainer,
              larguraMaxima: larguraMaxima,
              marca: const Text('Grapheus', key: marcaKey),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('centraliza o conteúdo dentro da largura máxima', (tester) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(app(largura: 1600));

    // (1600 - 1320) / 2 + padding horizontal de 16.
    expect(tester.getTopLeft(find.byKey(marcaKey)).dx, 156);
  });

  testWidgets('ocupa toda a largura disponível em telas menores', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(app(largura: 800));

    expect(tester.getTopLeft(find.byKey(marcaKey)).dx, 16);
  });

  testWidgets('preserva o comportamento fluido quando solicitado', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(app(largura: 1600, usarContainer: false));

    expect(tester.getTopLeft(find.byKey(marcaKey)).dx, 16);
  });
}
