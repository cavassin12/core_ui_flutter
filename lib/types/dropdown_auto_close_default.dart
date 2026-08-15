/// Comportamento de fechamento automático do menu do `DropdownDefault`,
/// equivalente ao atributo `data-bs-auto-close` do Bootstrap.
enum DropdownAutoCloseDefault {
  /// `true` (padrão do Bootstrap): fecha ao clicar dentro ou fora do menu.
  always,

  /// `inside`: fecha apenas ao clicar em um item do menu; clique fora não fecha.
  insideClick,

  /// `outside`: fecha apenas ao clicar fora do menu; clique em um item não fecha.
  outsideClick,

  /// `false`: só fecha ao clicar novamente no botão trigger (ou pressionar Esc).
  manual,
}
