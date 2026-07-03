import 'package:flutter/material.dart';

/// 1. A classe que define as cores e variáveis do seu pacote
class CoreDesignSystemTheme extends ThemeExtension<CoreDesignSystemTheme> {
  final Color corPrimaria;
  final Color corFundo;
  final double raioBorda;

  const CoreDesignSystemTheme({
    required this.corPrimaria,
    required this.corFundo,
    required this.raioBorda,
  });

  @override
  ThemeExtension<CoreDesignSystemTheme> copyWith({
    Color? corPrimaria,
    Color? corFundo,
    double? raioBorda,
  }) {
    return CoreDesignSystemTheme(
      corPrimaria: corPrimaria ?? this.corPrimaria,
      corFundo: corFundo ?? this.corFundo,
      raioBorda: raioBorda ?? this.raioBorda,
    );
  }

  @override
  ThemeExtension<CoreDesignSystemTheme> lerp(
    covariant ThemeExtension<CoreDesignSystemTheme>? other,
    double t,
  ) {
    if (other is! CoreDesignSystemTheme) return this;
    return CoreDesignSystemTheme(
      corPrimaria: Color.lerp(corPrimaria, other.corPrimaria, t) ?? corPrimaria,
      corFundo: Color.lerp(corFundo, other.corFundo, t) ?? corFundo,
      raioBorda: lerpDouble(raioBorda, other.raioBorda, t) ?? raioBorda,
    );
  }
}

/// Helper nativo para interpolação de doubles
double? lerpDouble(num? a, num? b, double t) {
  if (a == null && b == null) return null;
  a ??= 0.0;
  b ??= 0.0;
  return a + (b - a) * t;
}

/// 2. O "Truque" Mágico para facilitar o uso nos seus widgets
extension MeuDesignSystemContextX on BuildContext {
  CoreDesignSystemTheme get design {
    // Tenta pegar o tema injetado pelo app.
    // Se o app esquecer de injetar, retorna um valor padrão para não quebrar a tela.
    return Theme.of(this).extension<CoreDesignSystemTheme>() ??
        const CoreDesignSystemTheme(
          corPrimaria: Colors.blue,
          corFundo: Colors.white,
          raioBorda: 8.0,
        );
  }
}
