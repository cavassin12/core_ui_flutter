# NavbarDefault

Barra horizontal para dashboards, baseada no `.navbar` do Bootstrap. Pode ser usada em `Scaffold.appBar`, pois implementa `PreferredSizeWidget`.

```dart
Scaffold(
  appBar: NavbarDefault(
    usarContainer: true,
    larguraMaxima: 1320,
    marca: const Text('Analytics'),
    itens: [
      NavbarItemDefault(texto: 'Visão geral', icone: Icons.dashboard, ativo: true),
      NavbarItemDefault(texto: 'Relatórios', icone: Icons.assessment, aoTocar: abrirRelatorios),
    ],
    itensCustomizados: [
      NavbarDropdownDefault(texto: 'Configurações', itens: itensConfiguracao),
    ],
    acoes: [
      IconButton(onPressed: abrirPerfil, icon: const Icon(Icons.person_outline)),
    ],
  ),
)
```

| Parâmetro | Tipo | Padrão | Descrição |
|---|---|---|---|
| `marca` | `Widget?` | `null` | Logotipo, nome do produto ou outro widget exibido à esquerda. |
| `itens` | `List<NavbarItemDefault>` | `[]` | Links do menu principal. Em telas estreitas, podem ser rolados horizontalmente. |
| `itensCustomizados` | `List<Widget>` | `[]` | Itens adicionais no fluxo principal, como `NavbarDropdownDefault`. |
| `acoes` | `List<Widget>` | `[]` | Widgets fixados à direita, como avatar, notificações ou `NavbarDropdownDefault`. |
| `corFundo` | `Color?` | `context.design.corNavbar` | Fundo da barra. |
| `corTexto` | `Color?` | `context.design.corNavbarTexto` | Cor dos textos e ícones. |
| `corItemAtivo` | `Color?` | `context.design.corPrimaria` | Cor do item selecionado. |
| `altura` | `double?` | `context.design.alturaNavbar` | Altura da barra. |
| `usarContainer` | `bool` | `true` | Centraliza o conteúdo em uma largura máxima, mantendo o fundo em largura total. Use `false` para o comportamento fluido. |
| `larguraMaxima` | `double` | `1320` | Largura máxima do conteúdo quando `usarContainer` está habilitado. |
| `padding` | `EdgeInsetsGeometry` | `horizontal: 16` | Respiro interno aplicado ao conteúdo, inclusive em telas menores que a largura máxima. |
| `elevado` | `bool` | `false` | Exibe sombra inferior sutil. |

`NavbarItemDefault` recebe `texto`, `icone`, `ativo`, `disabled` e `aoTocar`.

O fundo da navbar sempre ocupa toda a largura. Com `usarContainer: true`, somente
marca, menus e ações são limitados e centralizados. Para dashboards que precisam
usar toda a viewport, configure `usarContainer: false`, equivalente ao
`.container-fluid` do Bootstrap.
