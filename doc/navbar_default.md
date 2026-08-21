# NavbarDefault

Barra horizontal para dashboards, baseada no `.navbar` do Bootstrap. Pode ser usada em `Scaffold.appBar`, pois implementa `PreferredSizeWidget`.

```dart
Scaffold(
  appBar: NavbarDefault(
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
| `elevado` | `bool` | `false` | Exibe sombra inferior sutil. |

`NavbarItemDefault` recebe `texto`, `icone`, `ativo`, `disabled` e `aoTocar`.
