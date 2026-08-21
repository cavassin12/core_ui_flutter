import 'package:core_ui_flutter/core_ui_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('aplica a cor de destaque de cada módulo', () {
    expect(
      GrapheusTheme.tokensClaros(
        modulo: GrapheusModulo.gastronomia,
      ).corPrimaria,
      GrapheusCores.gastronomia,
    );
    expect(
      GrapheusTheme.tokensClaros(modulo: GrapheusModulo.agro).corPrimaria,
      GrapheusCores.agro,
    );
    expect(
      GrapheusTheme.tokensClaros(modulo: GrapheusModulo.crm).corPrimaria,
      GrapheusCores.crm,
    );
  });

  test('gera tokens claros e escuros consistentes', () {
    final claro = GrapheusTheme.tokensClaros();
    final escuro = GrapheusTheme.tokensEscuros();

    expect(claro.corFundo, GrapheusCores.fundoClaro);
    expect(claro.corTexto, GrapheusCores.textoClaro);
    expect(escuro.corFundo, GrapheusCores.fundoEscuro);
    expect(escuro.corTexto, GrapheusCores.textoEscuro);
  });
}
