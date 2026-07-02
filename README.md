# core_ui_flutter

Pacote de UI compartilhado com design system baseado em `ThemeExtension` do Flutter.

---

## Instalação

Adicione o pacote no `pubspec.yaml` do seu app:

```yaml
dependencies:
  core_ui_flutter:
    git:
      url: https://github.com/cavassin12/core_ui_flutter.git
```

---

## Configuração no `main.dart`

Importe o pacote e registre o `MeuDesignSystemTheme` como extensão do `ThemeData` na raiz do app:

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
          MeuDesignSystemTheme(
            corPrimaria: Color(0xFF6200EE), // Roxo customizado
            corFundo: Color(0xFFF5F5F5),    // Cinza claro
            raioBorda: 12.0,                // Botões mais arredondados
          ),
        ],
      ),
      home: const MinhaTela(),
    );
  }
}
```

> **Importante:** o `MeuDesignSystemTheme` deve ser declarado com `const` dentro de `extensions` para evitar recriações desnecessárias do tema.

---

## MeuDesignSystemTheme

Classe que define as variáveis visuais do design system. É registrada como uma extensão do `ThemeData` do Flutter.

### Propriedades

| Propriedade   | Tipo     | Descrição                              |
|---------------|----------|----------------------------------------|
| `corPrimaria` | `Color`  | Cor principal usada em botões e destaques |
| `corFundo`    | `Color`  | Cor de fundo padrão das telas          |
| `raioBorda`   | `double` | Raio dos cantos arredondados           |

---

## Configuração

Registre o tema na raiz do app, dentro do `MaterialApp`:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      MeuDesignSystemTheme(
        corPrimaria: Color(0xFF6200EE),
        corFundo: Colors.white,
        raioBorda: 12.0,
      ),
    ],
  ),
);
```

---

## Uso nos widgets

Use a extensão `context.design` para acessar as propriedades de qualquer widget:

```dart
import 'package:flutter/material.dart';
import 'meu_design_system_theme.dart';
import 'platform_widget.dart';

class MeuBotaoPrimario extends PlatformWidget {
  final String texto;
  final VoidCallback onPressed;

  const MeuBotaoPrimario({
    super.key,
    required this.texto,
    required this.onPressed,
  });

  @override
  Widget createAndroidWidget(BuildContext context) {
    final corBotao = context.design.corPrimaria;
    final borda = context.design.raioBorda;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: corBotao,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borda),
        ),
      ),
      onPressed: onPressed,
      child: Text(texto),
    );
  }

  @override
  Widget createIosWidget(BuildContext context) {
    return CupertinoButton(
      color: context.design.corPrimaria,
      borderRadius: BorderRadius.circular(context.design.raioBorda),
      onPressed: onPressed,
      child: Text(texto),
    );
  }
}
```

### Acessando propriedades individualmente

```dart
// Cor primária
context.design.corPrimaria

// Cor de fundo
context.design.corFundo

// Raio de borda
context.design.raioBorda
```

> **Fallback automático:** se o `MeuDesignSystemTheme` não for registrado no `ThemeData`, os valores padrão são `corPrimaria: Colors.blue`, `corFundo: Colors.white` e `raioBorda: 8.0`, evitando erros em tempo de execução.
