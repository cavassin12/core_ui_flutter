# DialogDefault

Componente único de dialog/modal do design system, reproduzindo o comportamento do **Modal do Bootstrap** (tamanhos, centralização, rolagem, backdrop estático, fechamento por ESC/clique fora, cabeçalho/corpo/rodapé customizáveis e variante tela-cheia).

Estende `PlatformWidget`: usa aparência Cupertino no iOS/macOS e Material nas demais plataformas (Android, Web, Windows, Linux).

Arquivo: `lib/components/dialog_default.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

O componente é sempre exibido através do método estático `DialogDefault.show`, que abre a modal com `showGeneralDialog` (barreira escurecida, animação de fade + escala e fechamento por ESC já configurados).

```dart
DialogDefault.show(
  context: context,
  titulo: 'Confirmação',
  corpo: const Text('Deseja salvar as alterações?'),
  acoes: [
    TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('Cancelar'),
    ),
    FilledButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('Salvar'),
    ),
  ],
);
```

`DialogDefault.show<T>` retorna um `Future<T?>` com o valor passado para `Navigator.pop(valor)` — útil para retornar dados do dialog para quem o abriu.

```dart
final confirmou = await DialogDefault.show<bool>(
  context: context,
  titulo: 'Excluir item',
  corpo: const Text('Esta ação não pode ser desfeita.'),
  acoes: [
    TextButton(
      onPressed: () => Navigator.of(context).pop(false),
      child: const Text('Cancelar'),
    ),
    FilledButton(
      onPressed: () => Navigator.of(context).pop(true),
      child: const Text('Excluir'),
    ),
  ],
);

if (confirmou == true) {
  // ...
}
```

---

## Atalho: confirmar/cancelar

Para o padrão mais comum de modal (confirmar ou cancelar uma ação), use `DialogDefault.confirmar`, que já monta o cabeçalho, a mensagem e os dois botões de ação:

```dart
final confirmou = await DialogDefault.confirmar(
  context: context,
  titulo: 'Excluir item',
  mensagem: 'Esta ação não pode ser desfeita.',
  textoConfirmar: 'Excluir',
  textoCancelar: 'Cancelar',
  destrutivo: true, // deixa o botão de confirmar vermelho
);

if (confirmou) {
  // usuário confirmou
}
```

`confirmar` retorna sempre um `bool` (nunca `null`): `true` se o usuário confirmar, `false` se cancelar, fechar pelo "x", apertar ESC ou clicar fora do dialog.

### Parâmetros de `confirmar`

| Parâmetro          | Tipo     | Padrão          | Descrição                                              |
|---------------------|----------|-----------------|----------------------------------------------------------|
| `context`            | `BuildContext` | obrigatório | Contexto de onde o dialog será exibido.                |
| `titulo`             | `String` | obrigatório     | Título exibido no cabeçalho.                             |
| `mensagem`           | `String` | obrigatório     | Texto exibido no corpo do dialog.                        |
| `textoConfirmar`     | `String` | `'Confirmar'`   | Texto do botão de confirmação.                            |
| `textoCancelar`      | `String` | `'Cancelar'`    | Texto do botão de cancelamento.                           |
| `destrutivo`         | `bool`   | `false`         | Quando `true`, deixa o botão de confirmar vermelho (ações destrutivas, como exclusão). |
| `backdropEstatico`   | `bool`   | `false`         | Ver seção [Backdrop estático](#backdrop-estático).        |

---

## Parâmetros de `DialogDefault.show`

| Parâmetro           | Tipo             | Padrão                | Descrição                                                                 |
|-----------------------|------------------|------------------------|------------------------------------------------------------------------------|
| `context`              | `BuildContext`   | obrigatório            | Contexto de onde o dialog será exibido.                                     |
| `titulo`               | `String?`        | `null`                 | Título exibido no cabeçalho padrão. Ignorado se `cabecalho` for informado.  |
| `cabecalho`            | `Widget?`        | `null`                 | Substitui totalmente o cabeçalho padrão (título + botão fechar).            |
| `corpo`                | `Widget`         | obrigatório            | Conteúdo principal do dialog.                                                |
| `acoes`                | `List<Widget>?`  | `null`                 | Ações exibidas no rodapé (normalmente botões), alinhadas à direita.         |
| `tamanho`              | `DialogTamanho`  | `DialogTamanho.medio`  | Tamanho do dialog. Ver [Tamanhos](#tamanhos).                               |
| `centralizado`         | `bool`           | `true`                 | Centraliza o dialog verticalmente na tela. Quando `false`, fica ancorado próximo ao topo. |
| `rolavel`              | `bool`           | `false`                | Permite rolagem interna do corpo quando o conteúdo excede a altura disponível. |
| `exibirBotaoFechar`    | `bool`           | `true`                 | Exibe o botão "x" de fechar no cabeçalho padrão.                            |
| `backdropEstatico`     | `bool`           | `false`                | Ver [Backdrop estático](#backdrop-estático).                                |
| `fecharComEsc`         | `bool`           | `true`                 | Habilita/desabilita o fechamento pela tecla ESC.                            |
| `corBarreira`          | `Color?`         | `Colors.black54`       | Cor do fundo escurecido atrás do dialog.                                     |
| `animado`              | `bool`           | `true`                 | Aplica transição de fade + escala. `false` abre o dialog instantaneamente.  |

---

## Tamanhos

`DialogTamanho` reproduz as classes `modal-sm`, `modal-lg`, `modal-xl` e `modal-fullscreen` do Bootstrap:

| Valor                        | Largura máxima | Equivalente Bootstrap |
|-------------------------------|-----------------|-------------------------|
| `DialogTamanho.pequeno`       | 320             | `modal-sm`               |
| `DialogTamanho.medio` (padrão)| 500             | `modal-dialog` (padrão)  |
| `DialogTamanho.grande`        | 760             | `modal-lg`                |
| `DialogTamanho.extraGrande`   | 1100            | `modal-xl`                |
| `DialogTamanho.telaCheia`     | ocupa toda a tela | `modal-fullscreen`     |

```dart
DialogDefault.show(
  context: context,
  tamanho: DialogTamanho.grande,
  titulo: 'Detalhes do pedido',
  corpo: const DetalhesPedidoForm(),
);
```

Na variante `telaCheia`, o dialog ocupa toda a tela (sem bordas arredondadas, sem margens) e o corpo já é envolvido em `SafeArea` + rolagem automática.

---

## Corpo rolável

Para conteúdos longos que não devem estourar a altura da tela (equivalente a `modal-dialog-scrollable`), use `rolavel: true`. O dialog já limita a altura máxima a 90% da altura da tela e adiciona rolagem interna ao corpo, mantendo cabeçalho e rodapé fixos:

```dart
DialogDefault.show(
  context: context,
  titulo: 'Termos de uso',
  rolavel: true,
  corpo: const TermosDeUsoTexto(), // conteúdo longo
  acoes: [
    FilledButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('Aceitar'),
    ),
  ],
);
```

---

## Backdrop estático

Por padrão (`backdropEstatico: false`), clicar fora do dialog ou apertar ESC fecha a modal. Quando `backdropEstatico: true` (equivalente a `data-bs-backdrop="static"` do Bootstrap), o usuário só consegue fechar através de uma ação explícita — botão "x", botão de ação, ou `Navigator.pop`:

```dart
DialogDefault.show(
  context: context,
  titulo: 'Processando pagamento',
  backdropEstatico: true,
  exibirBotaoFechar: false,
  corpo: const CircularProgressIndicator(),
);
```

> `fecharComEsc` é automaticamente desativado quando `backdropEstatico: true`, mesmo que informado como `true`.

---

## Cabeçalho e rodapé customizados

O cabeçalho padrão (título + botão "x") pode ser totalmente substituído via `cabecalho`:

```dart
DialogDefault.show(
  context: context,
  cabecalho: Container(
    padding: const EdgeInsets.all(16),
    color: Colors.indigo,
    child: const Text(
      'Cabeçalho customizado',
      style: TextStyle(color: Colors.white, fontSize: 18),
    ),
  ),
  corpo: const Text('Conteúdo do dialog'),
);
```

O rodapé é gerado automaticamente sempre que `acoes` não estiver vazio — os widgets são alinhados à direita com espaçamento de 8px entre eles. Se `acoes` não for informado (ou for vazio), nenhum rodapé é exibido.

---

## Sem título e sem botão fechar

Quando `titulo` é `null` e `exibirBotaoFechar` é `false`, nenhum cabeçalho é renderizado — útil para dialogs totalmente customizados (ex.: loading, imagem em destaque):

```dart
DialogDefault.show(
  context: context,
  exibirBotaoFechar: false,
  tamanho: DialogTamanho.pequeno,
  corpo: const Padding(
    padding: EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Carregando...'),
      ],
    ),
  ),
);
```

---

## Tokens do design system usados

O componente lê os seguintes tokens de `context.design` (`CoreDesignSystemTheme`):

| Token       | Uso                                             |
|-------------|--------------------------------------------------|
| `corFundo`  | Cor de fundo do dialog                            |
| `raioBorda` | Raio das bordas arredondadas (exceto `telaCheia` e iOS, que usa raio fixo de 14) |
| `corBorda`  | Cor da linha divisória entre cabeçalho/corpo e corpo/rodapé |

Se o app hospedeiro não registrar `CoreDesignSystemTheme` no `ThemeData`, os valores padrão do fallback (`corFundo: Colors.white`, `raioBorda: 8.0`) são usados.

---

## Diferenças entre plataformas

| Plataforma        | Aparência                                                        |
|--------------------|--------------------------------------------------------------------|
| Android / Web / Windows / Linux | Material — `Material` com elevação e `Icons.close` no botão fechar. |
| iOS / macOS        | Raio de borda fixo em 14 e ícone `CupertinoIcons.xmark` no botão fechar. |
