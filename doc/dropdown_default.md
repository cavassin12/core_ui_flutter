# DropdownDefault

Componente único de dropdown, inspirado no **Dropdown do Bootstrap**, com botão trigger (ícone/texto), direção de abertura (dropdown/dropup), itens com ícone/estado ativo/desabilitado, divisores, cabeçalhos de seção, tamanhos (sm/normal/lg), variante dark do menu e comportamento de fechamento automático configurável.

Estende `PlatformWidget`: aparência Material em todas as plataformas, com pequenos ajustes de cursor/hover no Web.

Arquivo: `lib/components/dropdown_default.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

```dart
DropdownDefault(
  texto: 'Ações',
  items: [
    DropdownItemDefault(label: 'Editar', onTap: () {}),
    DropdownItemDefault(label: 'Excluir', onTap: () {}),
  ],
)
```

O menu é posicionado com `CompositedTransformTarget`/`CompositedTransformFollower` em um `OverlayEntry` — funciona corretamente dentro de listas, scrolls e outros contextos de layout, sem ser cortado por `ClipRect` de widgets pais.

---

## Parâmetros de `DropdownDefault`

| Parâmetro    | Tipo                        | Padrão                          | Descrição                                                                 |
|--------------|------------------------------|----------------------------------|------------------------------------------------------------------------------|
| `items`      | `List<DropdownItemDefault>` | obrigatório                      | Itens exibidos no menu, na ordem desejada.                                   |
| `texto`      | `String?`                    | `null`                           | Texto exibido no botão trigger.                                              |
| `icone`      | `IconData?`                  | `null`                           | Ícone customizado (Flutter `IconData`) exibido à esquerda do texto no trigger. |
| `iconeDefault` | `IconesDefault?`            | `null`                           | Ícone do catálogo padrão do design system, exibido à esquerda do texto no trigger. |
| `tipo`       | `TipoBotao?`                 | `null` (severidade primária)     | Define a cor do botão trigger, reaproveitando os mesmos valores de `ButtonDefault` (`primary`, `erro`, `aviso`, `sucesso`, `info`, `defaultType`, etc.). |
| `tamanho`    | `DropdownSizeDefault`        | `DropdownSizeDefault.normal`     | Tamanho do botão trigger. Ver [Tamanhos](#tamanhos).                        |
| `direcao`    | `DropdownDirectionDefault`   | `DropdownDirectionDefault.down`  | Direção de abertura do menu. Ver [Direção de abertura](#direção-de-abertura). |
| `autoClose`  | `DropdownAutoCloseDefault`   | `DropdownAutoCloseDefault.always`| Comportamento de fechamento automático. Ver [Auto-close](#auto-close).      |
| `dark`       | `bool`                        | `false`                          | Aplica a variante escura ao menu (equivalente a `dropdown-menu-dark`).      |
| `disabled`   | `bool`                        | `false`                          | Desabilita o trigger (opacidade reduzida e sem interação).                  |
| `menuWidth`  | `double?`                     | `null`                           | Largura fixa do menu. Se omitido, usa a largura do próprio botão trigger, com mínimo de 180px. |

---

## `DropdownItemDefault`

Cada item do menu é descrito por um `DropdownItemDefault`. Além do construtor padrão (item clicável), há construtores nomeados para os itens não clicáveis do Bootstrap:

| Construtor                              | Equivalente Bootstrap    | Descrição                                          |
|------------------------------------------|----------------------------|-----------------------------------------------------|
| `DropdownItemDefault(...)`                | `.dropdown-item`            | Item clicável, com `label` obrigatório.             |
| `DropdownItemDefault.divider()`           | `.dropdown-divider`         | Linha divisória entre grupos de itens.               |
| `DropdownItemDefault.header(texto)`       | `.dropdown-header`          | Texto de cabeçalho de seção (não clicável).          |
| `DropdownItemDefault.texto(texto)`        | `.dropdown-item-text`       | Texto estático dentro do menu (não clicável).        |

### Parâmetros do construtor padrão

| Parâmetro      | Tipo             | Padrão       | Descrição                                                      |
|-----------------|-------------------|--------------|--------------------------------------------------------------------|
| `label`          | `String`          | obrigatório  | Texto exibido no item.                                            |
| `icone`           | `IconData?`       | `null`       | Ícone customizado exibido à esquerda do texto.                    |
| `iconeDefault`    | `IconesDefault?`  | `null`       | Ícone do catálogo padrão exibido à esquerda do texto.              |
| `onTap`           | `VoidCallback?`   | `null`       | Chamado ao tocar/clicar no item (ignorado se `disabled: true`).   |
| `active`          | `bool`            | `false`      | Destaca o item com a cor primária do tema (equivalente a `.active`). |
| `disabled`        | `bool`            | `false`      | Desabilita o item — fica acinzentado e não dispara `onTap`.        |

```dart
DropdownDefault(
  texto: 'Ações',
  iconeDefault: IconesDefault.ajustar,
  items: [
    DropdownItemDefault.header('Conta'),
    DropdownItemDefault(label: 'Perfil', iconeDefault: IconesDefault.user, onTap: () {}),
    DropdownItemDefault(label: 'Configurações', iconeDefault: IconesDefault.gear, active: true, onTap: () {}),
    DropdownItemDefault.divider(),
    DropdownItemDefault(label: 'Excluir conta', disabled: true, onTap: () {}),
    DropdownItemDefault.texto('v1.0.0'),
  ],
)
```

---

## Tamanhos

`DropdownSizeDefault` reproduz as classes `btn-sm` / `btn-lg` do Bootstrap, ajustando altura, fonte e espaçamento interno do trigger:

| Valor                              | Altura | Fonte |
|-------------------------------------|--------|-------|
| `DropdownSizeDefault.small`          | 28     | 12    |
| `DropdownSizeDefault.normal` (padrão)| 36     | 14    |
| `DropdownSizeDefault.large`          | 44     | 16    |

```dart
DropdownDefault(
  texto: 'Filtrar',
  tamanho: DropdownSizeDefault.small,
  items: const [/* ... */],
)
```

---

## Direção de abertura

`DropdownDirectionDefault` controla se o menu abre para baixo (`dropdown`) ou para cima (`dropup`) do trigger. O ícone de seta no trigger acompanha a direção escolhida:

```dart
DropdownDefault(
  texto: 'Opções',
  direcao: DropdownDirectionDefault.up,
  items: const [/* ... */],
)
```

Use `direcao: DropdownDirectionDefault.up` quando o dropdown estiver próximo do rodapé da tela e não houver espaço suficiente abaixo dele.

---

## Auto-close

`DropdownAutoCloseDefault` reproduz o atributo `data-bs-auto-close` do Bootstrap, controlando quando o menu fecha automaticamente:

| Valor                                        | Clique dentro (item) | Clique fora | Tecla Esc |
|------------------------------------------------|:---------------------:|:-----------:|:---------:|
| `DropdownAutoCloseDefault.always` (padrão)      | fecha                 | fecha       | fecha     |
| `DropdownAutoCloseDefault.insideClick`          | fecha                 | mantém aberto | fecha   |
| `DropdownAutoCloseDefault.outsideClick`         | mantém aberto          | fecha       | fecha     |
| `DropdownAutoCloseDefault.manual`               | mantém aberto          | mantém aberto | fecha   |

Em todos os casos, `onTap` do item é sempre executado, independentemente de o menu fechar ou não. Com `manual`, o menu só fecha tocando novamente no trigger, pressionando Esc, ou programaticamente.

```dart
DropdownDefault(
  texto: 'Selecionar múltiplos',
  autoClose: DropdownAutoCloseDefault.insideClick,
  items: [
    DropdownItemDefault(label: 'Opção A', onTap: () {}),
    DropdownItemDefault(label: 'Opção B', onTap: () {}),
  ],
)
```

---

## Variante dark

```dart
DropdownDefault(
  texto: 'Tema escuro',
  dark: true,
  items: const [/* ... */],
)
```

Aplica fundo escuro (`#343A40`) ao menu, com textos e divisores adaptados para contraste — o botão trigger não é afetado por `dark` (use `tipo` para controlar a cor do trigger).

---

## Cores do trigger (`tipo`)

O trigger reaproveita os mesmos valores de `TipoBotao` usados pelo `ButtonDefault`:

```dart
DropdownDefault(
  texto: 'Excluir selecionados',
  tipo: TipoBotao.erro,
  items: const [/* ... */],
)
```

Sem `tipo` informado, o trigger usa a severidade `primary`, cuja cor de fundo é lida do token `corPrimaria` do design system (ver seção seguinte).

---

## Tokens do design system usados

O componente lê os seguintes tokens de `context.design` (`CoreDesignSystemTheme`):

| Token         | Uso                                                          |
|---------------|---------------------------------------------------------------|
| `corPrimaria` | Cor de fundo do trigger com severidade `primary` e destaque dos itens `active` |
| `raioBorda`   | Raio das bordas do trigger e do menu                          |

Se o app hospedeiro não registrar `CoreDesignSystemTheme` no `ThemeData`, os valores padrão do fallback (`corPrimaria: Colors.blue`, `raioBorda: 8.0`) são usados.

---

## Desabilitado

```dart
DropdownDefault(
  texto: 'Indisponível',
  disabled: true,
  items: const [/* ... */],
)
```

Quando `disabled: true`, o trigger fica com opacidade reduzida e não responde a toques; se o menu já estiver aberto no momento em que `disabled` mudar para `true`, ele é fechado automaticamente.
