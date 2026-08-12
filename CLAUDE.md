# CLAUDE.md

Este arquivo fornece orientações ao Claude Code (claude.ai/code) ao trabalhar com código neste repositório.

## O que é isto

`core_ui_flutter` é um **pacote** Flutter (não um app) que fornece um design system de UI compartilhado para ser consumido por outros apps Flutter via dependência git (ver instruções de instalação no README.md). Ele disponibiliza widgets adaptativos e uma extensão de tema, feito para ser importado como `package:core_ui_flutter/core_ui_flutter.dart`.

## Comandos

- Obter dependências: `flutter pub get`
- Rodar todos os testes: `flutter test`
- Rodar um único arquivo de teste: `flutter test test/core_ui_flutter_test.dart`
- Análise estática (usa `flutter_lints`): `flutter analyze`

Não há etapa de build/run — este pacote não possui um app de exemplo; ele é consumido por outros projetos.

## Arquitetura

### Widgets adaptativos via `PlatformWidget`

`lib/core/PlatformWidget.dart` define uma classe base abstrata que todos os componentes adaptativos por plataforma devem estender. Ela centraliza a lógica de ramificação por plataforma para que os widgets individuais nunca precisem fazer checagens como `if (Platform.isIOS)` por conta própria:

- `createIosWidget` e `createAndroidWidget` são overrides **obrigatórios**.
- `createWebWidget` e `createWindowsWidget` são overrides opcionais que **usam `createAndroidWidget` como padrão** caso não sejam sobrescritos.
- `build()` resolve a plataforma nesta ordem: Web (`kIsWeb`, verificado primeiro pois o Flutter web pode reportar qualquer `defaultTargetPlatform`) → Windows → iOS/macOS → fallback para a implementação Android (cobre Android, Linux, Fuchsia).

Novos componentes adaptativos devem estender `PlatformWidget` e seguir esse padrão em vez de ramificar por plataforma diretamente no código.

### Design system via `ThemeExtension`

`lib/code_design_system_theme.dart` define `CoreDesignSystemTheme`, uma `ThemeExtension<CoreDesignSystemTheme>` que guarda os tokens de design compartilhados (`corPrimaria`, `corFundo`, `raioBorda`). Os apps consumidores registram essa extensão em `ThemeData.extensions`.

Os componentes leem os tokens através do getter de extensão `context.design` (`MeuDesignSystemContextX` em `BuildContext`), que recorre a valores padrão fixos (`Colors.blue` / `Colors.white` / `8.0`) caso o app hospedeiro nunca tenha registrado a extensão — esse fallback existe para que os componentes nunca quebrem por falta de configuração de tema, e deve ser preservado ao adicionar novos tokens.

Ao adicionar um novo token de design: adicione o campo em `CoreDesignSystemTheme`, conecte-o tanto em `copyWith` quanto em `lerp`, e defina um valor padrão sensato no fallback de `context.design`.

### Superfície de exports do pacote

`lib/core_ui_flutter.dart` é o único ponto de entrada público que os apps importam. **Todo novo componente público ou classe de tema deve ser exportado aqui** para poder ser usado fora do pacote — atualmente este arquivo só exporta uma classe placeholder `Calculator` e precisa ser atualizado conforme componentes reais forem adicionados (componentes já existentes como `MeuBotaoPrimario` ainda não estão exportados).

### Padrão de componente

Veja `lib/components/MeuBotaoPrimario.dart` como implementação de referência: ele estende `PlatformWidget`, obtém os tokens de `context.design` (ex.: `corPrimaria`, `raioBorda`) dentro de cada builder específico de plataforma, e só sobrescreve `createWebWidget` quando a experiência web realmente precisa ser diferente (ex.: áreas de toque maiores, cursor de hover) — caso contrário, a implementação Android é reaproveitada automaticamente.
