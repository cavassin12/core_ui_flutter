# NavbarTabsDefault

Abas horizontais controladas, equivalentes a `.nav-tabs` ou `.nav-pills` do Bootstrap. O componente emite o índice escolhido; o conteúdo do dashboard é responsabilidade da tela consumidora.

```dart
NavbarTabsDefault(
  abas: const [
    NavbarTabItemDefault(texto: 'Resumo'),
    NavbarTabItemDefault(texto: 'Indicadores', icone: Icons.bar_chart),
  ],
  indiceAtivo: abaAtual,
  aoTrocar: (indice) => setState(() => abaAtual = indice),
)
```

Defina `pills: true` para a variante arredondada `.nav-pills`. Cada `NavbarTabItemDefault` aceita `texto`, `icone` e `disabled`.

| Parâmetro | Tipo | Padrão | Descrição |
|---|---|---|---|
| `abas` | `List<NavbarTabItemDefault>` | obrigatório | Abas na ordem exibida. |
| `indiceAtivo` | `int` | `0` | Índice selecionado. |
| `aoTrocar` | `ValueChanged<int>?` | `null` | Recebe o índice escolhido. |
| `pills` | `bool` | `false` | Alterna entre `.nav-tabs` e `.nav-pills`. |
| `corAtiva` | `Color?` | `context.design.corPrimaria` | Cor do indicador ou fundo da aba ativa. |
| `corTexto` | `Color?` | `Theme.colorScheme.onSurface` | Cor base dos rótulos. |
