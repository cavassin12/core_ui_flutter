# ProgressBarDefault

Barra de progresso linear, equivalente ao `.progress` do Bootstrap: progresso determinado (percentual conhecido) ou indeterminado (animação contínua, quando `valor` é `null` — útil para carregamentos sem percentual conhecido), com rótulo textual opcional.

Estende `PlatformWidget`, mas usa a mesma implementação em todas as plataformas — é baseado no `LinearProgressIndicator` nativo do Flutter, que já cobre a animação indeterminada sem necessidade de customização por plataforma.

Arquivo: `lib/components/progress_bar_default.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

```dart
ProgressBarDefault(valor: 0.65, exibirPercentual: true)
```

---

## Parâmetros

| Parâmetro           | Tipo       | Padrão                          | Descrição                                                                 |
|-----------------------|-------------|------------------------------------|------------------------------------------------------------------------------|
| `valor`                 | `double?`    | `null` (indeterminado)             | Progresso atual, de `0.0` a `1.0`. `null` = indeterminado (animação contínua, sem percentual). |
| `altura`                | `double`     | `16.0`                             | Altura da barra.                                                             |
| `cor`                   | `Color?`     | `context.design.corPrimaria`        | Cor preenchida da barra.                                                     |
| `corFundo`              | `Color?`     | `context.design.corBorda`           | Cor de fundo (trilha) da barra.                                             |
| `raioBorda`             | `double?`    | `context.design.raioBorda`          | Raio das bordas da barra.                                                    |
| `rotulo`                | `String?`    | `null`                             | Texto exibido acima da barra. Tem prioridade sobre `exibirPercentual`.       |
| `exibirPercentual`      | `bool`       | `false`                            | Exibe o percentual (`'65%'`) acima da barra, calculado a partir de `valor`. Ignorado quando `rotulo` é informado, ou quando `valor` é `null`. |

---

## Indeterminado

Quando `valor` é omitido (`null`), a barra exibe uma animação contínua — use para carregamentos onde o percentual não é conhecido:

```dart
ProgressBarDefault(rotulo: 'Enviando arquivo...')
```

---

## Com rótulo/percentual

```dart
// Percentual calculado automaticamente a partir de `valor`
ProgressBarDefault(valor: 0.4, exibirPercentual: true); // exibe "40%"

// Rótulo customizado (tem prioridade sobre exibirPercentual)
ProgressBarDefault(valor: 0.4, rotulo: '2 de 5 arquivos enviados');
```

---

## Cores e altura customizadas

```dart
ProgressBarDefault(
  valor: 0.8,
  altura: 8.0,
  cor: Colors.green,
  corFundo: Colors.green.shade50,
)
```

---

## Tokens do design system usados

| Token         | Uso                                   |
|---------------|-----------------------------------------|
| `corPrimaria`   | Cor preenchida padrão da barra.          |
| `corBorda`      | Cor de fundo (trilha) padrão da barra.   |
| `raioBorda`     | Raio das bordas padrão da barra.         |
