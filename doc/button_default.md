# ButtonDefault

Componente único de botão do design system, com resolução automática de cor por severidade (equivalente às classes `btn-primary`/`btn-danger`/`btn-warning`/`btn-success`/`btn-info` do Bootstrap), suporte a ícone + texto e variação de tamanho (`btn-sm`).

Estende `PlatformWidget`: Material no Android/Web/Windows e Cupertino no iOS/macOS.

Arquivo: `lib/components/button_default.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

```dart
ButtonDefault(
  texto: 'Salvar',
  tipo: TipoBotao.xPrimary,
  acaoExecutar: () {},
)
```

---

## Parâmetros

| Parâmetro       | Tipo             | Padrão | Descrição                                                                 |
|------------------|-------------------|--------|------------------------------------------------------------------------------|
| `texto`           | `String?`          | `null` | Texto exibido no botão.                                                     |
| `icone`            | `IconData?`        | `null` | Ícone customizado (Flutter `IconData`) exibido à esquerda do texto.         |
| `iconeDefault`     | `IconesDefault?`   | `null` | Ícone do catálogo padrão do design system, exibido à esquerda do texto.     |
| `tipo`             | `TipoBotao?`       | `null` (severidade primária) | Define cor e tamanho do botão. Ver [Severidade e tamanho](#severidade-e-tamanho). |
| `disabled`         | `bool`             | `false`| Desabilita o botão (opacidade reduzida e sem interação).                    |
| `corTexto`         | `Color?`           | `null` | Sobrepõe a cor do texto/ícone calculada automaticamente pela severidade.    |
| `tamanho`          | `double`           | `18.0` | Tamanho do ícone (ajustado automaticamente quando `tipo` é pequeno — ver abaixo). |
| `largura`          | `double?`          | `null` | Largura fixa do botão. `null` = largura pelo conteúdo.                      |
| `altura`           | `double?`          | `30.0` | Altura do botão (ajustada automaticamente quando `tipo` é pequeno).         |
| `acaoExecutar`     | `VoidCallback?`    | `null` | Chamado ao tocar/clicar no botão (ignorado se `disabled: true`).            |

---

## Severidade e tamanho

`TipoBotao` reproduz as combinações de classes `btn btn-{severidade}` e `btn-sm` do Bootstrap:

| Valor                    | Severidade  | Tamanho |
|----------------------------|-------------|---------|
| `TipoBotao.defaultType`      | padrão (cor do tema) | pequeno (`btn-sm`) |
| `TipoBotao.info`             | info        | pequeno |
| `TipoBotao.aviso`            | warn        | pequeno |
| `TipoBotao.erro`             | danger      | pequeno |
| `TipoBotao.primary`          | primary     | pequeno |
| `TipoBotao.sucesso`          | success     | pequeno |
| `TipoBotao.xDefault`         | padrão (cor do tema) | normal |
| `TipoBotao.xInfo`            | info        | normal |
| `TipoBotao.xAviso`           | warn        | normal |
| `TipoBotao.xErro`            | danger      | normal |
| `TipoBotao.xPrimary`         | primary     | normal |
| `TipoBotao.xSucesso`         | success     | normal |

Sem `tipo` informado, o botão usa a severidade `primary` no tamanho normal.

Quando o tamanho é pequeno (variantes sem `x`), a altura padrão passa a ser `24.0` (a menos que `altura` seja explicitamente customizado) e o ícone é reduzido para `12.0` (quando `tamanho` não tiver sido customizado).

### Cores por severidade

| Severidade   | Cor de fundo                              |
|---------------|--------------------------------------------|
| `primary`      | cor primária do tema (`Theme.colorScheme.primary`) |
| `danger`       | `Theme.colorScheme.error`                  |
| `warn`         | `Colors.orange.shade700`                   |
| `success`      | `#22C55E`                                  |
| `info`         | `#3B82F6`                                  |
| `secondary`    | `Theme.colorScheme.secondary`              |

### Cor do texto/ícone

Por padrão, botões `defaultType`/`xDefault` usam `Theme.colorScheme.onSurface` (contraste com fundo neutro); as demais severidades usam branco. Use `corTexto` para sobrepor esse cálculo em qualquer caso.

---

## Detecção automática de ação de inclusão

Quando `tipo` tem severidade `success` (`sucesso`/`xSucesso`) **e** o texto do botão começa com um verbo de inclusão (`incluir`, `adicionar`, `novo`, `nova`, `cadastrar`, `criar` — comparação sem acentos e case-insensitive), o botão usa a cor `primary` em vez de `success`. Isso reproduz uma regra de negócio herdada do componente Angular original: botões de "adicionar" usam a cor de destaque do app, e não o verde de confirmação.

```dart
ButtonDefault(texto: 'Adicionar item', tipo: TipoBotao.xSucesso, acaoExecutar: () {}); // fica primary
ButtonDefault(texto: 'Confirmar', tipo: TipoBotao.xSucesso, acaoExecutar: () {});      // fica success (verde)
```

---

## Com ícone

```dart
ButtonDefault(
  iconeDefault: IconesDefault.plus,
  texto: 'Novo registro',
  tipo: TipoBotao.xPrimary,
  acaoExecutar: () {},
)
```

Sem `texto` (apenas `icone`/`iconeDefault`), o botão vira um botão somente-ícone.

---

## Desabilitado

```dart
ButtonDefault(
  texto: 'Enviar',
  disabled: true,
  acaoExecutar: () {},
)
```

O fundo e o texto/ícone ficam com opacidade reduzida, e `acaoExecutar` deixa de ser chamado.

---

## Diferenças entre plataformas

| Plataforma | Aparência                                                              |
|-------------|--------------------------------------------------------------------------|
| Android     | `Material` + `InkWell` com splash padrão.                               |
| iOS/macOS   | `CupertinoButton` com cor de fundo e desabilitado nativos.               |
| Web         | Igual ao Android, mas com `MouseRegion` (cursor de clique/proibido) e hover translúcido. |
| Windows     | `Material` + `InkWell` com borda sutil (`Colors.black` a 8% de opacidade) para destacar o botão em fundos claros. |
