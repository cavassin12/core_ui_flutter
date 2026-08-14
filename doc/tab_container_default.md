# TabContainerDefault

Componente único de abas com conteúdo (tab container), inspirado no pacote [`tab_container`](https://github.com/sourcemain/tab_container), com todas as opções de customização traduzidas para português: posição da barra de abas, cores, bordas, dimensões, animação, tipografia e comportamento.

`StatefulWidget` (aparência única, sem variação por plataforma). Não depende do `TabController`/`vsync` do Flutter — usa animações implícitas e um controlador próprio ([TabContainerControlador](#tabcontainercontrolador)).

Arquivo: `lib/components/tab_container_default.dart`

---

## Import

```dart
import 'package:core_ui_flutter/core_ui_flutter.dart';
```

---

## Uso básico

O componente troca automaticamente o conteúdo exibido conforme a aba selecionada quando `filhos` é informado (uma lista de widgets, na mesma ordem de `abas`):

```dart
TabContainerDefault(
  abas: const [Text('Resumo'), Text('Detalhes')],
  filhos: const [ResumoView(), DetalhesView()],
  cores: const [Colors.blue, Colors.teal],
)
```

`abas` é sempre obrigatório. É necessário informar **exatamente um** entre `filhos` e `filho` (mutuamente exclusivos) — caso contrário o componente lança um `assert` em modo debug. Quando `filhos` é usado, seu tamanho precisa ser igual ao de `abas`.

---

## Modo `filho` (conteúdo controlado manualmente)

Use `filho` quando o "container de abas" deve funcionar apenas como seletor — por exemplo, quando o conteúdo já é gerenciado por um `Navigator`, `IndexedStack` externo ou qualquer outro estado fora do componente. Nesse modo, o componente não anima a troca de conteúdo; apenas notifica a seleção via `aoTrocarAba`/`controlador`, e quem usa o componente decide o que exibir:

```dart
class _MinhaTela extends State<MinhaTela> {
  int _indice = 0;

  @override
  Widget build(BuildContext context) {
    return TabContainerDefault(
      abas: const [Text('Lista'), Text('Grade')],
      filho: _indice == 0 ? const ListaView() : const GradeView(),
      aoTrocarAba: (indice) => setState(() => _indice = indice),
    );
  }
}
```

---

## Controle programático

Para selecionar uma aba de fora do componente (ex.: a partir de um botão em outra parte da tela), use um `TabContainerControlador`:

```dart
final _controlador = TabContainerControlador(indiceInicial: 0);

// em algum lugar da árvore de widgets:
TabContainerDefault(
  abas: const [Text('Aba 1'), Text('Aba 2'), Text('Aba 3')],
  filhos: const [View1(), View2(), View3()],
  controlador: _controlador,
);

// em outro widget:
ElevatedButton(
  onPressed: () => _controlador.selecionar(2),
  child: const Text('Ir para a Aba 3'),
);
```

### `TabContainerControlador`

| Membro                              | Descrição                                                        |
|--------------------------------------|------------------------------------------------------------------|
| `TabContainerControlador({int indiceInicial = 0})` | Cria o controlador com a aba inicialmente selecionada.   |
| `indice`                              | Índice da aba atualmente selecionada (getter).                   |
| `selecionar(int indice)`              | Seleciona a aba informada. Não faz nada se já for a aba ativa.   |

Quando `controlador` não é informado ao `TabContainerDefault`, o componente cria e gerencia um controlador interno automaticamente, usando `indiceInicial`.

> Lembre-se de dar `dispose()` no `TabContainerControlador` quando ele for criado e mantido fora do widget (ex.: em um `State`), assim como qualquer outro `ChangeNotifier`.

---

## Parâmetros

### Conteúdo e seleção

| Parâmetro        | Tipo                          | Padrão   | Descrição                                                                 |
|--------------------|-------------------------------|----------|------------------------------------------------------------------------------|
| `abas`               | `List<Widget>`                | obrigatório | Widgets exibidos na barra de abas.                                        |
| `filhos`             | `List<Widget>?`                | `null`   | Conteúdo de cada aba, na mesma ordem de `abas`. Mutuamente exclusivo com `filho`. |
| `filho`              | `Widget?`                      | `null`   | Conteúdo único, controlado manualmente por quem usa o componente. Mutuamente exclusivo com `filhos`. |
| `controlador`        | `TabContainerControlador?`     | `null`   | Controlador externo para seleção programática. Se omitido, é criado internamente. |
| `indiceInicial`      | `int`                           | `0`      | Aba selecionada inicialmente (ignorado quando `controlador` é informado). |
| `aoTrocarAba`        | `ValueChanged<int>?`           | `null`   | Chamado com o novo índice sempre que a aba selecionada muda.              |

### Aparência

| Parâmetro        | Tipo                    | Padrão                      | Descrição                                                        |
|--------------------|--------------------------|--------------------------------|------------------------------------------------------------------|
| `cor`                | `Color?`                 | `null`                         | Cor de fundo única do indicador de aba ativa (e leve tingimento do painel de conteúdo). Usa a cor primária do tema quando omitida. |
| `cores`              | `List<Color>?`           | `null`                         | Cores específicas por aba (sobrepõe `cor` para o índice correspondente). |
| `raioBorda`          | `double`                 | `12.0`                         | Raio das bordas externas do container.                            |
| `raioBordaAba`       | `double?`                | usa `raioBorda`                | Raio das bordas do indicador de aba ativa.                        |
| `childPadding`       | `EdgeInsetsGeometry`     | `EdgeInsets.all(16)`           | Espaçamento interno da área de conteúdo.                          |

### Posição e dimensões da barra de abas

| Parâmetro              | Tipo                | Padrão                | Descrição                                                                 |
|---------------------------|----------------------|--------------------------|--------------------------------------------------------------------------|
| `bordaAba`                  | `TabContainerBorda`  | `TabContainerBorda.superior` | Posição da barra de abas: `superior`, `inferior`, `esquerda` ou `direita`. |
| `tamanhoAba`                | `double`             | `50.0`                    | Altura da barra (bordas `superior`/`inferior`) ou largura (bordas `esquerda`/`direita`). |
| `inicioAbas`                | `double`             | `0.0`                     | Fração (0.0–1.0) de onde a barra de abas começa dentro do espaço disponível. |
| `fimAbas`                   | `double`             | `1.0`                     | Fração (0.0–1.0) de onde a barra de abas termina dentro do espaço disponível. |
| `comprimentoMinimoAba`      | `double?`            | `null`                    | Comprimento mínimo de cada aba. Quando a soma excede o espaço disponível, a barra passa a rolar. |
| `comprimentoMaximoAba`      | `double`             | `double.infinity`         | Comprimento máximo de cada aba.                                          |

### Animação

| Parâmetro           | Tipo                                                     | Padrão                          | Descrição                                                        |
|------------------------|-------------------------------------------------------------|------------------------------------|--------------------------------------------------------------------|
| `duracao`                | `Duration`                                                   | `Duration(milliseconds: 300)`     | Duração da animação do indicador (e do conteúdo, se `duracaoConteudo` for omitido). |
| `curva`                  | `Curve`                                                       | `Curves.easeInOut`                | Curva da animação do indicador (e do conteúdo, se `curvaConteudo` for omitido). |
| `duracaoConteudo`        | `Duration?`                                                   | usa `duracao`                      | Duração da transição de conteúdo entre abas.                     |
| `curvaConteudo`          | `Curve?`                                                      | usa `curva`                        | Curva da transição de conteúdo entre abas.                       |
| `construtorTransicao`    | `Widget Function(Widget filho, Animation<double> animacao)?` | `null` (fade + leve deslizamento)  | Customiza totalmente a animação de troca de conteúdo.            |

### Tipografia

| Parâmetro                       | Tipo         | Padrão   | Descrição                                                                 |
|-------------------------------------|--------------|----------|------------------------------------------------------------------------------|
| `estiloTextoSelecionado`             | `TextStyle?` | `null`   | Estilo aplicado à aba ativa quando `sobrescreverPropriedadesTexto` é `true`. |
| `estiloTextoNaoSelecionado`          | `TextStyle?` | `null`   | Estilo aplicado às abas inativas nas mesmas condições.                     |
| `sobrescreverPropriedadesTexto`      | `bool`       | `false`  | Aplica os estilos acima automaticamente sobre os widgets de `abas` (funciona melhor quando cada aba é um `Text` simples). |
| `direcaoTexto`                       | `TextDirection?` | `null` | Sobrescreve a direção de texto/layout do componente (idiomas RTL).        |

### Comportamento

| Parâmetro          | Tipo   | Padrão   | Descrição                                              |
|-----------------------|--------|----------|--------------------------------------------------------|
| `habilitado`            | `bool` | `true`   | Habilita a seleção de aba por toque.                    |
| `habilitarFeedback`     | `bool` | `true`   | Habilita feedback tátil/sonoro do sistema ao tocar em uma aba. |

---

## Posição da barra de abas

`TabContainerBorda` define onde a barra de abas fica em relação ao conteúdo:

```dart
TabContainerDefault(
  abas: const [Icon(Icons.list), Icon(Icons.grid_view)],
  filhos: const [ListaView(), GradeView()],
  bordaAba: TabContainerBorda.esquerda,
  tamanhoAba: 56,
)
```

| Valor                              | Efeito                                    |
|--------------------------------------|--------------------------------------------|
| `TabContainerBorda.superior` (padrão)| Barra de abas acima do conteúdo.           |
| `TabContainerBorda.inferior`         | Barra de abas abaixo do conteúdo.          |
| `TabContainerBorda.esquerda`         | Barra de abas à esquerda do conteúdo.      |
| `TabContainerBorda.direita`          | Barra de abas à direita do conteúdo.       |

Quando `bordaAba` é `esquerda` ou `direita`, `tamanhoAba` passa a valer para a largura da barra, e as abas se distribuem verticalmente.

---

## Abas com respiro nas laterais

`inicioAbas`/`fimAbas` deixam a barra de abas mais estreita que o container, centralizando-a ou alinhando-a conforme necessário:

```dart
TabContainerDefault(
  abas: const [Text('Semana'), Text('Mês'), Text('Ano')],
  filhos: const [SemanaView(), MesView(), AnoView()],
  inicioAbas: 0.1,
  fimAbas: 0.9, // 10% de respiro em cada lateral
)
```

---

## Rolagem automática

Quando `comprimentoMinimoAba` é definido e a soma dos comprimentos mínimos das abas excede o espaço disponível, a barra de abas passa a rolar automaticamente:

```dart
TabContainerDefault(
  abas: const [
    Text('Notificações'), Text('Mensagens'), Text('Configurações'),
    Text('Segurança'), Text('Faturamento'),
  ],
  filhos: const [/* ... */],
  comprimentoMinimoAba: 140,
)
```

---

## Cores por aba

```dart
TabContainerDefault(
  abas: const [Text('Sucesso'), Text('Alerta'), Text('Erro')],
  filhos: const [SucessoView(), AlertaView(), ErroView()],
  cores: const [Colors.green, Colors.orange, Colors.red],
)
```

---

## Transição de conteúdo customizada

```dart
TabContainerDefault(
  abas: const [Text('Aba 1'), Text('Aba 2')],
  filhos: const [View1(), View2()],
  construtorTransicao: (filho, animacao) => ScaleTransition(
    scale: animacao,
    child: filho,
  ),
)
```

---

## Tipografia automática das abas

```dart
TabContainerDefault(
  abas: const [Text('Ativo'), Text('Inativo')],
  filhos: const [AtivoView(), InativoView()],
  sobrescreverPropriedadesTexto: true,
  estiloTextoSelecionado: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ),
  estiloTextoNaoSelecionado: const TextStyle(color: Colors.black54),
)
```

---

## Desabilitado

```dart
TabContainerDefault(
  abas: const [Text('Aba 1'), Text('Aba 2')],
  filhos: const [View1(), View2()],
  habilitado: false,
)
```

Quando `habilitado: false`, a barra de abas ignora toques — a seleção só pode ser alterada programaticamente via `controlador`.
