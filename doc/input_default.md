# InputDefault

Campo de texto único do design system, com validação embutida (obrigatório, e-mail, min/max, minlength/maxlength), máscara simples, normalização de números e alternância de visibilidade de senha — inspirado no campo de formulário do Angular original (`required`/`errorMessages`/`type`).

Estende `PlatformWidget`: aparência Material em todas as plataformas, com raio de borda levemente maior no iOS/macOS.

Arquivo: `lib/components/input_default.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

```dart
InputDefault(
  label: 'E-mail',
  type: 'email',
  onChanged: (valor) => print(valor),
)
```

`InputDefault` é internamente um `TextFormField` — funciona normalmente dentro de um `Form` com `formKey.currentState.validate()`.

---

## Parâmetros

| Parâmetro        | Tipo                          | Padrão   | Descrição                                                                 |
|--------------------|---------------------------------|----------|------------------------------------------------------------------------------|
| `label`              | `String`                        | `''`     | Rótulo flutuante do campo. `''` = nenhum rótulo.                             |
| `type`                | `String`                        | `'text'` | Tipo do campo: `'text'`, `'password'`, `'number'`, `'email'`, `'date'`, `'datetime-local'`, `'time'`, ou qualquer outro valor (tratado como texto). Ver [Tipos](#tipos). |
| `placeholder`         | `String`                        | `''`     | Texto de exemplo exibido quando o campo está vazio.                          |
| `required`            | `bool`                          | `true`   | Exibe `*` ao lado do rótulo e valida como obrigatório.                       |
| `readonly`            | `bool`                          | `false`  | Campo somente leitura (com fundo destacado), mas ainda focável/selecionável. |
| `disabled`            | `bool`                          | `false`  | Desabilita totalmente o campo (opacidade reduzida, sem interação).           |
| `mask`                | `String?`                       | `null`   | Máscara simples de dígitos. Ver [Máscara](#máscara).                         |
| `slotChar`            | `String`                        | `'_'`    | Reservado para uso futuro por formatadores de máscara mais completos — o formatador atual não o utiliza. |
| `icon`                | `dynamic`                       | `null`   | Ícone prefixo — mesmos formatos aceitos por `IconeDefaultComponent` (`IconData`, `IconesDefault`, `IconesLucide`, `String`). |
| `errorMessages`       | `Map<String, String>?`          | `null`   | Sobrepõe mensagens de erro por chave (`required`, `email`, `minlength`, `maxlength`, `min`, `max`). |
| `maxlength`           | `int?`                          | `null`   | Limite de caracteres (aplicado via `TextInputFormatter`, impede digitar além do limite). |
| `minlength`           | `int?`                          | `null`   | Tamanho mínimo de caracteres (validação; não impede digitação).              |
| `min`                 | `double?`                       | `null`   | Valor mínimo (apenas `type: 'number'`).                                      |
| `max`                 | `double?`                       | `null`   | Valor máximo (apenas `type: 'number'`).                                      |
| `step`                | `double?`                       | `null`   | Reservado (equivalente ao `step` HTML); não é validado no momento.           |
| `autocomplete`        | `String`                        | `'off'`  | `'off'` desativa `autofillHints`; qualquer outro valor habilita hints de e-mail/senha conforme `type`. |
| `initialValue`        | `String?`                       | `null`   | Valor inicial (ignorado se `controller` for informado).                      |
| `controller`          | `TextEditingController?`        | `null`   | Controller externo. Se omitido, o componente cria e gerencia um internamente. |
| `focusNode`           | `FocusNode?`                    | `null`   | `FocusNode` externo. Se omitido, o componente cria e gerencia um internamente.|
| `onChanged`           | `ValueChanged<dynamic>?`        | `null`   | Chamado a cada digitação. Para `type: 'number'`, recebe `num?` já normalizado (ver [Números](#números)) em vez da `String` bruta. |
| `onBlur`              | `VoidCallback?`                 | `null`   | Chamado quando o campo perde o foco.                                          |
| `validator`           | `FormFieldValidator<String>?`   | `null`   | Validação adicional, executada somente se as validações internas passarem.   |
| `errorText`           | `String?`                       | `null`   | Força uma mensagem de erro específica, com prioridade sobre todas as outras. |

---

## Tipos

| `type`             | Teclado                                | Comportamento adicional                          |
|----------------------|-------------------------------------------|-----------------------------------------------------|
| `'text'` (padrão)      | texto                                     | —                                                    |
| `'password'`           | senha (`visiblePassword`)                 | Texto ocultado por padrão, com ícone de olho para alternar visibilidade. |
| `'number'`             | numérico (decimal, com sinal)             | Só aceita dígitos, `.`, `,` e `-`; valor de `onChanged` normalizado para `num?`. |
| `'email'`              | endereço de e-mail                        | Valida formato de e-mail (quando não vazio).         |
| `'date'` / `'datetime-local'` / `'time'` | `datetime`               | Apenas ajusta o teclado — não injeta um seletor de data/hora nativo. |
| outros valores         | texto                                      | —                                                     |

---

## Validação embutida

A validação interna roda antes de `validator` (que só é chamado se nenhum erro interno for encontrado) e cobre:

- `required`: campo vazio (após `trim()`) quando `required: true`.
- `email`: formato inválido quando `type: 'email'` e o campo não está vazio.
- `minlength`: menos caracteres que `minlength` (campo não vazio).
- `min`/`max`: valor numérico fora do intervalo, quando `type: 'number'` (usa o valor já normalizado por [`normalizeNumber`](#números)).

### Mensagens de erro

A mensagem exibida segue esta ordem de prioridade:

1. `errorText`, se informado (força a mensagem, ignorando o restante).
2. `errorMessages[chaveDoErro]`, se a chave (`required`, `email`, `minlength`, `maxlength`, `min`, `max`) estiver mapeada.
3. Dicionário padrão (`InputDefault.defaultErrorMessages`):

   | Chave     | Mensagem padrão                              |
   |-----------|-----------------------------------------------|
   | `required`  | `Este campo é obrigatório.`                   |
   | `email`     | `E-mail inválido.`                             |
   | `minlength` | `O valor é muito curto.`                       |
   | `maxlength` | `O valor é muito longo.`                       |
   | `min`       | `O valor é menor que o mínimo permitido.`      |
   | `max`       | `O valor é maior que o máximo permitido.`      |

4. `'Campo inválido.'`, como último fallback.

```dart
InputDefault(
  label: 'Idade',
  type: 'number',
  min: 18,
  errorMessages: const {'min': 'Você precisa ser maior de idade.'},
)
```

---

## Números

Quando `type: 'number'`, o valor entregue a `onChanged` já vem normalizado por `InputDefault.normalizeNumber` (aceita vírgula ou ponto decimal, retorna `double?`; `''`/`null` viram `null`):

```dart
InputDefault(
  label: 'Valor',
  type: 'number',
  onChanged: (valor) {
    // valor já é um double? (ex.: '1.234,56' e '1234.56' resolvem igual)
  },
)
```

---

## Máscara

`mask` define um padrão simples aplicado enquanto o usuário digita: `9`, `0` e `#` são placeholders de dígito; qualquer outro caractere é literal (inserido automaticamente).

```dart
InputDefault(
  label: 'CPF',
  mask: '000.000.000-00',
)

InputDefault(
  label: 'Telefone',
  mask: '(00) 00000-0000',
)
```

> A máscara atual é intencionalmente simples (apenas para padrões numéricos fixos) — não oferece validação de dígito verificador nem máscaras com múltiplos formatos condicionais.

---

## Com ícone

```dart
InputDefault(
  label: 'Buscar',
  iconeDefault: IconesDefault.search,
  icon: IconesDefault.search,
)
```

---

## Somente leitura / desabilitado

```dart
InputDefault(label: 'Código', initialValue: 'ABC-123', readonly: true);
InputDefault(label: 'Código', initialValue: 'ABC-123', disabled: true);
```

`readonly` mantém o campo focável/selecionável (só bloqueia edição); `disabled` bloqueia toda a interação e reduz a opacidade.
