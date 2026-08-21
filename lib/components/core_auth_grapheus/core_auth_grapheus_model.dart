/// Modelos visuais disponíveis para [CoreAuthGrapheus].
///
/// Novos modelos devem ser acrescentados ao final para preservar serializações
/// feitas pelos aplicativos consumidores.
enum CoreAuthGrapheusModel {
  /// Painel visual lateral e formulário em card.
  painelVisual,

  /// Formulário e painel de boas-vindas com cor de destaque.
  painelDestaque,

  /// Card central minimalista.
  cardCentral,
}
