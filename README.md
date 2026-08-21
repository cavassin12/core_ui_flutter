# core_ui_flutter

Pacote Flutter (não é um app) com um design system de UI compartilhado, consumido por outros apps via dependência git. Disponibiliza widgets adaptativos por plataforma (Android, iOS/macOS, Web, Windows) e uma extensão de tema (`ThemeExtension`) para os tokens visuais compartilhados.

---

## Instalação

Adicione o pacote no `pubspec.yaml` do seu app:

```yaml
dependencies:
  core_ui_flutter:
    git:
      url: https://github.com/cavassin12/core_ui_flutter.git
```

E rode:

```bash
flutter pub get
```

---

## Configuração no `main.dart`

Importe o pacote e registre o `CoreDesignSystemTheme` como extensão do `ThemeData` na raiz do app:

```dart
import 'package:flutter/material.dart';
import 'package:core_ui_flutter/core_ui_flutter.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App com Design System',
      theme: ThemeData(
        // Injetando as configurações do pacote no tema do app
        extensions: const [
          CoreDesignSystemTheme(
            corPrimaria: Color(0xFF6200EE), // Roxo customizado
            corFundo: Color(0xFFF5F5F5),    // Cinza claro
            raioBorda: 12.0,                // Botões/cards mais arredondados
          ),
        ],
      ),
      home: const MinhaTela(),
    );
  }
}
```

> **Importante:** o `CoreDesignSystemTheme` deve ser declarado com `const` dentro de `extensions` para evitar recriações desnecessárias do tema.

---

## `CoreDesignSystemTheme`

Classe que define os tokens visuais compartilhados do design system (`lib/code_design_system_theme.dart`), registrada como uma extensão do `ThemeData` do Flutter.

| Propriedade            | Tipo     | Padrão do fallback | Descrição                                                          |
|--------------------------|----------|----------------------|--------------------------------------------------------------------|
| `corPrimaria`              | `Color`   | `Colors.blue`         | Cor principal usada em botões, destaques e itens ativos.           |
| `corFundo`                 | `Color`   | `Colors.white`        | Cor de fundo padrão de cards, dialogs e outros containers.         |
| `raioBorda`                | `double`  | `8.0`                 | Raio dos cantos arredondados dos componentes.                      |
| `corBorda`                 | `Color`   | `#E2E8F0`              | Borda de cards, tabelas e outros containers.                       |
| `corCabecalhoTabela`       | `Color`   | `#F8FAFC`              | Fundo do cabeçalho de tabelas (`TableGrid`).                        |
| `corLinhaSelecionada`      | `Color`   | `#DCE9FB`              | Fundo de uma linha de tabela selecionada.                           |
| `corLinhaHover`            | `Color`   | `#F1F5F9`              | Fundo de uma linha de tabela em hover (plataformas com mouse).      |

Apenas `corPrimaria`, `corFundo` e `raioBorda` são obrigatórios ao instanciar — os demais têm valores padrão.

### Acessando os tokens nos widgets

Os componentes do pacote (e os do seu app) leem os tokens através da extensão `context.design`:

```dart
context.design.corPrimaria
context.design.corFundo
context.design.raioBorda
```

> **Fallback automático:** se o `CoreDesignSystemTheme` não for registrado no `ThemeData` do app hospedeiro, os valores padrão da tabela acima são usados automaticamente — os componentes nunca quebram por falta de configuração de tema.

---

## Componentes

Todos os componentes abaixo são exportados por `package:core_ui_flutter/core_ui_flutter.dart` — não é necessário importar arquivos individuais do pacote.

| Componente | Descrição | Documentação |
|---|---|---|
| **AccordionDefault** | Lista de seções expansíveis (acordeão), com número máximo de seções abertas, animação, ícones, cores/bordas por seção, rolagem automática e feedback tátil. | [doc/accordion_default.md](doc/accordion_default.md) |
| **AppBarDefault** | Barra superior do app (navbar), com botão de voltar automático, ações, faixa inferior opcional e aparência nativa por plataforma (Material/Cupertino). | [doc/app_bar_default.md](doc/app_bar_default.md) |
| **ButtonDefault** | Botão com cor resolvida automaticamente por severidade (primary/danger/warning/success/info), suporte a ícone + texto e variação de tamanho. | [doc/button_default.md](doc/button_default.md) |
| **CardDefault** | Card no estilo Bootstrap: cabeçalho, corpo, rodapé, imagem no topo/rodapé, imagem de fundo com overlay, lista interna e layout horizontal. | [doc/card_default.md](doc/card_default.md) |
| **CheckboxDefault** | Checkbox com transição animada entre estados e suporte a widgets customizados dentro da caixa. | [doc/checkbox_default.md](doc/checkbox_default.md) |
| **DatePickerDefault** | Seleção de data e/ou hora, reaproveitando o InputDefault como campo de exibição e abrindo o seletor nativo (Material/Cupertino) ao tocar. | [doc/date_picker_default.md](doc/date_picker_default.md) |
| **DialogDefault** | Dialog/modal no estilo Bootstrap: tamanhos, centralização, rolagem, backdrop estático, fechamento por ESC/clique fora e variante tela-cheia. | [doc/dialog_default.md](doc/dialog_default.md) |
| **DropdownDefault** | Dropdown no estilo Bootstrap: botão trigger, direção down/up, itens com ícone/ativo/desabilitado, divisores, cabeçalhos, tamanhos, variante dark e auto-close configurável. | [doc/dropdown_default.md](doc/dropdown_default.md) |
| **GridLinha / GridColuna** | Sistema de grid responsivo de 12 colunas, com breakpoints, colunas automáticas, offset e reordenação — equivalente a `row`/`col-*` do Bootstrap. | [doc/grid_default.md](doc/grid_default.md) |
| **IconeDefaultComponent** | Resolve e exibe um ícone a partir de várias formas de entrada: catálogo padrão, `IconData` direto, ou nome de ícone Lucide em texto. | [doc/icone_default_component.md](doc/icone_default_component.md) |
| **InputDefault** | Campo de texto com validação embutida (obrigatório, e-mail, min/max), máscara simples, normalização de números e alternância de senha. | [doc/input_default.md](doc/input_default.md) |
| **MoneyDefault** | Campo de valores monetários com máscara em tempo real, casas decimais e separadores de milhar/decimal configuráveis. | [doc/money_default.md](doc/money_default.md) |
| **NavbarDefault** | Barra horizontal responsiva para dashboards, com marca, links de navegação e ações. | [doc/navbar_default.md](doc/navbar_default.md) |
| **NavbarTabsDefault** | Abas horizontais controladas nos estilos Bootstrap `nav-tabs` e `nav-pills`. | [doc/navbar_tabs_default.md](doc/navbar_tabs_default.md) |
| **NavbarDropdownDefault** | Dropdown para uso em menus horizontais, com itens, divisores e cabeçalhos. | [doc/navbar_dropdown_default.md](doc/navbar_dropdown_default.md) |
| **PaginationDefault** | Paginação avulsa (botões numéricos, anterior/próxima, primeira/última), reutilizável em qualquer lista fora do TableGrid. | [doc/pagination_default.md](doc/pagination_default.md) |
| **ProgressBarDefault** | Barra de progresso linear determinada ou indeterminada, com rótulo/percentual opcional. | [doc/progress_bar_default.md](doc/progress_bar_default.md) |
| **SelectDefault** | Campo de seleção com busca opcional (bottom sheet com filtro), suporte a `Map`/objetos como opções, e fluxo de cadastro auxiliar. | [doc/select_default.md](doc/select_default.md) |
| **SnackbarDefault** | Conteúdo customizado para `SnackBar`/`MaterialBanner`, com estilo em "bolha" e cores por tipo de conteúdo (sucesso/erro/aviso/ajuda). | [doc/snackbar_default.md](doc/snackbar_default.md) |
| **TabContainerDefault** | Abas com conteúdo (tab container), com posição da barra, cores, bordas, animação e controlador próprio para seleção programática. | [doc/tab_container_default.md](doc/tab_container_default.md) |
| **TableGrid** | Tabela de dados com colunas dinâmicas, seleção de linhas, expansão de sub-grade, ações por linha, paginação lazy e filtro de excluídos. | [doc/table_grid.md](doc/table_grid.md) |
| **ToggleSwitchDefault** | Switch com múltiplas opções (segmented control): rótulos, ícones, cores, animação, orientação e desseleção. | [doc/toggle_switch_default.md](doc/toggle_switch_default.md) |

---

## `PlatformWidget`

Todos os componentes acima estendem `PlatformWidget` (`lib/core/platform_widget.dart`), que centraliza a ramificação por plataforma:

```dart
class MeuComponente extends PlatformWidget {
  @override
  Widget createAndroidWidget(BuildContext context) { /* obrigatório */ }

  @override
  Widget createIosWidget(BuildContext context) { /* obrigatório */ }

  // Opcionais — usam createAndroidWidget como padrão se não sobrescritos
  @override
  Widget createWebWidget(BuildContext context) => super.createWebWidget(context);

  @override
  Widget createWindowsWidget(BuildContext context) => super.createWindowsWidget(context);
}
```

A resolução de plataforma segue esta ordem: Web (`kIsWeb`) → Windows → iOS/macOS → fallback Android (cobre também Linux e Fuchsia).
