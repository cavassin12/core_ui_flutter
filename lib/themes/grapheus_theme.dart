import 'package:core_ui_flutter/code_design_system_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Módulos que podem aplicar uma cor de destaque própria sem perder a
/// identidade visual compartilhada do Grapheus.
enum GrapheusModulo {
  padrao,
  gastronomia,
  agro,
  faturaPrime,
  crm,
  docDigital,
  contaPorco,
}

/// Paleta institucional. Evita hexadecimais dispersos pelos componentes.
abstract final class GrapheusCores {
  static const primaria = Color(0xFF2563EB);
  static const primariaEscura = Color(0xFF1E3A8A);
  static const secundaria = Color(0xFF475569);
  static const destaque = Color(0xFF0D9488);

  static const fundoClaro = Color(0xFFF4F7FB);
  static const superficieClara = Color(0xFFFFFFFF);
  static const textoClaro = Color(0xFF172033);
  static const textoSecundarioClaro = Color(0xFF64748B);
  static const bordaClara = Color(0xFFDCE3EC);

  static const fundoEscuro = Color(0xFF0B1120);
  static const superficieEscura = Color(0xFF172033);
  static const textoEscuro = Color(0xFFF8FAFC);
  static const textoSecundarioEscuro = Color(0xFFCBD5E1);
  static const bordaEscura = Color(0xFF334155);
  static const primariaEscuraTema = Color(0xFF60A5FA);
  static const destaqueEscuro = Color(0xFF2DD4BF);

  static const sucesso = Color(0xFF16A34A);
  static const info = Color(0xFF0284C7);
  static const aviso = Color(0xFFD97706);
  static const erro = Color(0xFFDC2626);

  static const gastronomia = Color(0xFFEA580C);
  static const agro = Color(0xFF15803D);
  static const faturaPrime = primaria;
  static const crm = Color(0xFF7C3AED);
  static const docDigital = Color(0xFF0891B2);
  static const contaPorco = Color(0xFFBE185D);

  static Color destaqueDoModulo(GrapheusModulo modulo) => switch (modulo) {
    GrapheusModulo.padrao => primaria,
    GrapheusModulo.gastronomia => gastronomia,
    GrapheusModulo.agro => agro,
    GrapheusModulo.faturaPrime => faturaPrime,
    GrapheusModulo.crm => crm,
    GrapheusModulo.docDigital => docDigital,
    GrapheusModulo.contaPorco => contaPorco,
  };
}

/// Tipografia compartilhada: Inter na interface, Manrope em títulos e Roboto
/// Mono para números, códigos e conteúdo técnico.
abstract final class GrapheusTipografia {
  static TextTheme aplicar(TextTheme base) {
    final inter = GoogleFonts.interTextTheme(base);
    return inter.copyWith(
      displayLarge: _manrope(inter.displayLarge, 48, FontWeight.w700, 1.15),
      displayMedium: _manrope(inter.displayMedium, 40, FontWeight.w700, 1.15),
      displaySmall: _manrope(inter.displaySmall, 36, FontWeight.w700, 1.18),
      headlineLarge: _manrope(inter.headlineLarge, 32, FontWeight.w700, 1.20),
      headlineMedium: _manrope(inter.headlineMedium, 28, FontWeight.w700, 1.20),
      headlineSmall: _manrope(inter.headlineSmall, 24, FontWeight.w600, 1.25),
      titleLarge: GoogleFonts.inter(
        textStyle: inter.titleLarge,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.inter(
        textStyle: inter.titleMedium,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.inter(
        textStyle: inter.bodyLarge,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        textStyle: inter.bodyMedium,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
      ),
      bodySmall: GoogleFonts.inter(
        textStyle: inter.bodySmall,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.35,
      ),
      labelLarge: GoogleFonts.inter(
        textStyle: inter.labelLarge,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: GoogleFonts.inter(
        textStyle: inter.labelMedium,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static TextStyle monoespacada({
    TextStyle? base,
    double? tamanho,
    FontWeight peso = FontWeight.w500,
    Color? cor,
  }) {
    return GoogleFonts.robotoMono(
      textStyle: base,
      fontSize: tamanho,
      fontWeight: peso,
      color: cor,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static TextStyle _manrope(
    TextStyle? base,
    double tamanho,
    FontWeight peso,
    double altura,
  ) {
    return GoogleFonts.manrope(
      textStyle: base,
      fontSize: tamanho,
      fontWeight: peso,
      height: altura,
    );
  }
}

/// Fábrica oficial de temas Grapheus.
abstract final class GrapheusTheme {
  static CoreDesignSystemTheme tokensClaros({
    GrapheusModulo modulo = GrapheusModulo.padrao,
  }) {
    final primaria = GrapheusCores.destaqueDoModulo(modulo);
    return CoreDesignSystemTheme(
      corPrimaria: primaria,
      corFundo: GrapheusCores.fundoClaro,
      raioBorda: 8,
      corSuperficie: GrapheusCores.superficieClara,
      corTexto: GrapheusCores.textoClaro,
      corTextoSecundario: GrapheusCores.textoSecundarioClaro,
      corPrimariaContraste: Colors.white,
      corSecundaria: GrapheusCores.secundaria,
      corSucesso: GrapheusCores.sucesso,
      corInfo: GrapheusCores.info,
      corAviso: GrapheusCores.aviso,
      corErro: GrapheusCores.erro,
      corBorda: GrapheusCores.bordaClara,
      corFundoHover: const Color(0xFFF1F5F9),
      corFundoSelecionado: Color.alphaBlend(
        primaria.withValues(alpha: 0.12),
        GrapheusCores.superficieClara,
      ),
      raioBordaPequeno: 6,
      raioBordaGrande: 14,
      elevacao: 2,
    );
  }

  static CoreDesignSystemTheme tokensEscuros({
    GrapheusModulo modulo = GrapheusModulo.padrao,
  }) {
    final destaque = modulo == GrapheusModulo.padrao
        ? GrapheusCores.primariaEscuraTema
        : GrapheusCores.destaqueDoModulo(modulo);
    return CoreDesignSystemTheme(
      corPrimaria: destaque,
      corFundo: GrapheusCores.fundoEscuro,
      raioBorda: 8,
      corSuperficie: GrapheusCores.superficieEscura,
      corTexto: GrapheusCores.textoEscuro,
      corTextoSecundario: GrapheusCores.textoSecundarioEscuro,
      corDesabilitada: const Color(0xFF64748B),
      corPrimariaContraste: GrapheusCores.fundoEscuro,
      corSecundaria: const Color(0xFF94A3B8),
      corSucesso: const Color(0xFF22C55E),
      corInfo: const Color(0xFF38BDF8),
      corAviso: const Color(0xFFF59E0B),
      corErro: const Color(0xFFF87171),
      corBorda: GrapheusCores.bordaEscura,
      corFundoHover: const Color(0xFF263449),
      corFundoSelecionado: Color.alphaBlend(
        destaque.withValues(alpha: 0.18),
        GrapheusCores.superficieEscura,
      ),
      corNavbar: const Color(0xFF020617),
      raioBordaPequeno: 6,
      raioBordaGrande: 14,
      elevacao: 2,
    );
  }

  static ThemeData claro({GrapheusModulo modulo = GrapheusModulo.padrao}) =>
      _criar(tokensClaros(modulo: modulo), Brightness.light);

  static ThemeData escuro({GrapheusModulo modulo = GrapheusModulo.padrao}) =>
      _criar(tokensEscuros(modulo: modulo), Brightness.dark);

  static ThemeData _criar(CoreDesignSystemTheme tokens, Brightness brilho) {
    final base = tokens.criarThemeData(brightness: brilho);
    final tipografia = GrapheusTipografia.aplicar(
      base.textTheme,
    ).apply(bodyColor: tokens.corTexto, displayColor: tokens.corTexto);

    return base.copyWith(
      textTheme: tipografia,
      primaryTextTheme: tipografia,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.corSuperficie,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.raioBorda),
          borderSide: BorderSide(color: tokens.corBorda),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.raioBorda),
          borderSide: BorderSide(color: tokens.corBorda),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.raioBorda),
          borderSide: BorderSide(color: tokens.corPrimaria, width: 1.8),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: tokens.corPrimaria,
          textStyle: tipografia.labelMedium,
        ),
      ),
    );
  }
}
