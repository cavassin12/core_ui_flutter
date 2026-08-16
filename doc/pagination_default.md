# PaginationDefault

Componente único de paginação avulsa, equivalente ao `.pagination` do Bootstrap: botões de anterior/próxima, números de página (com janela deslizante ao redor da página atual) e botões opcionais de primeira/última página.

Diferente da paginação embutida no [`TableGrid`](table_grid.md) (que só mostra "Página X de Y" + anterior/próxima), este componente é standalone e pode ser usado em qualquer lista/tela que precise de paginação.

Estende `PlatformWidget`, mas usa a mesma implementação em todas as plataformas — uma paginação não tem uma variação visual nativa relevante entre Android/iOS/Web/Windows.

Arquivo: `lib/components/pagination_default.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

```dart
PaginationDefault(
  paginaAtual: pagina,
  totalPaginas: totalPaginas,
  aoMudarPagina: (novaPagina) => setState(() => pagina = novaPagina),
)
```

`PaginationDefault` não busca nem pagina nenhum dado sozinho — apenas emite `aoMudarPagina` com o número da página escolhida; cabe a quem consome buscar os dados correspondentes (mesmo contrato "lazy" do `TableGrid.lazyLoadDados`).

---

## Parâmetros

| Parâmetro               | Tipo                    | Padrão                     | Descrição                                                                 |
|----------------------------|---------------------------|-------------------------------|------------------------------------------------------------------------------|
| `paginaAtual`                | `int`                      | obrigatório                    | Página atualmente selecionada (1-based).                                    |
| `totalPaginas`               | `int`                      | obrigatório                    | Total de páginas disponíveis.                                                |
| `aoMudarPagina`              | `ValueChanged<int>`        | obrigatório                    | Chamado ao selecionar uma nova página (por número, anterior, próxima, primeira ou última). |
| `mostrarNumeros`             | `bool`                     | `true`                         | Exibe os botões numéricos de página. `false` = exibe apenas "página atual / total" entre os botões de anterior/próxima. |
| `maxBotoesNumericos`         | `int`                      | `5`                             | Quantidade máxima de botões numéricos exibidos simultaneamente.              |
| `mostrarPrimeiraUltima`      | `bool`                     | `false`                        | Exibe botões de pular para a primeira e para a última página.                |
| `tamanho`                    | `PaginationSizeDefault`    | `PaginationSizeDefault.normal` | Tamanho dos botões. Ver [Tamanhos](#tamanhos).                              |
| `alinhamento`                | `MainAxisAlignment`        | `MainAxisAlignment.center`     | Alinhamento horizontal do conjunto de botões dentro do espaço disponível (o widget ocupa toda a largura do pai). |

---

## Janela de números de página

Quando `totalPaginas` excede `maxBotoesNumericos`, a janela de botões numéricos desliza para manter `paginaAtual` sempre visível — centralizada sempre que possível, recortada nos extremos (página 1 ou última página):

```dart
PaginationDefault(
  paginaAtual: 8,
  totalPaginas: 20,
  maxBotoesNumericos: 5, // mostra, por ex., 6 7 [8] 9 10
  aoMudarPagina: (p) {},
)
```

---

## Tamanhos

`PaginationSizeDefault` reproduz `pagination-sm`/`pagination-lg` do Bootstrap:

| Valor                              | Tamanho do botão | Fonte |
|--------------------------------------|--------------------|-------|
| `PaginationSizeDefault.small`          | 28                  | 12    |
| `PaginationSizeDefault.normal` (padrão)| 36                  | 14    |
| `PaginationSizeDefault.large`          | 44                  | 16    |

---

## Sem números de página

Para paginações com muitas páginas onde os números não agregam valor (ex.: navegação simples de resultado de busca):

```dart
PaginationDefault(
  paginaAtual: pagina,
  totalPaginas: totalPaginas,
  mostrarNumeros: false,
  aoMudarPagina: (p) => setState(() => pagina = p),
)
```

---

## Com primeira/última página

```dart
PaginationDefault(
  paginaAtual: pagina,
  totalPaginas: totalPaginas,
  mostrarPrimeiraUltima: true,
  aoMudarPagina: (p) => setState(() => pagina = p),
)
```

---

## Tokens do design system usados

| Token         | Uso                                                    |
|---------------|------------------------------------------------------------|
| `corPrimaria`   | Cor de fundo do botão da página atual.                     |
| `raioBorda`     | Raio das bordas de todos os botões.                         |
