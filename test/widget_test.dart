import 'package:flutter_test/flutter_test.dart';

import 'package:dhara/main.dart';

void main() {
  testWidgets('App starts with sign-in screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DharaApp());

    // Verify that the app shows the sign-in screen
    expect(find.text('Dhara'), findsOneWidget);
    expect(find.text('Smart Expense Tracker'), findsOneWidget);
    expect(find.text('Sign in with Google'), findsOneWidget);
  });
}
