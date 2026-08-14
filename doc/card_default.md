# CardDefault

Componente único de card do design system, com o mesmo comportamento do componente [`Card`](https://getbootstrap.com/docs/5.3/components/card/) do Bootstrap: cabeçalho, corpo (título/subtítulo/texto/links ou conteúdo customizado), rodapé, imagem no topo/rodapé, imagem de fundo com conteúdo sobreposto (`card-img-overlay`), lista interna (`list-group` dentro do card), layout horizontal e cores/bordas customizáveis.

`StatelessWidget` (aparência única, sem variação por plataforma). Usa os tokens do design system via `context.design` (`corFundo`, `corBorda`, `raioBorda`).

Arquivo: `lib/components/card_default.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

```dart
CardDefault(
  imagemTopo: Image.network(
    'https://exemplo.com/imagem.jpg',
    height: 160,
    fit: BoxFit.cover,
  ),
  titulo: 'Título do card',
  subtitulo: 'Subtítulo',
  texto: 'Um texto de exemplo dentro do card.',
  links: [
    TextButton(onPressed: () {}, child: const Text('Ação 1')),
    TextButton(onPressed: () {}, child: const Text('Ação 2')),
  ],
)
```

Por padrão, o card ocupa toda a largura disponível do widget pai — igual ao Bootstrap, onde `.card` é `width: 100%` por padrão.

---

## Parâmetros

### Imagens

| Parâmetro                | Tipo     | Padrão   | Descrição                                                                 |
|------------------------------|----------|----------|--------------------------------------------------------------------------|
| `imagemTopo`                   | `Widget?`| `null`   | Imagem no topo do card, ocupando toda a largura (`card-img-top`). Em `horizontal: true`, é exibida na lateral esquerda. |
| `imagemRodape`                 | `Widget?`| `null`   | Imagem na base do card (`card-img-bottom`). Ignorada quando `horizontal` é `true`. |
| `imagemFundo`                  | `Widget?`| `null`   | Ativa o modo `card-img-overlay`: a imagem preenche todo o card e o corpo fica sobreposto a ela. Ver [Imagem de fundo (overlay)](#imagem-de-fundo-overlay). |
| `larguraImagemLateral`         | `double` | `140.0`  | Largura de `imagemTopo` quando `horizontal` é `true`.                    |

### Estrutura

| Parâmetro       | Tipo             | Padrão   | Descrição                                                                 |
|--------------------|--------------------|----------|--------------------------------------------------------------------------|
| `cabecalho`           | `Widget?`            | `null`   | Faixa exibida no topo do card, acima do corpo (`card-header`).           |
| `rodape`              | `Widget?`            | `null`   | Faixa exibida na base do card, abaixo do corpo (`card-footer`).          |
| `corpo`               | `Widget?`            | `null`   | Substitui totalmente o corpo padrão (título/subtítulo/texto/links).      |
| `itensLista`          | `List<Widget>?`      | `null`   | Itens exibidos como lista dentro do card, separados por divisores (equivalente a um `list-group` dentro de `card`). Exibida abaixo do corpo. |

### Corpo padrão (ignorados quando `corpo` é informado)

| Parâmetro   | Tipo             | Padrão   | Descrição                                                     |
|---------------|--------------------|----------|--------------------------------------------------------------------|
| `titulo`        | `String?`            | `null`   | Título do corpo (`card-title`).                                    |
| `subtitulo`     | `String?`            | `null`   | Subtítulo exibido abaixo do título, em tom mais claro (`card-subtitle`). |
| `texto`         | `String?`            | `null`   | Texto principal do corpo (`card-text`).                            |
| `links`         | `List<Widget>?`      | `null`   | Links/ações exibidos ao final do corpo, lado a lado (`card-link`).  |

### Layout

| Parâmetro         | Tipo                 | Padrão               | Descrição                                                        |
|-----------------------|------------------------|--------------------------|--------------------------------------------------------------------|
| `horizontal`             | `bool`                  | `false`                    | Exibe `imagemTopo` na lateral esquerda em vez de no topo (card horizontal). |
| `largura`                | `double?`               | `null` (100% do pai)       | Largura fixa do card.                                                |
| `altura`                 | `double?`               | `null`                      | Altura fixa do card.                                                 |
| `espacamentoCorpo`       | `EdgeInsetsGeometry`    | `EdgeInsets.all(16)`        | Espaçamento interno do corpo do card.                                |

### Aparência

| Parâmetro     | Tipo     | Padrão                        | Descrição                                                        |
|-------------------|----------|-----------------------------------|----------------------------------------------------------------------|
| `corFundo`           | `Color?` | `context.design.corFundo`           | Cor de fundo do card.                                                 |
| `corTexto`           | `Color?` | `null`                              | Cor do texto padrão de todo o conteúdo do card — propagada via `DefaultTextStyle`, como o utilitário `text-white` do Bootstrap. |
| `corBorda`           | `Color?` | `context.design.corBorda`           | Cor da borda do card e dos divisores internos (cabeçalho/rodapé/lista). |
| `larguraBorda`       | `double` | `1.0`                                | Espessura da borda do card. `0` remove a borda.                     |
| `raioBorda`          | `double?`| `context.design.raioBorda`          | Raio das bordas do card.                                              |
| `elevacao`           | `double` | `0.0`                                | Elevação/sombra do card (o Bootstrap não aplica sombra por padrão — some para lá se quiser algo como `shadow-sm`). |

### Interação

| Parâmetro   | Tipo             | Padrão   | Descrição                                     |
|---------------|--------------------|----------|----------------------------------------------------|
| `aoTocar`       | `VoidCallback?`      | `null`   | Torna o card inteiro tocável, com efeito visual de toque (`InkWell`). |

---

## Cabeçalho, corpo e rodapé

```dart
CardDefault(
  cabecalho: const Text('Recomendado', style: TextStyle(fontWeight: FontWeight.bold)),
  titulo: 'Plano Pro',
  texto: 'Tudo que você precisa para crescer.',
  rodape: const Text('Atualizado há 2 dias', style: TextStyle(fontSize: 12, color: Colors.grey)),
)
```

`cabecalho` e `rodape` recebem um leve tingimento de fundo (equivalente ao `rgba(0,0,0,.03)` do Bootstrap) e uma borda que os separa do corpo, usando `corBorda`.

---

## Corpo customizado

Use `corpo` para substituir completamente título/subtítulo/texto/links por qualquer widget:

```dart
CardDefault(
  corpo: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(Icons.star, color: Colors.amber),
      const SizedBox(height: 8),
      const Text('Avaliação 4.8'),
      const LinearProgressIndicator(value: 0.8),
    ],
  ),
)
```

---

## Lista interna (`list-group`)

```dart
CardDefault(
  cabecalho: const Text('Itens do pedido'),
  itensLista: const [
    Text('2x Produto A — R\$ 20,00'),
    Text('1x Produto B — R\$ 15,00'),
    Text('Frete — R\$ 5,00'),
  ],
  rodape: const Text('Total: R\$ 40,00', style: TextStyle(fontWeight: FontWeight.bold)),
)
```

Os itens são separados por divisores usando `corBorda`, sem o padding extra do `corpo`.

---

## Imagem de fundo (overlay)

```dart
CardDefault(
  imagemFundo: Image.network(
    'https://exemplo.com/paisagem.jpg',
    height: 220,
    fit: BoxFit.cover,
  ),
  titulo: 'Card com imagem de fundo',
  texto: 'Texto sobreposto à imagem.',
  corTexto: Colors.white,
)
```

Nesse modo, `cabecalho`, `rodape`, `itensLista` e `horizontal` são ignorados — o card vira apenas a imagem com o corpo sobreposto no canto inferior esquerdo.

---

## Card horizontal

```dart
CardDefault(
  horizontal: true,
  larguraImagemLateral: 120,
  imagemTopo: Image.network(
    'https://exemplo.com/thumb.jpg',
    fit: BoxFit.cover,
  ),
  titulo: 'Notícia em destaque',
  texto: 'Resumo da notícia exibida ao lado da imagem.',
)
```

---

## Card tocável

```dart
CardDefault(
  titulo: 'Configurações',
  texto: 'Toque para abrir',
  aoTocar: () => Navigator.of(context).pushNamed('/configuracoes'),
)
```

---

## Cores customizadas (equivalente a `bg-*`/`text-white`/`border-*`)

```dart
CardDefault(
  corFundo: Colors.indigo,
  corTexto: Colors.white,
  corBorda: Colors.transparent,
  titulo: 'Card colorido',
  texto: 'Texto branco sobre fundo indigo.',
)
```

---

## Múltiplos cards em grade

Combine com [`GridLinha`/`GridColuna`](grid_default.md) para reproduzir o `card-deck`/`row-cols-*` do Bootstrap:

```dart
GridLinha(
  filhos: const [
    GridColuna(colunas: 12, colunasMd: 4, filho: CardDefault(titulo: 'Card 1', texto: '...')),
    GridColuna(colunas: 12, colunasMd: 4, filho: CardDefault(titulo: 'Card 2', texto: '...')),
    GridColuna(colunas: 12, colunasMd: 4, filho: CardDefault(titulo: 'Card 3', texto: '...')),
  ],
)
```
