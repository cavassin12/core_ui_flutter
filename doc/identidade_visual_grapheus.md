# Identidade visual Grapheus

## Uso rápido

```dart
MaterialApp(
  theme: GrapheusTheme.claro(modulo: GrapheusModulo.crm),
  darkTheme: GrapheusTheme.escuro(modulo: GrapheusModulo.crm),
  themeMode: ThemeMode.system,
  home: const MinhaPagina(),
)
```

O módulo altera somente a cor primária/destaque. Superfícies, tipografia,
estados semânticos, espaçamentos e contraste continuam compartilhados.

## Cores institucionais

| Token | Claro | Escuro |
|---|---|---|
| Primária | `#2563EB` | `#60A5FA` |
| Primária profunda | `#1E3A8A` | — |
| Destaque | `#0D9488` | `#2DD4BF` |
| Fundo | `#F4F7FB` | `#0B1120` |
| Superfície | `#FFFFFF` | `#172033` |
| Texto | `#172033` | `#F8FAFC` |
| Texto secundário | `#64748B` | `#CBD5E1` |
| Borda | `#DCE3EC` | `#334155` |
| Sucesso | `#16A34A` | `#22C55E` |
| Aviso | `#D97706` | `#F59E0B` |
| Erro | `#DC2626` | `#F87171` |

### Destaque por módulo

| Módulo | Cor |
|---|---|
| Gastronomia | `#EA580C` |
| Agro | `#15803D` |
| FaturaPrime | `#2563EB` |
| CRM | `#7C3AED` |
| DocDigital | `#0891B2` |
| Conta Porco | `#BE185D` |
| Serviços | `#0F766E` |
| Marketplace | `#4F46E5` |

Use `GrapheusCores` em vez de repetir valores hexadecimais nos componentes.

## Tipografia

- **Inter:** interface, formulários, botões, tabelas e textos.
- **Manrope:** títulos e elementos institucionais.
- **Roboto Mono:** valores financeiros, identificadores e códigos.

`GrapheusTheme` configura automaticamente Inter e Manrope. Para conteúdo
numérico ou técnico:

```dart
Text(
  'R$ 1.250,00',
  style: GrapheusTipografia.monoespacada(
    base: Theme.of(context).textTheme.bodyMedium,
  ),
)
```

### Escala

| Elemento | Fonte | Peso | Tamanho |
|---|---|---:|---:|
| Título de página | Manrope | 700 | 28–32 |
| Título mobile | Manrope | 600–700 | 24–28 |
| Subtítulo | Inter | 400 | 15–16 |
| Corpo | Inter | 400 | 14–16 |
| Label | Inter | 500 | 14 |
| Botão | Inter | 600 | 15 |
| Mensagem auxiliar/erro | Inter | 400 | 12 |
| Número/código | Roboto Mono | 500 | contexto |

## Fontes em produção

O pacote usa `google_fonts`. Durante o desenvolvimento, as fontes podem ser
obtidas e armazenadas em cache automaticamente. Aplicações que precisam iniciar
sem rede devem incluir os arquivos Inter, Manrope e Roboto Mono nos assets do
aplicativo. O `google_fonts` prioriza automaticamente arquivos compatíveis
declarados no asset manifest.

Não altere tipografia, cores de erro ou contraste diretamente no
`CoreAuthGrapheus`. A personalização deve entrar pelo tema para permanecer
consistente em todos os componentes.
