# GridLinha / GridColuna

Sistema de grid responsivo com os mesmos comportamentos das classes `row`/`col-*` do Bootstrap: 12 colunas (configurável), breakpoints `xs`/`sm`/`md`/`lg`/`xl`/`xxl`, quebra automática de linha, colunas automáticas (`.col`), deslocamento (`offset-*`) e reordenação (`order-*`) — tudo traduzido para português.

Diferente do Bootstrap (que usa a largura do *viewport*), o breakpoint aqui é resolvido a partir da **largura disponível para o próprio `GridLinha`** (via `LayoutBuilder`). Isso faz o grid responder corretamente também dentro de painéis, diálogos, gavetas e qualquer container menor que a tela — não só a tela inteira.

`GridLinha` é um `StatelessWidget` (equivalente a `row`); `GridColuna` é o item usado como filho direto (equivalente a `col`/`col-*`).

Arquivo: `lib/components/grid_default.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

```dart
GridLinha(
  filhos: const [
    GridColuna(colunas: 12, colunasMd: 6, filho: Text('Coluna A')),
    GridColuna(colunas: 12, colunasMd: 6, filho: Text('Coluna B')),
  ],
)
```

Igual ao Bootstrap, os valores são *mobile-first*: `colunas: 12` vale a partir de `xs`, e `colunasMd: 6` sobrescreve esse valor a partir do breakpoint `md` em diante. No exemplo acima, as duas colunas ficam empilhadas (100% de largura cada) em telas pequenas e lado a lado (50% cada) a partir de `md`.

---

## Breakpoints

| Breakpoint | Largura mínima | Equivalente Bootstrap |
|--------------|-------------------|--------------------------|
| `xs`           | `0`                 | (nenhum sufixo, ex.: `col-6`) |
| `sm`           | `576`               | `col-sm-*`                 |
| `md`           | `768`               | `col-md-*`                 |
| `lg`           | `992`               | `col-lg-*`                 |
| `xl`           | `1200`              | `col-xl-*`                 |
| `xxl`          | `1400`              | `col-xxl-*`                |

---

## Colunas automáticas (`.col`)

Quando nenhum `colunas*` é informado em um `GridColuna`, ele se comporta como o `.col` "automático" do Bootstrap: divide igualmente, com as demais colunas automáticas da mesma linha, o espaço que sobrar depois das colunas com tamanho fixo.

```dart
GridLinha(
  filhos: const [
    GridColuna(filho: Text('Automática 1')), // ~33%
    GridColuna(filho: Text('Automática 2')), // ~33%
    GridColuna(filho: Text('Automática 3')), // ~33%
  ],
)
```

Widgets que não sejam `GridColuna` também são aceitos como filhos de `GridLinha` — são tratados automaticamente como uma coluna automática:

```dart
GridLinha(
  filhos: const [
    Text('Vira uma coluna automática'),
    GridColuna(colunas: 4, filho: Text('Coluna fixa')),
  ],
)
```

---

## Quebra automática de linha

Assim como no Bootstrap, quando a soma das colunas de uma linha ultrapassa `totalColunas` (padrão 12), o excedente quebra automaticamente para uma nova linha:

```dart
GridLinha(
  filhos: const [
    GridColuna(colunas: 8, filho: Text('8')),
    GridColuna(colunas: 6, filho: Text('6')), // não cabe (8+6=14>12), quebra linha
  ],
)
```

---

## Parâmetros

### `GridColuna`

| Parâmetro       | Tipo     | Padrão   | Descrição                                                                 |
|--------------------|----------|----------|--------------------------------------------------------------------------|
| `filho`               | `Widget` | obrigatório | Conteúdo da coluna.                                                    |
| `colunas`              | `int?`   | `null` (automático) | Número de colunas ocupadas a partir de `xs` (`col-*`).            |
| `colunasSm`            | `int?`   | `null`   | Sobrescreve `colunas` a partir de `sm` (`col-sm-*`).                     |
| `colunasMd`            | `int?`   | `null`   | Sobrescreve `colunas` a partir de `md` (`col-md-*`).                     |
| `colunasLg`            | `int?`   | `null`   | Sobrescreve `colunas` a partir de `lg` (`col-lg-*`).                     |
| `colunasXl`            | `int?`   | `null`   | Sobrescreve `colunas` a partir de `xl` (`col-xl-*`).                     |
| `colunasXxl`           | `int?`   | `null`   | Sobrescreve `colunas` a partir de `xxl` (`col-xxl-*`).                   |
| `deslocamento`         | `int?`   | `0`      | Deslocamento (em colunas) antes desta coluna, a partir de `xs` (`offset-*`). |
| `deslocamentoSm`/`Md`/`Lg`/`Xl`/`Xxl` | `int?` | `null` | Sobrescreve `deslocamento` a partir do respectivo breakpoint.        |
| `ordem`                | `int?`   | `0`      | Posição de exibição a partir de `xs` (`order-*`). Menor aparece primeiro. |
| `ordemSm`/`Md`/`Lg`/`Xl`/`Xxl`         | `int?` | `null` | Sobrescreve `ordem` a partir do respectivo breakpoint.               |

### `GridLinha`

| Parâmetro             | Tipo                 | Padrão                        | Descrição                                                                 |
|--------------------------|------------------------|----------------------------------|--------------------------------------------------------------------------|
| `filhos`                   | `List<Widget>`          | obrigatório                       | Widgets da linha — idealmente `GridColuna`s.                             |
| `totalColunas`              | `int`                   | `12`                              | Número total de colunas do grid (equivalente a `$grid-columns` no Sass do Bootstrap). |
| `espacamentoHorizontal`     | `double`                | `24.0`                            | Espaçamento (gutter) entre colunas consecutivas. Não é aplicado nas bordas da linha. |
| `espacamentoVertical`       | `double`                | `24.0`                            | Espaçamento entre linhas, quando o conteúdo quebra por exceder `totalColunas`. |
| `alinhamentoHorizontal`     | `MainAxisAlignment`     | `MainAxisAlignment.start`         | Alinhamento horizontal das colunas (`justify-content-*`).                |
| `alinhamentoVertical`       | `CrossAxisAlignment`    | `CrossAxisAlignment.stretch`      | Alinhamento vertical das colunas (`align-items-*`). `stretch` iguala a altura de todas as colunas da linha. |
| `reverter`                  | `bool`                  | `false`                           | Inverte a ordem visual das colunas (`flex-row-reverse`).                 |

---

## Deslocamento (offset)

```dart
GridLinha(
  filhos: const [
    GridColuna(colunas: 4, deslocamento: 4, filho: Text('Centralizada (4+4+4)')),
  ],
)
```

---

## Reordenação (order)

```dart
GridLinha(
  filhos: const [
    GridColuna(colunas: 4, ordem: 2, filho: Text('Aparece por último')),
    GridColuna(colunas: 4, ordem: 1, filho: Text('Aparece primeiro')),
    GridColuna(colunas: 4, filho: Text('Ordem original (0)')),
  ],
)
```

`ordem` não move a coluna no código — só na exibição, exatamente como `order-*` no CSS.

---

## Grid aninhado

Assim como no Bootstrap, um `GridColuna` pode conter outro `GridLinha` dentro dele, formando um grid aninhado com seu próprio sistema de 12 colunas relativo à largura da coluna pai:

```dart
GridLinha(
  filhos: [
    GridColuna(
      colunas: 8,
      filho: GridLinha(
        filhos: const [
          GridColuna(colunas: 6, filho: Text('Aninhada A')),
          GridColuna(colunas: 6, filho: Text('Aninhada B')),
        ],
      ),
    ),
    const GridColuna(colunas: 4, filho: Text('Coluna simples')),
  ],
)
```

---

## Alinhamento e distribuição

```dart
GridLinha(
  alinhamentoHorizontal: MainAxisAlignment.spaceBetween,
  alinhamentoVertical: CrossAxisAlignment.center,
  filhos: const [
    GridColuna(colunas: 3, filho: Text('A')),
    GridColuna(colunas: 3, filho: Text('B')),
  ],
)
```

> `alinhamentoVertical: CrossAxisAlignment.stretch` (o padrão) usa `IntrinsicHeight` internamente para igualar a altura das colunas sem depender de restrições de altura do widget pai — funciona tanto dentro de um `Scaffold` quanto dentro de listas roláveis.

---

## Gutter customizado / sem gutter

```dart
GridLinha(
  espacamentoHorizontal: 0,
  espacamentoVertical: 8,
  filhos: const [
    GridColuna(colunas: 6, filho: ColorBox(color: Colors.red)),
    GridColuna(colunas: 6, filho: ColorBox(color: Colors.blue)),
  ],
)
```

---

## Grid com número de colunas customizado

```dart
GridLinha(
  totalColunas: 24,
  filhos: const [
    GridColuna(colunas: 8, filho: Text('1/3 de 24')),
    GridColuna(colunas: 16, filho: Text('2/3 de 24')),
  ],
)
```
