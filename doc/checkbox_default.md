# CheckboxDefault

Checkbox customizado com transição animada de cor/borda entre os estados marcado/desmarcado, e suporte a widgets customizados dentro da caixa (não apenas o ícone de check padrão).

`StatefulWidget` (aparência única, sem variação por plataforma nem integração com `context.design` — os tokens do design system não são lidos por este componente).

Arquivo: `lib/components/checkbox_default.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

```dart
CheckboxDefault(
  isChecked: marcado,
  onTap: (novoValor) => setState(() => marcado = novoValor ?? false),
)
```

---

## Parâmetros

| Parâmetro           | Tipo                | Padrão                        | Descrição                                                                 |
|-----------------------|-----------------------|--------------------------------|------------------------------------------------------------------------------|
| `isChecked`             | `bool?`                | `false`                        | Estado inicial/controlado do checkbox.                                      |
| `onTap`                  | `Function(bool?)?`     | obrigatório                    | Chamado com o novo valor ao tocar no checkbox. **Passar `null` desabilita o checkbox** (ver [Desabilitado](#desabilitado)). |
| `checkedWidget`          | `Widget?`               | `Icon(Icons.check, color: Colors.white)` | Conteúdo exibido quando marcado.                                  |
| `uncheckedWidget`        | `Widget?`               | `SizedBox.shrink()`            | Conteúdo exibido quando desmarcado.                                          |
| `checkedColor`           | `Color?`                | `Colors.green`                 | Cor de fundo quando marcado.                                                 |
| `uncheckedColor`         | `Color?`                | `Theme.scaffoldBackgroundColor`| Cor de fundo quando desmarcado.                                              |
| `disabledColor`          | `Color?`                | `Theme.disabledColor`          | Cor de fundo/borda quando desabilitado (`onTap: null`).                      |
| `border`                 | `Border?`               | `Border.all(color: borderColor)` | Sobrepõe totalmente a borda calculada automaticamente.                    |
| `borderColor`            | `Color?`                | `Colors.grey`                  | Cor da borda (ignorado se `border` for informado).                          |
| `size`                    | `double?`               | `40.0`                         | Largura/altura do checkbox (é sempre quadrado).                             |
| `animationDuration`      | `Duration?`             | `Duration(milliseconds: 500)`  | Duração da transição animada entre os estados.                              |
| `isRound`                | `bool`                  | `true`                         | `true` = cantos totalmente arredondados (círculo); `false` = cantos retos (quadrado). |

---

## Desabilitado

Diferente dos demais componentes do pacote (que usam um parâmetro `disabled`), o `CheckboxDefault` fica desabilitado quando `onTap` é `null`:

```dart
CheckboxDefault(
  isChecked: true,
  onTap: null, // não responde a toques
  disabledColor: Colors.grey.shade300,
)
```

Nesse estado, o fundo e a borda usam `disabledColor` independentemente de `isChecked`.

---

## Widgets customizados

```dart
CheckboxDefault(
  isChecked: favorito,
  isRound: false,
  checkedWidget: const Icon(Icons.star, color: Colors.white, size: 20),
  uncheckedWidget: const Icon(Icons.star_border, color: Colors.grey, size: 20),
  checkedColor: Colors.amber,
  onTap: (v) => setState(() => favorito = v ?? false),
)
```
