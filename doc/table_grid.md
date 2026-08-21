# TableGrid

Componente único de tabela de dados (grade), com colunas dinâmicas, seleção de linhas, exportação CSV, expansão de sub-grade, ações por linha, paginação delegada ao pai (modo "lazy") e um filtro opcional de "mostrar excluídos" — porte do `TablegridComponent` (Angular + PrimeNG `p-table`) do projeto original.

Estende `PlatformWidget`, mas usa a mesma implementação em todas as plataformas (uma tabela densa de dados corporativos não tem uma variação visual nativa relevante entre Android/iOS/Web/Windows).

Arquivo: `lib/components/table_grid.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

```dart
TableGrid<Usuario>(
  data: usuarios,
  cols: const [
    DynamicColumnDTO(title: 'Nome', field: 'nome'),
    DynamicColumnDTO(title: 'E-mail', field: 'email'),
  ],
  resolverCampo: (row, campo) => row.toJson()[campo],
)
```

`TableGrid<T>` é genérico em `T` (o tipo de cada linha de `data`). Por padrão, o resolvedor de campos só entende `Map` — para listas de objetos fortemente tipados (como no exemplo acima), informe `resolverCampo` explicitamente, já que Dart não expõe reflection em builds de produção.

---

## Parâmetros

### Dados e colunas

| Parâmetro         | Tipo                                   | Padrão | Descrição                                                                 |
|---------------------|------------------------------------------|--------|------------------------------------------------------------------------------|
| `data`                | `List<T>`                                 | `[]`   | Linhas exibidas na grade principal.                                          |
| `cols`                | `List<DynamicColumnDTO>`                  | `[]`   | Colunas da grade principal. Ver [DynamicColumnDTO](#dynamiccolumndto).       |
| `resolverCampo`       | `dynamic Function(T row, String campo)?`  | `null` | Resolve o valor de um campo em uma linha. Padrão: só funciona com `Map<String, dynamic>`. |
| `exportarCSV`          | `bool`                                      | `false` | Exibe na última coluna do cabeçalho o botão que abre a seleção de colunas e exporta os dados atuais em CSV. |

Quando `exportarCSV` estiver ativo, todas as colunas visíveis de dados começam
selecionadas no modal. Colunas do tipo `botao` são ignoradas. O arquivo usa
UTF-8 com BOM e trata aspas, vírgulas e quebras de linha. Em grades com
paginação lazy, são exportadas as linhas presentes em `data` (a página
carregada), pois as demais páginas não estão disponíveis no componente.

### Seleção e reativação

| Parâmetro              | Tipo                     | Padrão                            | Descrição                                                                 |
|--------------------------|----------------------------|-------------------------------------|------------------------------------------------------------------------------|
| `mostrarChkItem`           | `bool`                      | `false`                             | Exibe uma coluna de checkbox para seleção múltipla de linhas.                |
| `aoSelecionados`            | `void Function(List<T>)?`  | `null`                              | Chamado a cada alteração na seleção, com a lista completa de linhas selecionadas. |
| `mostrarChkExcluidos`       | `bool`                      | `false`                             | Exibe um `Switch` no rodapé para alternar a exibição de registros excluídos. |
| `rotuloChkExcluidos`        | `String`                    | `'Mostrar Excluídos'`               | Rótulo ao lado do switch acima.                                              |
| `chkExcluidosSelecionado`   | `bool`                      | `false`                             | Estado controlado do switch acima.                                           |
| `aoChkExcluidos`            | `void Function(bool)?`      | `null`                              | Chamado quando o switch acima muda de estado.                                |
| `colunaExcluidos`           | `String`                    | `''`                                | Nome do campo (via `resolverCampo`) que indica exclusão - `null`/ausente = ativo, qualquer outro valor = excluído (ex.: uma coluna `dthrExclusao`). Usado para colorir a linha e exibir a ação de reativar quando habilitada. |
| `mostrarReativar`           | `bool`                      | `false`                             | Exibe a ação de reativar (só aparece em linhas marcadas como excluídas, se `colunaExcluidos` estiver definido). |
| `aoReativar`                | `void Function(T row)?`     | `null`                              | Chamado ao tocar na ação de reativar.                                        |

### Ações por linha

| Parâmetro          | Tipo                 | Padrão   | Descrição                                                                 |
|-----------------------|------------------------|----------|------------------------------------------------------------------------------|
| `aoVisualizar`            | `void Function(T)?`    | `null`   | Chamado ao tocar em qualquer parte de uma linha.                            |
| `acoesLinha`              | `List<TableAction<T>>` | `[]`     | Ações customizadas exibidas na coluna `TypeColunm.botao`. Ver [TableAction](#tableaction). |

Os botões padrão de visualizar, editar, excluir, upload e download não fazem parte do `TableGrid`. Para ações específicas de domínio, use `acoesLinha`. A ação de reativar permanece disponível para linhas excluídas quando `mostrarReativar` estiver habilitado.

### Paginação (lazy)

| Parâmetro          | Tipo                                  | Padrão   | Descrição                                                                 |
|-----------------------|------------------------------------------|----------|------------------------------------------------------------------------------|
| `mostrarPaginacao`      | `bool`                                    | `false`  | Exibe o rodapé de paginação ("Página X de Y" + botões anterior/próxima).    |
| `totalRegistros`        | `int`                                     | `0`      | Total de registros (de todas as páginas) — usado para calcular o total de páginas. |
| `totalPorPag`           | `int`                                     | `12`     | Quantidade de registros por página.                                          |
| `lazyLoadDados`         | `void Function(TableLazyLoadEvent)?`      | `null`   | Chamado ao mudar de página, com o índice do primeiro registro (`first`) e o tamanho da página (`rows`). Quem consome o componente é responsável por buscar a página correspondente e atualizar `data`. |

`TableGrid` **não pagina `data` internamente** — o modo é sempre "lazy": a grade sempre renderiza `data` como está, e cabe a quem a usa buscar a página certa em resposta a `lazyLoadDados`.

### Expansão (sub-grade por linha)

| Parâmetro         | Tipo                       | Padrão | Descrição                                                                 |
|----------------------|------------------------------|--------|------------------------------------------------------------------------------|
| `mostrarExpansao`      | `bool`                        | `false`| Exibe uma coluna de expansão (ícone `+`/`-`) no início de cada linha.        |
| `colsExpansao`         | `List<DynamicColumnDTO>`     | `[]`   | Colunas da sub-grade exibida ao expandir uma linha.                         |
| `campoExpansao`        | `String`                      | `''`   | Nome do campo (via `resolverCampo`) que contém as sub-linhas. Convenção: `null` = ainda não buscado/buscando (mostra "Carregando..."); lista vazia = já carregado e sem registros; lista não vazia = já carregado. |
| `aoExpandir`           | `void Function(T row)?`      | `null` | Chamado apenas quando uma linha é **expandida** (não ao recolher) — uso típico: buscar sob demanda os dados de `campoExpansao` na primeira expansão. |

### Rolagem

| Parâmetro       | Tipo       | Padrão   | Descrição                                                                 |
|--------------------|-------------|----------|------------------------------------------------------------------------------|
| `rolavel`             | `bool`       | `false`  | Mantém cabeçalho e paginação fixos, rolando somente as linhas.               |
| `alturaRolagem`       | `double?`    | `null`   | Altura fixa da área rolável. Só tem efeito se `rolavel: true` **e** `alturaRolagem` for informado. |

---

## `DynamicColumnDTO`

Define uma coluna (para `cols` ou `colsExpansao`):

| Parâmetro     | Tipo          | Padrão              | Descrição                                                              |
|-----------------|----------------|-----------------------|----------------------------------------------------------------------------|
| `title`           | `String`        | obrigatório           | Texto exibido no cabeçalho da coluna.                                     |
| `type`             | `TypeColunm`    | `TypeColunm.texto`     | Como o valor da célula é resolvido/exibido. Ver [TypeColunm](#typecolunm).|
| `field`            | `String`        | obrigatório           | Nome do campo (via `resolverCampo`) usado pela maioria dos tipos.         |
| `objeto`           | `String?`       | `null`                | Caminho usado pelos tipos `objeto` e `array` (ver abaixo).                |
| `visible`          | `bool`          | `true`                | Colunas com `visible: false` não são renderizadas nem contam na ordenação.|
| `width`            | `double?`       | `null`                | Largura fixa em pixels. `null` = coluna flexível (`Expanded`), dividindo o espaço restante. |
| `order`            | `int`           | `0`                    | Ordem de exibição entre as colunas visíveis (crescente).                  |
| `cellStyle`        | `TextStyle?`    | `TextStyle(fontSize: 13)` | Estilo do texto das células dessa coluna.                              |
| `headerStyle`      | `TextStyle?`    | `TextStyle(fontWeight: w700, fontSize: 11)` | Estilo do texto do cabeçalho dessa coluna.               |

### `TypeColunm`

| Valor                 | Exibe                                                                 |
|--------------------------|--------------------------------------------------------------------------|
| `texto` (padrão)           | `campo(row, field)` convertido para texto.                              |
| `textoConcatenado`         | Concatena vários campos: `field` é uma lista de nomes separados por `;` (ex.: `'nome;sobrenome'`), com espaço entre os valores. |
| `objeto`                    | Navega por um caminho de propriedades aninhadas: `objeto` é uma lista de segmentos separados por `;` (ex.: `'endereco;cidade'`), aplicando `resolverCampo` a cada nível. |
| `array`                      | Lista os valores de uma coleção: `objeto` aponta para o campo que contém a `List`; `field` (opcional) extrai uma propriedade de cada item da lista. |
| `botao`                      | Renderiza as ações de linha (`acoesLinha` + ações padrão). Não deve ser usada em `colsExpansao` (as ações recebem `T` da tabela principal). |
| `simNao`                     | `'Sim'`/`'Não'` conforme a "veracidade" do valor (estilo JavaScript: `0`, `''`, `null`, `false` = falso; qualquer outra coisa = verdadeiro). |
| `simNaoCard`                 | Badge colorido `'Sim'`/`'Não'`, comparando o valor estritamente com `true`. |
| `cor`                         | Exibe um ícone de tag colorido com a cor lida do campo.                   |
| `status`                      | Badge `'Ativo'`/`'Inativo'`, considerando `'Ativo'` quando o campo é `null` (convenção herdada do original: tipicamente aponta para uma coluna de exclusão, como `dthrExclusao` — `null` = não excluído). |
| `statusBoolean`               | Badge `'Ativo'`/`'Inativo'`, comparando o valor estritamente com `true`.  |
| `dataBR`                      | Formata a data (ISO) do campo para `dd/mm/aaaa`.                         |
| `dataHoraBR`                  | Formata a data/hora (ISO) do campo para `dd/mm/aaaa hh:mm`.               |

---

## `TableAction<T>`

Descreve uma ação customizada por linha, exibida antes das ações padrão:

| Parâmetro   | Tipo                       | Padrão       | Descrição                                                        |
|---------------|------------------------------|---------------|------------------------------------------------------------------|
| `icon`          | `String`                     | obrigatório   | Identificador Lucide (kebab-case) do ícone, consumido por `IconeDefaultComponent`. |
| `tooltip`       | `String`                     | obrigatório   | Texto do tooltip exibido ao passar/segurar o ícone.               |
| `color`         | `Color?`                     | `null` (azul padrão) | Cor do ícone.                                               |
| `canShow`       | `bool Function(T row)?`      | `null` (sempre mostra) | Decide, por linha, se a ação aparece.                    |
| `handler`       | `void Function(T row)`       | obrigatório   | Chamado ao tocar na ação.                                         |
| `permission`    | `String?`                    | `null`        | Mantido apenas como dado — `TableGrid` não o interpreta; quem monta a lista de ações filtra por permissão antes de passá-la. |

```dart
TableAction<Usuario>(
  icon: 'key-round',
  tooltip: 'Redefinir senha',
  handler: (usuario) => redefinirSenha(usuario),
  canShow: (usuario) => usuario.podeRedefinirSenha,
)
```

---

## `TableLazyLoadEvent`

Evento emitido por `lazyLoadDados` ao trocar de página:

| Campo   | Tipo   | Descrição                                     |
|-----------|--------|-------------------------------------------------|
| `first`     | `int`    | Índice (0-based) do primeiro registro da página solicitada. |
| `rows`      | `int`    | Quantidade de registros por página (`totalPorPag`).           |

---

## Exemplo completo

```dart
TableGrid<Map<String, dynamic>>(
  data: usuarios, // já é a página atual
  cols: const [
    DynamicColumnDTO(title: 'Nome', field: 'nome', order: 0),
    DynamicColumnDTO(title: 'Ativo', field: 'dthrExclusao', type: TypeColunm.status, order: 1),
  ],
  mostrarChkItem: true,
  exportarCSV: true,
  colunaExcluidos: 'dthrExclusao',
  mostrarReativar: true,
  mostrarPaginacao: true,
  totalRegistros: totalNoBackend,
  totalPorPag: 20,
  lazyLoadDados: (evento) => buscarPagina(evento.first, evento.rows),
  aoVisualizar: (row) => abrirDetalhes(row),
  aoReativar: (row) => reativarNoBackend(row),
  aoSelecionados: (selecionados) => print('${selecionados.length} selecionados'),
)
```

---

## Tokens do design system usados

| Token                | Uso                                                    |
|-----------------------|----------------------------------------------------------|
| `corFundo`              | Fundo da grade.                                          |
| `raioBorda`             | Raio das bordas da grade.                                |
| `corBorda`              | Borda externa da grade, linhas divisórias e borda superior da paginação. |
| `corCabecalhoTabela`    | Fundo do cabeçalho da grade e do painel de sub-grade (expansão). |
| `corLinhaSelecionada`   | Fundo da linha atualmente selecionada (após visualizar).  |
