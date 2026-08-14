import 'package:flutter/material.dart';

/// 1. A classe que define as cores e variáveis do seu pacote
class CoreDesignSystemTheme extends ThemeExtension<CoreDesignSystemTheme> {
  final Color corPrimaria;
  final Color corFundo;
  final double raioBorda;

  /// Borda de cards/tabelas (equivalente a `--pd-border` no Angular).
  final Color corBorda;

  /// Fundo do cabeçalho de tabelas (equivalente a `--pd-component-header-bg`).
  final Color corCabecalhoTabela;

  /// Fundo de uma linha de tabela selecionada (equivalente a `--pd-item-selected-bg`).
  final Color corLinhaSelecionada;

  /// Fundo de uma linha de tabela em hover — só relevante em plataformas com mouse
  /// (equivalente a `--pd-item-hover-bg`).
  final Color corLinhaHover;

  const CoreDesignSystemTheme({
    required this.corPrimaria,
    required this.corFundo,
    required this.raioBorda,
    this.corBorda = const Color(0xFFE2E8F0),
    this.corCabecalhoTabela = const Color(0xFFF8FAFC),
    this.corLinhaSelecionada = const Color(0xFFDCE9FB),
    this.corLinhaHover = const Color(0xFFF1F5F9),
  });

  @override
  ThemeExtension<CoreDesignSystemTheme> copyWith({
    Color? corPrimaria,
    Color? corFundo,
    double? raioBorda,
    Color? corBorda,
    Color? corCabecalhoTabela,
    Color? corLinhaSelecionada,
    Color? corLinhaHover,
  }) {
    return CoreDesignSystemTheme(
      corPrimaria: corPrimaria ?? this.corPrimaria,
      corFundo: corFundo ?? this.corFundo,
      raioBorda: raioBorda ?? this.raioBorda,
      corBorda: corBorda ?? this.corBorda,
      corCabecalhoTabela: corCabecalhoTabela ?? this.corCabecalhoTabela,
      corLinhaSelecionada: corLinhaSelecionada ?? this.corLinhaSelecionada,
      corLinhaHover: corLinhaHover ?? this.corLinhaHover,
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
      corBorda: Color.lerp(corBorda, other.corBorda, t) ?? corBorda,
      corCabecalhoTabela:
          Color.lerp(corCabecalhoTabela, other.corCabecalhoTabela, t) ?? corCabecalhoTabela,
      corLinhaSelecionada:
          Color.lerp(corLinhaSelecionada, other.corLinhaSelecionada, t) ?? corLinhaSelecionada,
      corLinhaHover: Color.lerp(corLinhaHover, other.corLinhaHover, t) ?? corLinhaHover,
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
