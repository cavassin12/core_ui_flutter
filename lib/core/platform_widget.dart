import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Classe base para widgets adaptativos em múltiplas plataformas.
abstract class PlatformWidget extends StatelessWidget {
  const PlatformWidget({super.key});

  // --- Métodos Obrigatórios ---
  // Quem criar o widget é OBRIGADO a definir como ele é no iOS e no Android.
  Widget createIosWidget(BuildContext context);
  Widget createAndroidWidget(BuildContext context);

  // --- Métodos Opcionais (com Fallback) ---
  // Se não forem sobrescritos, a Web e o Windows usarão o design do Android por padrão.
  Widget createWebWidget(BuildContext context) {
    return createAndroidWidget(context);
  }

  Widget createWindowsWidget(BuildContext context) {
    return createAndroidWidget(context);
  }

  /// Por padrão preserva o comportamento histórico do ecossistema Apple.
  Widget createMacosWidget(BuildContext context) {
    return createIosWidget(context);
  }

  /// Linux é uma plataforma desktop e reutiliza o widget do Windows.
  Widget createLinuxWidget(BuildContext context) {
    return createWindowsWidget(context);
  }

  @override
  Widget build(BuildContext context) {
    // 1. VALIDAÇÃO DE WEB: Sempre deve vir primeiro!
    if (kIsWeb) {
      return createWebWidget(context);
    }

    // 2. VALIDAÇÃO DE WINDOWS
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return createWindowsWidget(context);
    }

    // 3. VALIDAÇÃO DAS DEMAIS PLATAFORMAS DESKTOP
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return createMacosWidget(context);
    }
    if (defaultTargetPlatform == TargetPlatform.linux) {
      return createLinuxWidget(context);
    }

    // 4. VALIDAÇÃO IOS
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return createIosWidget(context);
    }

    // 5. PADRÃO / FALLBACK (Android, Fuchsia, etc.)
    return createAndroidWidget(context);
  }
}
