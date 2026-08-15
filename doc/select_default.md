# SelectDefault

Campo de seleção único do design system, com busca opcional (bottom sheet com filtro), suporte a listas de `Map` ou objetos, e integração com um fluxo de "cadastro auxiliar" (criar uma nova opção sem sair da tela).

Estende `PlatformWidget`: mesma aparência de campo em todas as plataformas, com raio de borda levemente maior no iOS/macOS.

Arquivo: `lib/components/select_default.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

```dart
SelectDefault(
  placeholder: 'Selecione o estado',
  options: const [
    {'label': 'São Paulo', 'value': 'SP'},
    {'label': 'Rio de Janeiro', 'value': 'RJ'},
  ],
  onChanged: (valor) => print(valor),
)
```

`SelectDefault` é internamente um `FormField` — funciona normalmente dentro de um `Form` com `formKey.currentState.validate()`.

---

## Parâmetros

| Parâmetro                  | Tipo                       | Padrão            | Descrição                                                                 |
|-------------------------------|-----------------------------|--------------------|------------------------------------------------------------------------------|
| `options`                       | `List<dynamic>`              | `[]`               | Opções — cada item pode ser um `Map` ou um objeto qualquer com as propriedades indicadas por `optionLabel`/`optionValue`. |
| `optionLabel`                   | `String`                     | `'label'`          | Nome da propriedade usada como rótulo exibido.                               |
| `optionValue`                   | `String`                     | `'value'`          | Nome da propriedade usada como valor selecionado.                            |
| `placeholder`                   | `String`                     | `'Selecione...'`   | Rótulo flutuante do campo. `''` = nenhum rótulo.                             |
| `filter`                        | `bool`                       | `true`             | `true` = abre um bottom sheet com busca; `false` = abre um menu suspenso simples. Ver [Modo de abertura](#modo-de-abertura). |
| `showClear`                     | `bool`                       | `true`             | Exibe um ícone "x" para limpar a seleção quando há um valor selecionado.     |
| `editable`                      | `bool`                       | `false`            | Reservado — atualmente não altera o comportamento do campo.                  |
| `required`                      | `bool`                       | `true`             | Valida como obrigatório (sem exibir `*` visual, diferente do `InputDefault`).|
| `disabled`                      | `bool`                       | `false`            | Desabilita totalmente o campo (opacidade reduzida, sem interação).           |
| `readonly`                      | `bool`                       | `false`            | Bloqueia a abertura do seletor, com fundo destacado (mesmo tratamento visual de `disabled`). |
| `value`                          | `dynamic`                    | `null`             | Valor selecionado (controlado externamente).                                 |
| `itemCadastrado`                | `dynamic`                    | `null`             | Item recém-criado fora do componente — ao mudar, é adicionado às opções (se ainda não existir) e selecionado automaticamente. Ver [Cadastro auxiliar](#cadastro-auxiliar). |
| `onChanged`                     | `ValueChanged<dynamic>?`     | `null`             | Chamado com o novo valor selecionado.                                        |
| `permitirCadastroAuxiliar`      | `bool`                       | `false`            | Exibe um botão "+ (texto)" ao lado do campo. Ver [Cadastro auxiliar](#cadastro-auxiliar). |
| `rotaCadastroAuxiliar`          | `String?`                    | `null`             | Quando informado (e `permitirCadastroAuxiliar: false`), exibe um botão apenas com ícone "+". O valor em si não é usado internamente — cabe a quem consome navegar até essa rota dentro de `onCadastroAuxiliarSolicitado`. |
| `textoCadastroAuxiliar`         | `String`                     | `'Novo'`           | Texto do botão de cadastro auxiliar (quando `permitirCadastroAuxiliar: true`).|
| `onCadastroAuxiliarSolicitado`  | `VoidCallback?`              | `null`             | Chamado ao tocar no botão de cadastro auxiliar.                              |
| `errorMessages`                  | `Map<String, String>?`       | `null`             | Sobrepõe a mensagem de erro para a chave `required`.                         |
| `validator`                      | `FormFieldValidator<dynamic>?` | `null`           | Validação adicional, executada somente se a validação de `required` passar.  |
| `errorText`                      | `String?`                    | `null`             | Força uma mensagem de erro específica, com prioridade sobre todas as outras. |

---

## Formato das opções

Cada item de `options` pode ser um `Map` ou um objeto Dart qualquer — a leitura das propriedades `optionLabel`/`optionValue` é feita dinamicamente (via `[]` para `Map`, ou acesso dinâmico de propriedade para outros objetos; se falhar, usa o próprio item como valor/rótulo).

```dart
// Map (mais comum)
SelectDefault(
  optionLabel: 'nome',
  optionValue: 'id',
  options: const [
    {'id': 1, 'nome': 'Ativo'},
    {'id': 2, 'nome': 'Inativo'},
  ],
)
```

---

## Modo de abertura

```dart
// filter: true (padrão) — bottom sheet com busca
SelectDefault(filter: true, options: const [/* muitas opções */]);

// filter: false — menu suspenso simples, sem busca
SelectDefault(filter: false, options: const [/* poucas opções */]);
```

Com `filter: true`, tocar no campo abre um `showModalBottomSheet` com um campo de busca (filtra pelo rótulo, sem diferenciar maiúsculas/minúsculas) e a lista de opções, com a opção selecionada destacada. Com `filter: false`, tocar no campo abre um `showMenu` ancorado no próprio campo.

---

## Limpar seleção

```dart
SelectDefault(showClear: true, value: valorAtual, options: const [/* ... */]);
```

Com `showClear: true` e um valor selecionado, um ícone "x" aparece antes da seta — tocar nele chama `onChanged(null)`.

---

## Cadastro auxiliar

Padrão para permitir criar uma nova opção sem sair da tela atual — o componente não abre nenhum formulário sozinho; ele apenas expõe o botão e reage quando o pai informa o item criado via `itemCadastrado`:

```dart
SelectDefault(
  options: categorias,
  optionLabel: 'nome',
  optionValue: 'id',
  value: categoriaSelecionada,
  permitirCadastroAuxiliar: true,
  textoCadastroAuxiliar: 'Nova categoria',
  itemCadastrado: categoriaRecemCriada, // ex.: retorno de um dialog de cadastro
  onCadastroAuxiliarSolicitado: () async {
    final nova = await abrirDialogNovaCategoria(context);
    setState(() => categoriaRecemCriada = nova);
  },
  onChanged: (id) => setState(() => categoriaSelecionada = id),
)
```

Ao `itemCadastrado` mudar para um valor não nulo, o componente: adiciona o item à lista local de opções (se ainda não existir, comparando por `optionValue`) e o seleciona automaticamente, chamando `onChanged`.

---

## Validação

Como o campo não exibe `*` junto ao rótulo (diferente de `InputDefault`), a obrigatoriedade só se manifesta através da mensagem de erro abaixo do campo ao validar o `Form`:

```dart
SelectDefault(
  required: true,
  errorMessages: const {'required': 'Selecione uma opção antes de continuar.'},
  options: const [/* ... */],
)
```

Sem `required: true`, nenhuma validação de obrigatoriedade é aplicada; `validator` (se informado) ainda é chamado normalmente.
