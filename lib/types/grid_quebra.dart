/// Breakpoints do grid, equivalentes aos do Bootstrap (`xs`, `sm`, `md`,
/// `lg`, `xl`, `xxl`). A resolução do breakpoint atual usa a largura
/// disponível para o `GridLinha` (via `LayoutBuilder`), não a largura da
/// tela inteira — o que torna o grid responsivo também dentro de painéis,
/// diálogos e outros containers menores que o viewport.
enum GridQuebra { xs, sm, md, lg, xl, xxl }
