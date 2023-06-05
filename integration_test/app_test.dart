import 'package:firetrip/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firetrip/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End to end testing', () {
    testWidgets(
        'given login screen when user enters correct email and password he should be taken to the home screen',
        (widgetTester) async {
      await app.main();

      await widgetTester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 5));
      await widgetTester.pumpAndSettle();
      //email
      await widgetTester.enterText(
          find.byType(TextFormField).at(0), 'shria@gmail.con');
      await widgetTester.testTextInput.receiveAction(TextInputAction.done);
      await Future.delayed(const Duration(seconds: 2));
      await widgetTester.pumpAndSettle();
      //password
      await widgetTester.enterText(find.byType(TextFormField).at(1), '123456');
      await widgetTester.testTextInput.receiveAction(TextInputAction.done);
      await Future.delayed(const Duration(seconds: 2));
      await widgetTester.pumpAndSettle();

      // tapping login button
      await widgetTester.tap(find.byType(ElevatedButton));
      await Future.delayed(const Duration(seconds: 2));
      await widgetTester.pumpAndSettle();

      expect(find.byType(HomeView), findsOneWidget);
    });
  });
}
