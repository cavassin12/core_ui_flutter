import 'package:core_ui_flutter/core_ui_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) {
  return MaterialApp(
    theme: CoreDesignSystemTheme.claro.criarThemeData(),
    home: child,
  );
}

void main() {
  testWidgets('renderiza os três modelos e o botão do Google', (tester) async {
    for (final modelo in CoreAuthGrapheusModel.values) {
      await tester.pumpWidget(
        _app(CoreAuthGrapheus(modelo: modelo, aoEntrar: (_) {})),
      );
      expect(find.text('Acessar o sistema'), findsOneWidget);
      expect(find.text('Continuar com Google'), findsOneWidget);
      expect(find.byType(InputDefault), findsNWidgets(2));
    }
  });

  testWidgets('entrega email e senha ao callback de autenticação', (
    tester,
  ) async {
    CoreAuthGrapheusCredentials? recebido;
    await tester.pumpWidget(
      _app(
        CoreAuthGrapheus(
          modelo: CoreAuthGrapheusModel.cardCentral,
          aoEntrar: (credenciais) => recebido = credenciais,
        ),
      ),
    );

    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), 'usuario@grapheus.com.br');
    await tester.enterText(campos.at(1), 'senha-segura');
    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(recebido?.email, 'usuario@grapheus.com.br');
    expect(recebido?.senha, 'senha-segura');
  });
}
