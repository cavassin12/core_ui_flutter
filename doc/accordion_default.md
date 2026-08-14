# AccordionDefault

Componente único de acordeão (lista de seções expansíveis), inspirado no pacote [`accordion`](https://github.com/GotJimmy/accordion), com todas as opções de customização traduzidas para português: número máximo de seções abertas, animação, ícones, cores/bordas/espaçamentos (globais e por seção), rolagem automática até a seção aberta e feedback tátil.

`StatefulWidget` (aparência única, sem variação por plataforma).

Arquivo: `lib/components/accordion_default.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

```dart
AccordionDefault(
  itens: [
    AccordionItem(
      cabecalho: const Text('Seção 1'),
      conteudo: const Text('Conteúdo da seção 1'),
    ),
    AccordionItem(
      cabecalho: const Text('Seção 2'),
      conteudo: const Text('Conteúdo da seção 2'),
    ),
  ],
)
```

Por padrão, o `AccordionDefault` já é rolável (é um `ListView` internamente) e mantém no máximo **1** seção aberta por vez — abrir uma nova seção fecha automaticamente a anterior.

---

## `AccordionItem`

Cada seção é descrita por um `AccordionItem`, com `cabecalho` e `conteudo` obrigatórios. Os demais campos são overrides opcionais que sobrepõem, apenas para aquela seção, os valores globais definidos no `AccordionDefault`.

| Parâmetro                        | Tipo                   | Descrição                                                                 |
|------------------------------------|------------------------|--------------------------------------------------------------------------|
| `cabecalho`                          | `Widget`                | Obrigatório. Widget sempre visível, exibido no cabeçalho da seção.       |
| `conteudo`                           | `Widget`                | Obrigatório. Widget exibido quando a seção está aberta.                  |
| `abertoInicialmente`                 | `bool`                  | Define se a seção já inicia aberta. Padrão `false`.                      |
| `aoAbrir`                            | `VoidCallback?`         | Chamado quando a seção é aberta.                                          |
| `aoFechar`                           | `VoidCallback?`         | Chamado quando a seção é fechada (inclusive quando fechada automaticamente por `maximoSecoesAbertas`). |
| `corFundoCabecalho`                  | `Color?`                | Sobrepõe `AccordionDefault.corFundoCabecalho` para esta seção.             |
| `corFundoCabecalhoAberto`            | `Color?`                | Sobrepõe `AccordionDefault.corFundoCabecalhoAberto` para esta seção.       |
| `corBordaCabecalho`                  | `Color?`                | Sobrepõe `AccordionDefault.corBordaCabecalho` para esta seção.             |
| `corBordaCabecalhoAberto`            | `Color?`                | Sobrepõe `AccordionDefault.corBordaCabecalhoAberto` para esta seção.       |
| `larguraBordaCabecalho`              | `double?`               | Sobrepõe `AccordionDefault.larguraBordaCabecalho` para esta seção.         |
| `espacamentoCabecalho`               | `EdgeInsetsGeometry?`   | Sobrepõe `AccordionDefault.espacamentoCabecalho` para esta seção.          |
| `iconeEsquerdo`                      | `Widget?`               | Widget exibido à esquerda do cabeçalho (nenhum por padrão).               |
| `iconeDireito`                       | `Widget?`               | Sobrepõe `AccordionDefault.iconeDireitoPadrao` para esta seção.            |
| `corFundoConteudo`                   | `Color?`                | Sobrepõe `AccordionDefault.corFundoConteudo` para esta seção.              |
| `corBordaConteudo`                   | `Color?`                | Sobrepõe `AccordionDefault.corBordaConteudo` para esta seção.              |
| `larguraBordaConteudo`               | `double?`               | Sobrepõe `AccordionDefault.larguraBordaConteudo` para esta seção.          |
| `raioBorda`                          | `double?`               | Sobrepõe `AccordionDefault.raioBorda` (cabeçalho e conteúdo) para esta seção. |
| `espacamentoHorizontalConteudo`      | `double?`               | Sobrepõe `AccordionDefault.espacamentoHorizontalConteudo` para esta seção. |
| `espacamentoVerticalConteudo`        | `double?`               | Sobrepõe `AccordionDefault.espacamentoVerticalConteudo` para esta seção.   |

---

## Parâmetros de `AccordionDefault`

### Conteúdo e comportamento

| Parâmetro                          | Tipo                | Padrão   | Descrição                                                                 |
|---------------------------------------|----------------------|----------|--------------------------------------------------------------------------|
| `itens`                                 | `List<AccordionItem>` | obrigatório | Seções exibidas pelo acordeão, na ordem desejada.                     |
| `maximoSecoesAbertas`                   | `int`                 | `1`      | Número máximo de seções abertas ao mesmo tempo. Ao exceder, a seção aberta há mais tempo é fechada automaticamente. |
| `desabilitarRolagem`                    | `bool`                | `false`  | Desativa a rolagem interna — use quando o acordeão já estiver dentro de uma lista/scroll externo. |

### Animação

| Parâmetro                       | Tipo       | Padrão                          | Descrição                                                        |
|-------------------------------------|------------|-------------------------------------|--------------------------------------------------------------------|
| `animarAberturaFechamento`            | `bool`     | `true`                              | Habilita animação ao abrir/fechar as seções.                      |
| `escalarDuranteAnimacao`              | `bool`     | `true`                              | Aplica um leve efeito de escala ao conteúdo durante a abertura.   |
| `atrasoSequenciaAberturaInicial`      | `Duration` | `Duration.zero`                     | Atraso antes de abrir automaticamente as seções com `abertoInicialmente: true` — produz um efeito de abertura ao montar a tela em vez de já nascerem abertas. |
| `duracaoAnimacao`                     | `Duration` | `Duration(milliseconds: 300)`       | Duração da animação de abrir/fechar e de rotação dos ícones.      |
| `curvaAnimacao`                       | `Curve`    | `Curves.easeInOut`                  | Curva da animação de abrir/fechar.                                |

### Ícones

| Parâmetro                          | Tipo     | Padrão                              | Descrição                                                        |
|----------------------------------------|----------|-----------------------------------------|--------------------------------------------------------------------|
| `inverterIconeEsquerdoSeAberto`          | `bool`   | `false`                                 | Rotaciona 180° o `AccordionItem.iconeEsquerdo` quando a seção está aberta. |
| `inverterIconeDireitoSeAberto`           | `bool`   | `true`                                  | Rotaciona 180° o ícone direito quando a seção está aberta.        |
| `iconeDireitoPadrao`                     | `Widget` | `Icon(Icons.keyboard_arrow_down)`       | Ícone direito usado quando a seção não define `AccordionItem.iconeDireito`. |

### Espaçamento da lista

| Parâmetro                    | Tipo     | Padrão   | Descrição                                          |
|-----------------------------------|----------|----------|--------------------------------------------------------|
| `espacamentoTopoLista`              | `double` | `20.0`   | Espaçamento acima da primeira seção.                    |
| `espacamentoRodapeLista`            | `double` | `40.0`   | Espaçamento abaixo da última seção.                     |
| `espacamentoHorizontalLista`        | `double` | `10.0`   | Espaçamento horizontal aplicado a toda a lista.         |
| `espacamentoEntreSecoesFechadas`    | `double` | `3.0`    | Distância entre duas seções quando ambas estão fechadas. |
| `espacamentoEntreSecoesAbertas`     | `double` | `10.0`   | Distância entre duas seções quando uma delas está aberta. |

### Cores e bordas do cabeçalho (padrão global)

| Parâmetro                    | Tipo                 | Padrão                                        | Descrição                                              |
|-----------------------------------|-----------------------|--------------------------------------------------|--------------------------------------------------------|
| `corFundoCabecalho`                 | `Color?`              | cor primária do tema                             | Cor de fundo do cabeçalho fechado.                     |
| `corFundoCabecalhoAberto`           | `Color?`              | `corFundoCabecalho`                              | Cor de fundo do cabeçalho aberto.                      |
| `corBordaCabecalho`                 | `Color?`              | cor primária do tema                             | Cor da borda do cabeçalho fechado.                     |
| `corBordaCabecalhoAberto`           | `Color?`              | `corBordaCabecalho`                              | Cor da borda do cabeçalho aberto.                      |
| `larguraBordaCabecalho`             | `double`              | `0.0`                                            | Espessura da borda do cabeçalho.                       |
| `espacamentoCabecalho`              | `EdgeInsetsGeometry`  | `EdgeInsets.symmetric(horizontal: 20, vertical: 10)` | Espaçamento interno do cabeçalho.                  |

### Cores e bordas do conteúdo (padrão global)

| Parâmetro                        | Tipo     | Padrão            | Descrição                                    |
|----------------------------------------|----------|---------------------|---------------------------------------------------|
| `corFundoConteudo`                       | `Color`  | `Colors.white`       | Cor de fundo do conteúdo.                         |
| `corBordaConteudo`                       | `Color`  | `Colors.white`       | Cor da borda do conteúdo.                         |
| `larguraBordaConteudo`                   | `double` | `0.0`                | Espessura da borda do conteúdo.                   |
| `raioBorda`                              | `double` | `20.0`               | Raio das bordas do cabeçalho e do conteúdo.       |
| `espacamentoHorizontalConteudo`          | `double` | `10.0`               | Espaçamento horizontal interno do conteúdo.       |
| `espacamentoVerticalConteudo`            | `double` | `10.0`               | Espaçamento vertical interno do conteúdo.         |

### Rolagem automática e feedback tátil

| Parâmetro                | Tipo                     | Padrão                          | Descrição                                                        |
|-----------------------------|----------------------------|-------------------------------------|--------------------------------------------------------------------|
| `rolarParaSecaoAoAbrir`       | `AccordionRolagem`           | `AccordionRolagem.nenhuma`           | Rola automaticamente até a seção ao abri-la. Ver [Rolagem automática](#rolagem-automática). |
| `feedbackHapticoAoAbrir`      | `AccordionFeedbackHaptico`   | `AccordionFeedbackHaptico.nenhum`    | Feedback tátil disparado ao abrir uma seção.                      |
| `feedbackHapticoAoFechar`     | `AccordionFeedbackHaptico`   | `AccordionFeedbackHaptico.nenhum`    | Feedback tátil disparado ao fechar uma seção.                     |

---

## Múltiplas seções abertas

```dart
AccordionDefault(
  maximoSecoesAbertas: 3,
  itens: [
    AccordionItem(cabecalho: const Text('Item 1'), conteudo: const Text('...')),
    AccordionItem(cabecalho: const Text('Item 2'), conteudo: const Text('...')),
    AccordionItem(cabecalho: const Text('Item 3'), conteudo: const Text('...')),
    AccordionItem(cabecalho: const Text('Item 4'), conteudo: const Text('...')),
  ],
)
```

Com `maximoSecoesAbertas: 3`, ao abrir uma 4ª seção a mais antiga entre as 3 abertas é fechada automaticamente (comportamento de fila).

---

## Seções abertas por padrão e sequência de abertura

```dart
AccordionDefault(
  atrasoSequenciaAberturaInicial: const Duration(milliseconds: 400),
  itens: [
    AccordionItem(
      cabecalho: const Text('Perguntas frequentes'),
      conteudo: const Text('Resposta...'),
      abertoInicialmente: true,
    ),
    AccordionItem(cabecalho: const Text('Outra seção'), conteudo: const Text('...')),
  ],
)
```

Sem `atrasoSequenciaAberturaInicial`, as seções marcadas com `abertoInicialmente: true` já aparecem abertas no primeiro frame (sem animação visível). Definindo um atraso, o acordeão nasce fechado e abre essas seções automaticamente após o tempo informado, com a mesma animação usada ao tocar em uma seção.

---

## Cores e ícones customizados

```dart
AccordionDefault(
  corFundoCabecalho: Colors.grey.shade200,
  corFundoCabecalhoAberto: Colors.blue,
  corBordaCabecalho: Colors.transparent,
  itens: [
    AccordionItem(
      cabecalho: const Text('Seção especial'),
      conteudo: const Text('...'),
      corFundoCabecalhoAberto: Colors.deepPurple, // sobrepõe o global apenas aqui
      iconeEsquerdo: const Icon(Icons.info_outline, color: Colors.white),
    ),
  ],
)
```

---

## Callbacks de abertura/fechamento

```dart
AccordionDefault(
  itens: [
    AccordionItem(
      cabecalho: const Text('Termos'),
      conteudo: const Text('...'),
      aoAbrir: () => print('Seção de termos aberta'),
      aoFechar: () => print('Seção de termos fechada'),
    ),
  ],
)
```

> A recomendação do pacote original se aplica aqui também: evite envolver o `AccordionDefault` inteiro em rebuilds de estado externos desnecessários (ex.: um `setState` do widget pai a cada interação não relacionada), para não disparar reconstruções que interrompam as animações em andamento.

---

## Dentro de uma lista já rolável

```dart
SingleChildScrollView(
  child: Column(
    children: [
      const CabecalhoDaTela(),
      AccordionDefault(
        desabilitarRolagem: true,
        itens: const [/* ... */],
      ),
    ],
  ),
)
```

---

## Rolagem automática

Quando `rolarParaSecaoAoAbrir` é diferente de `AccordionRolagem.nenhuma`, o acordeão rola automaticamente até a seção assim que ela é aberta — útil em listas longas, para garantir que o conteúdo recém-aberto fique visível:

```dart
AccordionDefault(
  rolarParaSecaoAoAbrir: AccordionRolagem.rapida,
  itens: const [/* muitas seções */],
)
```

| Valor                          | Efeito                                  |
|-----------------------------------|--------------------------------------------|
| `AccordionRolagem.nenhuma` (padrão)| Não rola automaticamente.                  |
| `AccordionRolagem.rapida`          | Rola com animação curta (200ms).            |
| `AccordionRolagem.lenta`           | Rola com animação mais suave (500ms).       |

---

## Feedback tátil

```dart
AccordionDefault(
  feedbackHapticoAoAbrir: AccordionFeedbackHaptico.leve,
  feedbackHapticoAoFechar: AccordionFeedbackHaptico.selecao,
  itens: const [/* ... */],
)
```

`AccordionFeedbackHaptico` mapeia diretamente para `HapticFeedback` do Flutter: `nenhum`, `leve` (`lightImpact`), `medio` (`mediumImpact`), `pesado` (`heavyImpact`) e `selecao` (`selectionClick`).
