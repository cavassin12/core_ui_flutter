# IconeDefaultComponent

Componente único de ícone, que resolve o `IconData` a ser exibido a partir de várias formas de entrada (enum do catálogo padrão, `IconData` direto, ou nome de ícone [Lucide](https://lucide.dev) em texto), evitando que cada componente do design system precise reimplementar essa resolução.

`StatelessWidget` (sem variação por plataforma).

Arquivo: `lib/components/icone_default_component.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

```dart
IconeDefaultComponent(
  iconeDefault: IconesDefault.salvar,
  tamanho: 20,
  cor: Colors.white,
)
```

---

## Parâmetros

| Parâmetro    | Tipo       | Padrão      | Descrição                                                                 |
|---------------|-------------|--------------|------------------------------------------------------------------------------|
| `icone`        | `dynamic`    | `null`       | Aceita um `IconData` direto, um `IconesDefault`/`IconesLucide`, ou uma `String` com o nome do ícone. Ver [Resolução do ícone](#resolução-do-ícone). |
| `iconeDefault` | `IconesDefault?` | `null`   | Ícone do catálogo padrão do design system.                                  |
| `iconeLucide`  | `dynamic`    | `null`       | `IconData` direto, `IconesLucide`, ou `String` com o nome do ícone Lucide (kebab-case ou camelCase). Tem prioridade sobre `iconeDefault`/`icone`. |
| `tamanho`      | `dynamic`    | `'12'`       | Aceita `double`, `int` ou `String` numérica. Valores inválidos caem para `12.0`. |
| `cor`          | `dynamic`    | `'#ffffff'`  | Aceita um `Color` direto ou uma `String` hexadecimal (`#RRGGBB`, `#RGB`, `0xAARRGGBB`) ou `'currentColor'`. |

---

## Resolução do ícone

A ordem de prioridade para decidir qual `IconData` exibir é:

1. `icone` ou `iconeLucide`, se já forem um `IconData` do Flutter — usados diretamente.
2. `iconeLucide` (`IconesLucide` ou `String`).
3. `iconeDefault` (`IconesDefault`).
4. `icone` (convertido para `String` via `toString()`).

O identificador textual resultante é normalizado (`camelCase`/`snake_case`/espaços → `kebab-case`) e buscado no mapa interno de ícones [Lucide](https://pub.dev/packages/lucide_icons). Se nenhum identificador for resolvido ou o ícone não constar no mapa, o componente renderiza `SizedBox.shrink()` (nada é exibido) — não lança exceção.

```dart
// Pelo catálogo padrão do design system
IconeDefaultComponent(iconeDefault: IconesDefault.excluir)

// IconData do Flutter direto
IconeDefaultComponent(icone: Icons.favorite)

// Nome do ícone Lucide como texto
IconeDefaultComponent(iconeLucide: 'trash-2')
IconeDefaultComponent(iconeLucide: IconesLucide.dashboard)
```

---

## Cor (`cor`)

```dart
IconeDefaultComponent(iconeDefault: IconesDefault.aviso, cor: '#F59E0B'); // hex de 6 dígitos
IconeDefaultComponent(iconeDefault: IconesDefault.aviso, cor: '#FA0');    // hex curto (3 dígitos)
IconeDefaultComponent(iconeDefault: IconesDefault.aviso, cor: Colors.amber); // Color direto
IconeDefaultComponent(iconeDefault: IconesDefault.aviso, cor: 'currentColor'); // herda IconTheme.of(context).color
```

Hex sem canal alpha (`#RRGGBB` ou `#RGB`) recebe automaticamente `FF` de opacidade.

---

## Tamanho (`tamanho`)

```dart
IconeDefaultComponent(iconeDefault: IconesDefault.user, tamanho: 24);    // double/int
IconeDefaultComponent(iconeDefault: IconesDefault.user, tamanho: '24'); // String numérica
```

---

## Catálogo `IconesDefault`

`IconesDefault` (em `lib/types/icones_default.dart`) define os ícones de uso mais comum no design system (ex.: `salvar`, `editar`, `excluir`, `visualizar`, `filter`, `download`, `upload`, `calendario`, entre outros), cada um mapeado para um ícone Lucide. Para um ícone Lucide que não conste em `IconesDefault`, use `iconeLucide` com o nome kebab-case do ícone (conforme [lucide.dev](https://lucide.dev)) ou o enum auxiliar `IconesLucide`.
