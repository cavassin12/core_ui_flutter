import 'package:flutter/foundation.dart';

/// Controlador opcional para selecionar a aba ativa do `TabContainerDefault`
/// de forma programática (equivalente ao `TabController` do pacote
/// `tab_container`, sem depender de um `TickerProvider` externo).
///
/// ```dart
/// final controlador = TabContainerControlador(indiceInicial: 0);
/// // ...
/// controlador.selecionar(2);
/// ```
class TabContainerControlador extends ChangeNotifier {
  int _indice;

  TabContainerControlador({int indiceInicial = 0}) : _indice = indiceInicial;

  /// Índice da aba atualmente selecionada.
  int get indice => _indice;

  /// Seleciona a aba de índice [indice]. Não faz nada se já for a aba ativa.
  void selecionar(int indice) {
    if (_indice == indice) return;
    _indice = indice;
    notifyListeners();
  }
}
