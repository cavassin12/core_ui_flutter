# DatePickerDefault

Campo de seleção de data e/ou hora, que **reaproveita o [`InputDefault`](input_default.md) como campo de exibição** (rótulo, asterisco de obrigatório, estilo visual e mensagem de erro idênticos) e adiciona a abertura do seletor nativo de data/hora ao tocar no campo — o `InputDefault` sozinho já previa os tipos `'date'`/`'time'`/`'datetime-local'`, mas apenas ajustava o teclado, sem abrir nenhum seletor.

Estende `PlatformWidget`: abre `showDatePicker`/`showTimePicker` (Material) no Android/Web/Windows, e um `CupertinoDatePicker` (dentro de `showCupertinoModalPopup`) no iOS/macOS — variação **intencional**, já que os seletores nativos de data/hora têm aparência e interação bem distintas entre essas plataformas.

Arquivo: `lib/components/date_picker_default.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

```dart
DatePickerDefault(
  label: 'Data de nascimento',
  valor: dataNascimento,
  onChanged: (novaData) => setState(() => dataNascimento = novaData),
)
```

O campo é sempre somente-leitura para digitação (o texto exibido é formatado automaticamente a partir de `valor`) — tocar em qualquer parte do campo abre o seletor nativo.

---

## Parâmetros

| Parâmetro       | Tipo                              | Padrão                        | Descrição                                                                 |
|-------------------|-------------------------------------|--------------------------------|------------------------------------------------------------------------------|
| `label`             | `String`                            | `''`                            | Rótulo flutuante do campo (repassado ao `InputDefault` interno).            |
| `placeholder`       | `String`                            | `''`                            | Texto de exemplo exibido quando o campo está vazio.                         |
| `modo`              | `DatePickerModoDefault`             | `DatePickerModoDefault.data`    | Define se o seletor trabalha com data, hora, ou data e hora combinadas. Ver [Modo](#modo). |
| `valor`             | `DateTime?`                         | `null`                          | Valor selecionado (controlado externamente).                                |
| `dataMinima`        | `DateTime?`                         | `null` (`DateTime(1900)`)       | Data/hora mínima permitida.                                                  |
| `dataMaxima`        | `DateTime?`                         | `null` (`DateTime(2100)`)       | Data/hora máxima permitida.                                                  |
| `required`          | `bool`                              | `true`                          | Exibe `*` ao lado do rótulo e valida como obrigatório.                       |
| `readonly`          | `bool`                              | `false`                         | Bloqueia a abertura do seletor, com o mesmo tratamento visual de `disabled`. |
| `disabled`          | `bool`                              | `false`                         | Desabilita totalmente o campo (opacidade reduzida, sem interação).           |
| `errorMessages`     | `Map<String, String>?`              | `null`                          | Sobrepõe mensagens de erro por chave (`required`, `min`, `max`).             |
| `onChanged`         | `ValueChanged<DateTime?>?`          | `null`                          | Chamado com o novo valor selecionado.                                       |
| `validator`         | `FormFieldValidator<DateTime?>?`    | `null`                          | Validação adicional, executada somente se `required`/`min`/`max` passarem.  |
| `errorText`         | `String?`                           | `null`                          | Força uma mensagem de erro específica, com prioridade sobre todas as outras.|

`DatePickerDefault` é internamente um `FormField<DateTime?>` — funciona normalmente dentro de um `Form` com `formKey.currentState.validate()`.

---

## Modo

`DatePickerModoDefault` define quais seletores abrem e como o valor é formatado no campo:

| Valor                                      | Abre                                          | Formato exibido       |
|-----------------------------------------------|--------------------------------------------------|---------------------------|
| `DatePickerModoDefault.data` (padrão)          | Apenas o seletor de data.                        | `dd/MM/aaaa`               |
| `DatePickerModoDefault.hora`                   | Apenas o seletor de hora.                        | `HH:mm`                    |
| `DatePickerModoDefault.dataHora`               | Seletor de data, seguido do seletor de hora (Material) ou um único seletor combinado (Cupertino). | `dd/MM/aaaa HH:mm` |

```dart
DatePickerDefault(
  label: 'Horário de atendimento',
  modo: DatePickerModoDefault.hora,
  valor: horario,
  onChanged: (v) => setState(() => horario = v),
)
```

> No modo `hora`, a parte de **data** do `DateTime` retornado é irrelevante (herda a data de `valor` ou do momento em que o seletor foi aberto) — use apenas os campos `hour`/`minute` do valor.

---

## Intervalo permitido (`dataMinima`/`dataMaxima`)

```dart
DatePickerDefault(
  label: 'Data de nascimento',
  valor: dataNascimento,
  dataMaxima: DateTime.now(), // não permite datas futuras
  onChanged: (v) => setState(() => dataNascimento = v),
)

DatePickerDefault(
  label: 'Data de entrega',
  valor: dataEntrega,
  dataMinima: DateTime.now(), // não permite datas passadas
  onChanged: (v) => setState(() => dataEntrega = v),
)
```

O seletor nativo (`showDatePicker`/`CupertinoDatePicker`) já impede fisicamente escolher uma data fora do intervalo. Se `valor` for alterado programaticamente para fora do intervalo (fora do fluxo do próprio seletor), a validação de `Form.validate()` ainda acusa o erro `min`/`max`.

---

## Validação

```dart
DatePickerDefault(
  label: 'Data do exame',
  required: true,
  errorMessages: const {'required': 'Selecione a data do exame.'},
  valor: dataExame,
  onChanged: (v) => setState(() => dataExame = v),
)
```

> **Nuance de composição:** como o campo é renderizado via `InputDefault` (para reaproveitar o mesmo visual do restante do design system), a borda vermelha de erro reflete a validação própria do `InputDefault` (texto vazio = obrigatório), enquanto a *mensagem* de erro exibida abaixo do campo reflete a validação completa do `DatePickerDefault` (obrigatório + `min`/`max` + `validator` customizado). Na prática, isso só é perceptível em violações de `min`/`max`: a mensagem de erro aparece corretamente, mas a borda do campo não fica vermelha nesse caso específico.

---

## Desabilitado / somente leitura

```dart
DatePickerDefault(label: 'Criado em', valor: dataCriacao, readonly: true);
DatePickerDefault(label: 'Criado em', valor: dataCriacao, disabled: true);
```

---

## Tokens do design system usados

Nenhum diretamente — o campo herda a aparência (bordas, raio, cores de foco/erro) do [`InputDefault`](input_default.md), que atualmente usa cores fixas do `Theme` do Flutter (não do `CoreDesignSystemTheme`) para essas bordas.
