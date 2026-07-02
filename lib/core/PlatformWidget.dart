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

    // 3. VALIDAÇÃO ECOSSISTEMA APPLE (iOS / macOS)
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return createIosWidget(context);
    }

    // 4. PADRÃO / FALLBACK (Android, Linux, Fuchsia, etc.)
    return createAndroidWidget(context);
  }
}
