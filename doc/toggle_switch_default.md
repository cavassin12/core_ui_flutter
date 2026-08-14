# ToggleSwitchDefault

Componente único de switch com múltiplas opções (segmented control), inspirado no pacote [`toggle_switch`](https://github.com/PramodJoshi/toggle_switch), com todos os parâmetros de customização traduzidos para português: rótulos, ícones, cores, larguras, bordas, animação, orientação vertical/horizontal, desseleção e cancelamento assíncrono da troca.

`StatefulWidget` (aparência única, sem variação por plataforma).

Arquivo: `lib/components/toggle_switch_default.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

```dart
ToggleSwitchDefault(
  rotulos: const ['Dia', 'Semana', 'Mês'],
  indiceInicial: 0,
  aoAlternar: (indice) => print('Selecionado: $indice'),
)
```

Pelo menos um destes deve ser informado, para que o componente saiba quantas opções renderizar: `rotulos`, `icones`, `widgetsPersonalizados` ou `totalOpcoes`.

---

## Rótulo + ícone

```dart
ToggleSwitchDefault(
  rotulos: const ['Ativo', 'Inativo'],
  icones: const [Icons.check, Icons.close],
  corFundoAtivo: Colors.green,
  aoAlternar: (indice) => print('Selecionado: $indice'),
)
```

## Widgets totalmente customizados

`widgetsPersonalizados` substitui completamente o conteúdo padrão (rótulo + ícone) de cada opção — útil para avatares, badges, etc.:

```dart
ToggleSwitchDefault(
  totalOpcoes: 2,
  widgetsPersonalizados: const [
    Icon(Icons.grid_view, color: Colors.white),
    Icon(Icons.list, color: Colors.white),
  ],
)
```

---

## Parâmetros

### Conteúdo

| Parâmetro                | Tipo             | Padrão   | Descrição                                                                 |
|----------------------------|------------------|----------|------------------------------------------------------------------------------|
| `rotulos`                   | `List<String>?`  | `null`   | Textos exibidos em cada opção.                                              |
| `icones`                    | `List<IconData>?`| `null`   | Ícones exibidos em cada opção (podem ser combinados com `rotulos`).         |
| `widgetsPersonalizados`     | `List<Widget>?`  | `null`   | Substitui totalmente o conteúdo padrão da opção correspondente.             |
| `totalOpcoes`               | `int?`           | `null`   | Número total de opções. Se omitido, é inferido a partir de `rotulos`, `icones` ou `widgetsPersonalizados`. |

### Seleção

| Parâmetro                | Tipo                                                      | Padrão   | Descrição                                                                 |
|----------------------------|-------------------------------------------------------------|----------|------------------------------------------------------------------------------|
| `indiceInicial`             | `int?`                                                       | `0`      | Índice selecionado inicialmente. `null` = nenhuma opção selecionada.       |
| `aoAlternar`                | `ValueChanged<int?>?`                                        | `null`   | Chamado quando a seleção muda. Recebe `null` ao desselecionar.             |
| `cancelarAlternancia`       | `Future<bool> Function(int? indiceAtual, int novoIndice)?`   | `null`   | Chamado antes de trocar de opção; retornar `false` cancela a troca.        |
| `permitirDesselecionar`     | `bool`                                                       | `false`  | Permite desselecionar tocando novamente na opção ativa (seleção vira `null`). |
| `ignorarToqueRepetido`      | `bool`                                                       | `true`   | Ignora toques na opção já selecionada (não dispara `aoAlternar` de novo). Sem efeito quando `permitirDesselecionar` é `true`. |
| `desabilitado`              | `bool`                                                       | `false`  | Desabilita todas as interações (opacidade reduzida e toques ignorados).    |

### Dimensões

| Parâmetro                | Tipo             | Padrão   | Descrição                                                                 |
|----------------------------|------------------|----------|------------------------------------------------------------------------------|
| `larguraMinima`             | `double`         | `72`     | Largura mínima de cada opção quando a divisão é igualitária.                |
| `altura`                    | `double`         | `38`     | Altura de cada opção do switch.                                              |
| `largurasPersonalizadas`    | `List<double>?`  | `null`   | Larguras fixas por opção. Quando informado, as opções deixam de se dividir igualmente pelo espaço disponível. |

### Aparência

| Parâmetro                | Tipo             | Padrão                | Descrição                                                        |
|----------------------------|------------------|-------------------------|----------------------------------------------------------------------|
| `raioCanto`                 | `double`         | `8`                     | Raio dos cantos do switch. Ignorado quando `estiloPilula` é `true`. |
| `estiloPilula`              | `bool`           | `false`                 | Cantos totalmente arredondados (formato de "pílula").               |
| `corFundoAtivo`             | `Color`          | `Colors.blue`           | Cor de fundo da opção ativa.                                          |
| `coresFundoAtivo`           | `List<Color>?`   | `null`                  | Cores de fundo ativas por opção (sobrepõe `corFundoAtivo`).          |
| `corTextoAtivo`             | `Color`          | `Colors.white`          | Cor do texto/ícone da opção ativa.                                    |
| `corFundoInativo`           | `Color`          | `Color(0xFFE5E7EB)`     | Cor de fundo das opções inativas / trilho do switch.                 |
| `corTextoInativo`           | `Color`          | `Colors.black87`        | Cor do texto/ícone das opções inativas.                               |
| `corBorda`                  | `Color?`         | `null`                  | Cor da borda externa do switch. `null` = sem borda.                  |
| `larguraBorda`              | `double`         | `0`                     | Espessura da borda externa e respiro entre o indicador ativo e a borda do trilho. |
| `corDivisor`                | `Color?`         | `null`                  | Cor do divisor entre as opções inativas.                             |
| `elevacao`                  | `double`         | `0`                     | Elevação/sombra do switch. `0` remove a sombra.                      |

### Texto

| Parâmetro                     | Tipo                     | Padrão   | Descrição                                                        |
|----------------------------------|--------------------------|----------|------------------------------------------------------------------|
| `tamanhoFonte`                    | `double`                 | `14`     | Tamanho da fonte dos rótulos.                                     |
| `tamanhoIcone`                    | `double`                 | `18`     | Tamanho dos ícones.                                                |
| `estilosTextoPersonalizados`      | `List<TextStyle>?`       | `null`   | Estilos individuais por opção (sobrepõe `tamanhoFonte` e cores).  |
| `centralizarTexto`                | `bool`                   | `true`   | Centraliza o conteúdo (rótulo/ícone) de cada opção.                |
| `textoMultilinha`                 | `bool`                   | `false`  | Permite quebra de linha em vez de cortar com reticências.         |
| `direitaParaEsquerda`             | `bool`                   | `false`  | Força layout/texto da direita para a esquerda (idiomas RTL).      |

### Animação

| Parâmetro         | Tipo       | Padrão                          | Descrição                                     |
|---------------------|------------|------------------------------------|--------------------------------------------------|
| `animar`             | `bool`     | `true`                             | Anima a transição do indicador ao trocar de opção. |
| `duracaoAnimacao`    | `Duration` | `Duration(milliseconds: 200)`      | Duração da animação (quando `animar` é `true`).  |
| `curvaAnimacao`      | `Curve`    | `Curves.easeInOut`                 | Curva da animação (quando `animar` é `true`).    |

### Layout

| Parâmetro   | Tipo   | Padrão   | Descrição                                              |
|---------------|--------|----------|------------------------------------------------------------|
| `vertical`     | `bool` | `false`  | Exibe as opções na vertical (empilhadas) em vez de na horizontal. |

---

## Larguras fixas por opção

Por padrão, as opções dividem igualmente o espaço disponível (respeitando `larguraMinima`). Para opções com larguras diferentes, informe `largurasPersonalizadas` na mesma ordem das opções:

```dart
ToggleSwitchDefault(
  rotulos: const ['Todos', 'Ativos', 'Inativos'],
  largurasPersonalizadas: const [70, 90, 100],
)
```

Nesse modo, o switch passa a ter largura total igual à soma das larguras informadas (não preenche o espaço disponível do pai).

---

## Múltiplas cores por opção

```dart
ToggleSwitchDefault(
  rotulos: const ['Baixa', 'Média', 'Alta'],
  coresFundoAtivo: const [Colors.green, Colors.orange, Colors.red],
)
```

---

## Confirmação assíncrona antes de trocar

Use `cancelarAlternancia` para exibir uma confirmação (ou validar algo assincronamente) antes de efetivar a troca de opção. Retornar `false` mantém o switch na opção atual:

```dart
ToggleSwitchDefault(
  rotulos: const ['Rascunho', 'Publicado'],
  indiceInicial: 0,
  cancelarAlternancia: (indiceAtual, novoIndice) async {
    if (novoIndice == 1) {
      return await DialogDefault.confirmar(
        context: context,
        titulo: 'Publicar',
        mensagem: 'Deseja publicar este conteúdo agora?',
      );
    }
    return true;
  },
  aoAlternar: (indice) => print('Selecionado: $indice'),
)
```

---

## Permitindo desselecionar

Por padrão, tocar na opção já selecionada não faz nada (`ignorarToqueRepetido: true`). Para permitir que o usuário limpe a seleção tocando novamente na opção ativa, use `permitirDesselecionar: true`:

```dart
ToggleSwitchDefault(
  rotulos: const ['Curtir'],
  totalOpcoes: 1,
  indiceInicial: null,
  permitirDesselecionar: true,
  corFundoAtivo: Colors.pink,
  aoAlternar: (indice) => print(indice == null ? 'Descurtido' : 'Curtido'),
)
```

---

## Orientação vertical

```dart
ToggleSwitchDefault(
  rotulos: const ['Norte', 'Sul', 'Leste', 'Oeste'],
  vertical: true,
  altura: 40,
)
```

Na orientação vertical, `altura` passa a valer para cada opção individualmente (a altura total do switch é `altura * totalOpcoes`).

---

## Desabilitado

```dart
ToggleSwitchDefault(
  rotulos: const ['Opção A', 'Opção B'],
  desabilitado: true,
)
```

Quando `desabilitado: true`, o switch fica com opacidade reduzida e ignora toques, independentemente dos demais parâmetros de seleção.
