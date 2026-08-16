# AppBarDefault

Barra superior do app, equivalente ao `navbar` do Bootstrap adaptado para o padrão de barra de título/navegação de aplicativos móveis e web: título, botão de voltar automático, ações à direita e uma faixa opcional abaixo (`bottom`).

Implementa `PreferredSizeWidget` — pode ser usado diretamente em `Scaffold.appBar`.

Estende `PlatformWidget`: usa `AppBar` (Material) no Android/Web/Windows e `CupertinoNavigationBar` no iOS/macOS. Diferente da maioria dos componentes do pacote, esta é uma variação **intencional** entre plataformas — a barra de navegação tem convenções visuais bem distintas entre Material e Cupertino (título centralizado x alinhado à esquerda, seta x chevron de voltar, com/sem sombra).

Arquivo: `lib/components/app_bar_default.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

```dart
Scaffold(
  appBar: AppBarDefault(titulo: 'Minha Tela'),
  body: const Placeholder(),
)
```

---

## Parâmetros

| Parâmetro           | Tipo                     | Padrão            | Descrição                                                                 |
|-----------------------|----------------------------|--------------------|------------------------------------------------------------------------------|
| `titulo`               | `String?`                  | `null`             | Título exibido na barra. Ignorado quando `tituloWidget` é informado.        |
| `tituloWidget`         | `Widget?`                  | `null`             | Substitui totalmente o título padrão por um widget customizado.             |
| `acoes`                | `List<Widget>?`            | `null`             | Ações exibidas à direita da barra.                                          |
| `leading`              | `Widget?`                  | `null`             | Substitui totalmente o widget inicial (à esquerda), incluindo o botão de voltar automático. |
| `exibirBotaoVoltar`    | `bool`                     | `true`             | Exibe um botão de voltar automático quando a rota atual pode ser desfeita (`Navigator.canPop`). Ignorado quando `leading` é informado. |
| `aoVoltar`             | `VoidCallback?`            | `null`             | Chamado ao tocar no botão de voltar automático, no lugar do `Navigator.pop()` padrão. |
| `corFundo`             | `Color?`                   | `context.design.corPrimaria` | Cor de fundo da barra.                                            |
| `corTexto`             | `Color?`                   | `Colors.white`     | Cor do título/ícones/ações.                                                 |
| `elevacao`             | `double`                   | `0.0`              | Elevação/sombra da barra (Android/Web/Windows). No iOS, qualquer valor maior que zero apenas remove a borda transparente padrão. |
| `centralizarTitulo`    | `bool`                     | `false`            | Centraliza o título no Android/Web/Windows. No iOS o título é sempre centralizado (comportamento nativo do `CupertinoNavigationBar`, não configurável). |
| `bottom`               | `PreferredSizeWidget?`     | `null`             | Faixa opcional exibida abaixo da barra (ex.: abas). Ignorada no iOS — se precisar de abas no iOS, coloque-as no `body` da tela. |
| `altura`               | `double`                   | `kToolbarHeight`   | Altura da faixa principal da barra (sem contar `bottom`).                   |

---

## Botão de voltar automático

```dart
Scaffold(
  appBar: AppBarDefault(titulo: 'Detalhes'), // exibe voltar automaticamente
  body: const Placeholder(),
);

// Ou intercepte o toque:
AppBarDefault(
  titulo: 'Editar',
  aoVoltar: () async {
    final confirmou = await DialogDefault.confirmar(
      context: context,
      titulo: 'Descartar alterações?',
      mensagem: 'Você tem alterações não salvas.',
    );
    if (confirmou) Navigator.of(context).pop();
  },
)
```

O botão só aparece quando `Navigator.of(context).canPop()` é `true` — em uma tela raiz (sem rota anterior), nenhum botão de voltar é exibido, mesmo com `exibirBotaoVoltar: true`.

---

## Ações e cores customizadas

```dart
AppBarDefault(
  titulo: 'Pedidos',
  corFundo: Colors.indigo,
  acoes: [
    IconButton(icon: const Icon(Icons.search), onPressed: () {}),
    IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
  ],
)
```

---

## Com faixa inferior (`bottom`)

```dart
AppBarDefault(
  titulo: 'Relatórios',
  bottom: const TabBar(tabs: [Tab(text: 'Diário'), Tab(text: 'Mensal')]),
)
```

`bottom` aceita qualquer `PreferredSizeWidget` (ex.: o `TabBar` nativo do Flutter). No iOS, `bottom` é ignorado — o `CupertinoNavigationBar` não tem uma área equivalente nativa.

---

## Tokens do design system usados

| Token         | Uso                              |
|---------------|------------------------------------|
| `corPrimaria`   | Cor de fundo padrão da barra (quando `corFundo` não é informado). |
