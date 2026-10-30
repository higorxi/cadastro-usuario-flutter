import 'package:cadastro_usuario/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('campos vazios mostram erros; válidos mostram sucesso',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 1600);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('CADASTRAR'));
    await tester.pump();
    expect(find.text('Informe o nome completo'), findsOneWidget);
    expect(find.text('Informe o e-mail'), findsOneWidget);
    expect(find.text('Informe a senha'), findsOneWidget);

    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), 'Maria Silva');
    await tester.enterText(campos.at(1), 'maria@teste.com');
    await tester.enterText(campos.at(2), '12a345678901'); // letra é filtrada
    await tester.enterText(campos.at(3), '11999998888');
    await tester.enterText(campos.at(4), '123456');
    await tester.enterText(campos.at(5), '123456');
    await tester.tap(find.text('CADASTRAR'));
    await tester.pump();
    expect(find.text('Cadastro realizado com sucesso!'), findsOneWidget);
  });
}
