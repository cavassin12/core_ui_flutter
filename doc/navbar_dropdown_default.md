# NavbarDropdownDefault

Item de menu expansível para uso em `NavbarDefault.itensCustomizados`, inspirado em `.nav-item.dropdown` do Bootstrap. Os itens usam `DropdownItemDefault`, portanto há suporte a ícones, estado ativo/desabilitado, cabeçalhos e divisores.

```dart
NavbarDropdownDefault(
  texto: 'Configurações',
  icone: Icons.settings_outlined,
  itens: [
    DropdownItemDefault(label: 'Equipe', onTap: abrirEquipe),
    const DropdownItemDefault.divider(),
    DropdownItemDefault(label: 'Sair', onTap: sair),
  ],
)
```

| Parâmetro | Tipo | Padrão | Descrição |
|---|---|---|---|
| `texto` | `String` | obrigatório | Rótulo do item na navbar. |
| `itens` | `List<DropdownItemDefault>` | obrigatório | Conteúdo do menu suspenso. |
| `icone` | `IconData?` | `null` | Ícone antes do rótulo. |
| `ativo` | `bool` | `false` | Destaca o trigger como item atual. |
| `disabled` | `bool` | `false` | Impede a abertura do menu. |
| `larguraMenu` | `double?` | `null` | Largura do menu; padrão entre 180 e 320 px conforme o trigger. |

O menu fecha ao selecionar um item, ao clicar fora dele ou ao pressionar `Esc`.
