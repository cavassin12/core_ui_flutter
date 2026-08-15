# SnackbarDefault

Conteúdo customizado para `SnackBar`/`MaterialBanner`, com um estilo em "bolha" (ícone circular sobreposto, splash decorativo e cores por tipo de conteúdo), baseado no padrão do pacote [`awesome_snackbar_content`](https://pub.dev/packages/awesome_snackbar_content).

`StatelessWidget`. Este componente é o **conteúdo** a ser passado para `SnackBar.content` ou `MaterialBanner.content` — ele não exibe a snackbar sozinho.

Arquivo: `lib/components/snackbar_default.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: SnackbarDefault(
      title: 'Sucesso!',
      message: 'Registro salvo com êxito.',
      contentType: ContentType.success,
    ),
  ),
);
```

> `backgroundColor: Colors.transparent` e `elevation: 0` no `SnackBar` são necessários — o próprio `SnackbarDefault` desenha seu fundo colorido e cantos arredondados.

---

## Parâmetros

| Parâmetro          | Tipo             | Padrão      | Descrição                                                                 |
|----------------------|-------------------|--------------|------------------------------------------------------------------------------|
| `title`               | `String`           | obrigatório  | Título em destaque, exibido na primeira linha.                              |
| `message`             | `String`           | obrigatório  | Mensagem do corpo (até 2 linhas em telas móveis, 3 em telas maiores; trunca com reticências). |
| `contentType`         | `ContentType`      | obrigatório  | Define a cor de fundo e o ícone exibidos. Ver [ContentType](#contenttype).   |
| `color`               | `Color?`           | `null`       | Sobrepõe a cor de fundo definida por `contentType`.                          |
| `inMaterialBanner`    | `bool`             | `false`      | Ver [Uso com MaterialBanner](#uso-com-materialbanner).                       |
| `titleTextStyle`      | `TextStyle?`       | `null`       | Sobrepõe o estilo padrão do título.                                          |
| `messageTextStyle`    | `TextStyle?`       | `null`       | Sobrepõe o estilo padrão da mensagem.                                        |

---

## `ContentType`

`ContentType` (em `lib/models/snackbar/content_type.dart`) define quatro variantes prontas, cada uma com cor e ícone próprios:

| Valor                    | Cor                    | Ícone       |
|----------------------------|--------------------------|-------------|
| `ContentType.success`        | verde (`#2D6A4F`)         | check       |
| `ContentType.failure`        | vermelho (`#C72C41`)      | X           |
| `ContentType.warning`        | laranja (`#FCA652`)       | exclamação  |
| `ContentType.help`           | azul (`#3282B8`)          | interrogação|

```dart
SnackbarDefault(title: 'Erro', message: 'Não foi possível salvar.', contentType: ContentType.failure);
```

---

## Uso com MaterialBanner

```dart
ScaffoldMessenger.of(context).showMaterialBanner(
  MaterialBanner(
    elevation: 0,
    backgroundColor: Colors.transparent,
    content: SnackbarDefault(
      title: 'Atenção',
      message: 'Você tem alterações não salvas.',
      contentType: ContentType.warning,
      inMaterialBanner: true,
    ),
    actions: const [SizedBox.shrink()], // MaterialBanner exige ao menos 1 action
  ),
);
```

`inMaterialBanner: true` faz o botão de fechar (ícone "x") chamar `ScaffoldMessenger.hideCurrentMaterialBanner()` em vez de `hideCurrentSnackBar()`.

---

## Responsividade

O layout se adapta à largura da tela (`MediaQuery`), com breakpoints próprios (independentes de `GridQuebra`): até 768px é tratado como "mobile" (fontes menores, menos margem lateral) e de 768px a 992px como "tablet" (mais margem lateral). Acima de 992px, a margem lateral cresce ainda mais para não esticar a snackbar em telas largas.

---

## Assets necessários

Este componente depende de arquivos SVG (`assets/snackbar/back.svg`, `bubbles.svg`, `success.svg`, `failure.svg`, `warning.svg`, `help.svg`) que já fazem parte do pacote `core_ui_flutter`. Como o `SvgPicture.asset(...)` interno não é chamado com `package: 'core_ui_flutter'`, o Flutter resolve esses caminhos a partir do **bundle do app hospedeiro**, não do pacote — para os ícones aparecerem corretamente, o app que consome `core_ui_flutter` precisa declarar esses mesmos arquivos (nos mesmos caminhos relativos, `assets/snackbar/...`) na sua própria `pubspec.yaml`.
