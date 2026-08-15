import 'package:flutter/material.dart';

/// Uma seção do `AccordionDefault`: cabeçalho, conteúdo e, opcionalmente,
/// overrides individuais das cores/bordas/espaçamentos definidos
/// globalmente no `AccordionDefault`.
class AccordionItem {
  /// Widget exibido no cabeçalho (sempre visível).
  final Widget cabecalho;

  /// Widget exibido quando a seção está aberta.
  final Widget conteudo;

  /// Define se a seção já inicia aberta.
  final bool abertoInicialmente;

  /// Chamado quando a seção é aberta.
  final VoidCallback? aoAbrir;

  /// Chamado quando a seção é fechada.
  final VoidCallback? aoFechar;

  /// Cor de fundo do cabeçalho fechado. Sobrepõe
  /// `AccordionDefault.corFundoCabecalho` para esta seção.
  final Color? corFundoCabecalho;

  /// Cor de fundo do cabeçalho aberto. Sobrepõe
  /// `AccordionDefault.corFundoCabecalhoAberto` para esta seção.
  final Color? corFundoCabecalhoAberto;

  /// Cor da borda do cabeçalho fechado.
  final Color? corBordaCabecalho;

  /// Cor da borda do cabeçalho aberto.
  final Color? corBordaCabecalhoAberto;

  /// Espessura da borda do cabeçalho.
  final double? larguraBordaCabecalho;

  /// Espaçamento interno do cabeçalho.
  final EdgeInsetsGeometry? espacamentoCabecalho;

  /// Widget exibido à esquerda do cabeçalho.
  final Widget? iconeEsquerdo;

  /// Widget exibido à direita do cabeçalho (padrão: seta para baixo).
  final Widget? iconeDireito;

  /// Cor de fundo do conteúdo.
  final Color? corFundoConteudo;

  /// Cor da borda do conteúdo.
  final Color? corBordaConteudo;

  /// Espessura da borda do conteúdo.
  final double? larguraBordaConteudo;

  /// Raio das bordas do cabeçalho e do conteúdo.
  final double? raioBorda;

  /// Espaçamento horizontal interno do conteúdo.
  final double? espacamentoHorizontalConteudo;

  /// Espaçamento vertical interno do conteúdo.
  final double? espacamentoVerticalConteudo;

  const AccordionItem({
    required this.cabecalho,
    required this.conteudo,
    this.abertoInicialmente = false,
    this.aoAbrir,
    this.aoFechar,
    this.corFundoCabecalho,
    this.corFundoCabecalhoAberto,
    this.corBordaCabecalho,
    this.corBordaCabecalhoAberto,
    this.larguraBordaCabecalho,
    this.espacamentoCabecalho,
    this.iconeEsquerdo,
    this.iconeDireito,
    this.corFundoConteudo,
    this.corBordaConteudo,
    this.larguraBordaConteudo,
    this.raioBorda,
    this.espacamentoHorizontalConteudo,
    this.espacamentoVerticalConteudo,
  });
}
