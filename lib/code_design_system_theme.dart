import 'package:flutter/material.dart';

/// Tokens visuais compartilhados pelo design system.
///
/// Os três tokens originais permanecem obrigatórios para preservar a
/// compatibilidade. Os demais possuem valores padrão e evitam que cada app
/// precise recriar a mesma paleta, dimensões e regras de tema.
class CoreDesignSystemTheme extends ThemeExtension<CoreDesignSystemTheme> {
  final Color corPrimaria;
  final Color corFundo;
  final double raioBorda;

  final Color corSuperficie;
  final Color corTexto;
  final Color corTextoSecundario;
  final Color corDesabilitada;
  final Color corPrimariaContraste;
  final Color corSecundaria;
  final Color corSucesso;
  final Color corInfo;
  final Color corAviso;
  final Color corErro;
  final Color corBorda;
  final Color corFundoHover;
  final Color corFundoSelecionado;
  final Color corCabecalhoTabela;
  final Color corLinhaSelecionada;
  final Color corLinhaHover;
  final Color corNavbar;
  final Color corNavbarTexto;

  final double raioBordaPequeno;
  final double raioBordaGrande;
  final double espacamentoPequeno;
  final double espacamentoMedio;
  final double espacamentoGrande;
  final double alturaComponente;
  final double alturaNavbar;
  final double elevacao;

  const CoreDesignSystemTheme({
    required this.corPrimaria,
    required this.corFundo,
    required this.raioBorda,
    this.corSuperficie = Colors.white,
    this.corTexto = const Color(0xFF1F2937),
    this.corTextoSecundario = const Color(0xFF64748B),
    this.corDesabilitada = const Color(0xFF94A3B8),
    this.corPrimariaContraste = Colors.white,
    this.corSecundaria = const Color(0xFF475569),
    this.corSucesso = const Color(0xFF16A34A),
    this.corInfo = const Color(0xFF0284C7),
    this.corAviso = const Color(0xFFD97706),
    this.corErro = const Color(0xFFDC2626),
    this.corBorda = const Color(0xFFE2E8F0),
    this.corFundoHover = const Color(0xFFF1F5F9),
    this.corFundoSelecionado = const Color(0xFFDCE9FB),
    this.corCabecalhoTabela = const Color(0xFFF8FAFC),
    this.corLinhaSelecionada = const Color(0xFFDCE9FB),
    this.corLinhaHover = const Color(0xFFF1F5F9),
    this.corNavbar = const Color(0xFF0F172A),
    this.corNavbarTexto = Colors.white,
    this.raioBordaPequeno = 6,
    this.raioBordaGrande = 12,
    this.espacamentoPequeno = 4,
    this.espacamentoMedio = 8,
    this.espacamentoGrande = 16,
    this.alturaComponente = 40,
    this.alturaNavbar = 56,
    this.elevacao = 0,
  });

  static const claro = CoreDesignSystemTheme(
    corPrimaria: Color(0xFF2563EB),
    corFundo: Color(0xFFF8FAFC),
    raioBorda: 8,
  );

  static const escuro = CoreDesignSystemTheme(
    corPrimaria: Color(0xFF60A5FA),
    corFundo: Color(0xFF0F172A),
    raioBorda: 8,
    corSuperficie: Color(0xFF1E293B),
    corTexto: Color(0xFFF8FAFC),
    corTextoSecundario: Color(0xFFCBD5E1),
    corDesabilitada: Color(0xFF64748B),
    corPrimariaContraste: Color(0xFF0F172A),
    corSecundaria: Color(0xFF94A3B8),
    corBorda: Color(0xFF334155),
    corFundoHover: Color(0xFF334155),
    corFundoSelecionado: Color(0xFF1E3A5F),
    corCabecalhoTabela: Color(0xFF1E293B),
    corLinhaSelecionada: Color(0xFF1E3A5F),
    corLinhaHover: Color(0xFF334155),
    corNavbar: Color(0xFF020617),
  );

  /// Cria o [ThemeData] com cores e extension já configurados.
  ThemeData criarThemeData({Brightness brightness = Brightness.light}) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: corPrimaria,
          brightness: brightness,
        ).copyWith(
          primary: corPrimaria,
          onPrimary: corPrimariaContraste,
          secondary: corSecundaria,
          error: corErro,
          surface: corSuperficie,
          onSurface: corTexto,
          outline: corBorda,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: corFundo,
      dividerColor: corBorda,
      disabledColor: corDesabilitada,
      appBarTheme: AppBarTheme(
        backgroundColor: corNavbar,
        foregroundColor: corNavbarTexto,
        elevation: elevacao,
      ),
      extensions: [this],
    );
  }

  @override
  CoreDesignSystemTheme copyWith({
    Color? corPrimaria,
    Color? corFundo,
    double? raioBorda,
    Color? corSuperficie,
    Color? corTexto,
    Color? corTextoSecundario,
    Color? corDesabilitada,
    Color? corPrimariaContraste,
    Color? corSecundaria,
    Color? corSucesso,
    Color? corInfo,
    Color? corAviso,
    Color? corErro,
    Color? corBorda,
    Color? corFundoHover,
    Color? corFundoSelecionado,
    Color? corCabecalhoTabela,
    Color? corLinhaSelecionada,
    Color? corLinhaHover,
    Color? corNavbar,
    Color? corNavbarTexto,
    double? raioBordaPequeno,
    double? raioBordaGrande,
    double? espacamentoPequeno,
    double? espacamentoMedio,
    double? espacamentoGrande,
    double? alturaComponente,
    double? alturaNavbar,
    double? elevacao,
  }) => CoreDesignSystemTheme(
    corPrimaria: corPrimaria ?? this.corPrimaria,
    corFundo: corFundo ?? this.corFundo,
    raioBorda: raioBorda ?? this.raioBorda,
    corSuperficie: corSuperficie ?? this.corSuperficie,
    corTexto: corTexto ?? this.corTexto,
    corTextoSecundario: corTextoSecundario ?? this.corTextoSecundario,
    corDesabilitada: corDesabilitada ?? this.corDesabilitada,
    corPrimariaContraste: corPrimariaContraste ?? this.corPrimariaContraste,
    corSecundaria: corSecundaria ?? this.corSecundaria,
    corSucesso: corSucesso ?? this.corSucesso,
    corInfo: corInfo ?? this.corInfo,
    corAviso: corAviso ?? this.corAviso,
    corErro: corErro ?? this.corErro,
    corBorda: corBorda ?? this.corBorda,
    corFundoHover: corFundoHover ?? this.corFundoHover,
    corFundoSelecionado: corFundoSelecionado ?? this.corFundoSelecionado,
    corCabecalhoTabela: corCabecalhoTabela ?? this.corCabecalhoTabela,
    corLinhaSelecionada: corLinhaSelecionada ?? this.corLinhaSelecionada,
    corLinhaHover: corLinhaHover ?? this.corLinhaHover,
    corNavbar: corNavbar ?? this.corNavbar,
    corNavbarTexto: corNavbarTexto ?? this.corNavbarTexto,
    raioBordaPequeno: raioBordaPequeno ?? this.raioBordaPequeno,
    raioBordaGrande: raioBordaGrande ?? this.raioBordaGrande,
    espacamentoPequeno: espacamentoPequeno ?? this.espacamentoPequeno,
    espacamentoMedio: espacamentoMedio ?? this.espacamentoMedio,
    espacamentoGrande: espacamentoGrande ?? this.espacamentoGrande,
    alturaComponente: alturaComponente ?? this.alturaComponente,
    alturaNavbar: alturaNavbar ?? this.alturaNavbar,
    elevacao: elevacao ?? this.elevacao,
  );

  @override
  CoreDesignSystemTheme lerp(
    covariant ThemeExtension<CoreDesignSystemTheme>? other,
    double t,
  ) {
    if (other is! CoreDesignSystemTheme) return this;
    return CoreDesignSystemTheme(
      corPrimaria: _cor(corPrimaria, other.corPrimaria, t),
      corFundo: _cor(corFundo, other.corFundo, t),
      raioBorda: _numero(raioBorda, other.raioBorda, t),
      corSuperficie: _cor(corSuperficie, other.corSuperficie, t),
      corTexto: _cor(corTexto, other.corTexto, t),
      corTextoSecundario: _cor(corTextoSecundario, other.corTextoSecundario, t),
      corDesabilitada: _cor(corDesabilitada, other.corDesabilitada, t),
      corPrimariaContraste: _cor(
        corPrimariaContraste,
        other.corPrimariaContraste,
        t,
      ),
      corSecundaria: _cor(corSecundaria, other.corSecundaria, t),
      corSucesso: _cor(corSucesso, other.corSucesso, t),
      corInfo: _cor(corInfo, other.corInfo, t),
      corAviso: _cor(corAviso, other.corAviso, t),
      corErro: _cor(corErro, other.corErro, t),
      corBorda: _cor(corBorda, other.corBorda, t),
      corFundoHover: _cor(corFundoHover, other.corFundoHover, t),
      corFundoSelecionado: _cor(
        corFundoSelecionado,
        other.corFundoSelecionado,
        t,
      ),
      corCabecalhoTabela: _cor(corCabecalhoTabela, other.corCabecalhoTabela, t),
      corLinhaSelecionada: _cor(
        corLinhaSelecionada,
        other.corLinhaSelecionada,
        t,
      ),
      corLinhaHover: _cor(corLinhaHover, other.corLinhaHover, t),
      corNavbar: _cor(corNavbar, other.corNavbar, t),
      corNavbarTexto: _cor(corNavbarTexto, other.corNavbarTexto, t),
      raioBordaPequeno: _numero(raioBordaPequeno, other.raioBordaPequeno, t),
      raioBordaGrande: _numero(raioBordaGrande, other.raioBordaGrande, t),
      espacamentoPequeno: _numero(
        espacamentoPequeno,
        other.espacamentoPequeno,
        t,
      ),
      espacamentoMedio: _numero(espacamentoMedio, other.espacamentoMedio, t),
      espacamentoGrande: _numero(espacamentoGrande, other.espacamentoGrande, t),
      alturaComponente: _numero(alturaComponente, other.alturaComponente, t),
      alturaNavbar: _numero(alturaNavbar, other.alturaNavbar, t),
      elevacao: _numero(elevacao, other.elevacao, t),
    );
  }

  static Color _cor(Color a, Color b, double t) => Color.lerp(a, b, t) ?? a;
  static double _numero(double a, double b, double t) => a + (b - a) * t;
}

/// Acesso seguro aos tokens, com fallback para o tema claro padrão.
extension MeuDesignSystemContextX on BuildContext {
  CoreDesignSystemTheme get design =>
      Theme.of(this).extension<CoreDesignSystemTheme>() ??
      CoreDesignSystemTheme.claro;
}
