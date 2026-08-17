# MoneyDefault

Campo de texto para valores monetários — mesma proposta do [`InputDefault`](input_default.md), mas especializado em dinheiro: formata o valor digitado como moeda em tempo real (estilo "máscara de caixa eletrônico", onde cada dígito digitado empurra os anteriores para a esquerda), com quantidade de casas decimais e separadores de milhar/decimal configuráveis.

Estende `PlatformWidget`: mesma aparência de campo em todas as plataformas, com raio de borda levemente maior no iOS/macOS — mesmo padrão visual do `InputDefault`.

Arquivo: `lib/components/money_default.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

```dart
MoneyDefault(
  label: 'Valor do produto',
  onChanged: (valor) => print(valor), // double?
)
```

Por padrão, exibe o prefixo `R$` e formata com 2 casas decimais, separador de milhar `.` e separador decimal `,` (`R$ 12.345,67`).

`MoneyDefault` é internamente um `TextFormField` — funciona normalmente dentro de um `Form` com `formKey.currentState.validate()`.

---

## Como funciona a máscara

Diferente de um campo numérico comum, o valor é construído a partir dos **dígitos digitados**, não da posição do cursor — cada novo dígito é inserido no final da sequência de dígitos e o campo é reformatado inteiro a cada tecla, com o cursor sempre voltando para o final. É o mesmo comportamento de máscara monetária usado em caixas eletrônicos e na maioria dos apps bancários:

| Dígitos digitados | Texto exibido (padrão, 2 casas) |
|----------------------|-------------------------------------|
| `1`                    | `0,01`                                |
| `12`                   | `0,12`                                |
| `123`                  | `1,23`                                |
| `1234567`              | `12.345,67`                           |

---

## Parâmetros

| Parâmetro          | Tipo                          | Padrão   | Descrição                                                                 |
|-----------------------|---------------------------------|----------|------------------------------------------------------------------------------|
| `label`                 | `String`                        | `''`     | Rótulo flutuante do campo. `''` = nenhum rótulo.                             |
| `placeholder`           | `String`                        | `''`     | Texto de exemplo exibido quando o campo está vazio.                          |
| `required`              | `bool`                          | `true`   | Exibe `*` ao lado do rótulo e valida como obrigatório.                       |
| `readonly`              | `bool`                          | `false`  | Campo somente leitura (com fundo destacado), mas ainda focável.              |
| `disabled`              | `bool`                          | `false`  | Desabilita totalmente o campo (opacidade reduzida, sem interação).           |
| `casasDecimais`         | `int`                            | `2`      | Quantidade de casas decimais. `>= 0` — `2` para reais, `3` para outras moedas/unidades, `0` para valores inteiros sem centavos. Ver [Casas decimais](#casas-decimais). |
| `separadorMilhar`       | `String`                         | `'.'`    | Separador de agrupamento da parte inteira (a cada 3 dígitos). Use `''` para não agrupar. |
| `separadorDecimal`      | `String`                         | `','`    | Separador entre a parte inteira e a parte decimal. Ignorado quando `casasDecimais` é `0`. |
| `prefixo`               | `String?`                        | `'R$'`   | Texto de prefixo exibido antes do valor. `null`/`''` = sem prefixo.           |
| `min`                   | `double?`                        | `null`   | Valor mínimo permitido.                                                      |
| `max`                   | `double?`                        | `null`   | Valor máximo permitido.                                                      |
| `errorMessages`         | `Map<String, String>?`           | `null`   | Sobrepõe mensagens de erro por chave (`required`, `min`, `max`).             |
| `initialValue`          | `double?`                        | `null`   | Valor inicial (ignorado se `controller` for informado).                      |
| `controller`            | `TextEditingController?`         | `null`   | Controller externo. Se omitido, o componente cria e gerencia um internamente. |
| `focusNode`             | `FocusNode?`                     | `null`   | `FocusNode` externo. Se omitido, o componente cria e gerencia um internamente.|
| `onChanged`             | `ValueChanged<double?>?`         | `null`   | Chamado a cada digitação, com o valor numérico já convertido (`null` quando o campo está vazio). |
| `onBlur`                | `VoidCallback?`                  | `null`   | Chamado quando o campo perde o foco.                                          |
| `validator`             | `FormFieldValidator<double?>?`   | `null`   | Validação adicional, executada somente se `required`/`min`/`max` passarem.   |
| `errorText`             | `String?`                        | `null`   | Força uma mensagem de erro específica, com prioridade sobre todas as outras. |

> Valores negativos não são suportados nesta versão — um `initialValue` negativo é exibido pelo módulo (valor absoluto).

---

## Casas decimais

```dart
// Reais (padrão)
MoneyDefault(label: 'Preço', casasDecimais: 2)

// Moeda/unidade com 3 casas decimais
MoneyDefault(label: 'Cotação', casasDecimais: 3)

// Valor inteiro, sem centavos
MoneyDefault(label: 'Quantidade em estoque (unid.)', casasDecimais: 0, prefixo: null)
```

---

## Separadores customizados

Para o padrão americano (`1,234.56`), inverta os separadores:

```dart
MoneyDefault(
  label: 'Amount',
  prefixo: r'US$',
  separadorMilhar: ',',
  separadorDecimal: '.',
)
```

---

## Prefixo customizado / sem prefixo

```dart
MoneyDefault(label: 'Valor em dólar', prefixo: r'US$');
MoneyDefault(label: 'Valor em euro', prefixo: '€');
MoneyDefault(label: 'Percentual', prefixo: null); // sem prefixo
```

---

## Validação (`min`/`max`)

```dart
MoneyDefault(
  label: 'Valor do desconto',
  min: 0,
  max: 1000,
  errorMessages: const {'max': 'O desconto não pode passar de R\$ 1.000,00.'},
  onChanged: (valor) {},
)
```

A validação de `min`/`max` roda antes de `validator` (que só é chamado se `required`/`min`/`max` passarem), seguindo a mesma prioridade de mensagens de erro do `InputDefault`: `errorText` > `errorMessages[chave]` > dicionário padrão (`MoneyDefault.defaultErrorMessages`) > `'Campo inválido.'`.

---

## Valor inicial vindo do backend

```dart
MoneyDefault(
  label: 'Valor do pedido',
  initialValue: pedido.valorTotal, // double, ex.: 1234.5
  onChanged: (v) => setState(() => pedido.valorTotal = v ?? 0),
)
```

---

## Desabilitado / somente leitura

```dart
MoneyDefault(label: 'Valor pago', initialValue: 150.0, readonly: true);
MoneyDefault(label: 'Valor pago', initialValue: 150.0, disabled: true);
```
