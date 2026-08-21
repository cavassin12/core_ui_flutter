# CoreAuthGrapheus

Componente reutilizável de página de login, com campos de e-mail e senha e
layouts próprios para mobile e desktop. Android e iOS usam a composição mobile;
web, Windows, Linux e macOS usam a composição desktop.

## Modelos

- `CoreAuthGrapheusModel.painelVisual`: imagem/painel lateral e formulário.
- `CoreAuthGrapheusModel.painelDestaque`: formulário com painel de boas-vindas.
- `CoreAuthGrapheusModel.cardCentral`: card central minimalista.

O parâmetro `modelo` é obrigatório. Novos layouts devem ser acrescentados ao
enum `CoreAuthGrapheusModel`.

## Uso

```dart
CoreAuthGrapheus(
  modelo: CoreAuthGrapheusModel.painelDestaque,
  titulo: 'Entrar no Grapheus',
  subtitulo: 'Use sua conta para continuar',
  aoEntrar: (credenciais) async {
    await ApiService.post(
      '/auth/login',
      data: {
        'email': credenciais.email,
        'senha': credenciais.senha,
      },
    );
  },
)
```

Configure a identidade visual no aplicativo:

```dart
MaterialApp(
  theme: GrapheusTheme.claro(modulo: GrapheusModulo.faturaPrime),
  darkTheme: GrapheusTheme.escuro(modulo: GrapheusModulo.faturaPrime),
  home: CoreAuthGrapheus(
    modelo: CoreAuthGrapheusModel.cardCentral,
    aoEntrar: autenticar,
  ),
)
```

O pacote não depende diretamente do `ApiService`. A integração ocorre pelo
callback `aoEntrar`, permitindo que cada aplicativo use sua configuração de
endpoint, interceptadores, armazenamento de token e tratamento de erros.

`painelVisual` aceita qualquer widget, como `Image.asset` ou `Image.network`.
Quando não informado, o componente usa um gradiente baseado no design system.
O botão do Google é apenas visual e não executa autenticação nesta versão.
Ele usa a superfície neutra do tema para não competir com a ação principal.
